// OSS 直传：先向网页端要一次上传签名，再把文件 multipart 传到 OSS。
//
// 为什么必须绕网页端：AccessKey/Bucket/Endpoint 只存在于网页端服务端（AGENTS.md 第五条），
// 客户端拿到的只是一个覆盖单次上传的 policy 与 signature，对象 key 也由服务端生成
// （`{prefix}YYYY/MM/<uuid>.<ext>`，不信任客户端路径）。
//
// 用法（客户端目前只有头像用到它，学生不出题）：
//   final key = await service.uploadAvatar(filePath: x.path, contentType: 'image/png');
//   await userRepository.updateProfile(name: ..., schoolId: ..., avatarUrl: key);
// 展示地址不要自己拼——交给 core/network/oss_url.dart。
//
// 别照搬网页端 lib/upload.js：那边还管图片压缩与 media 登记，这里只做签名 + 直传。

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mianyang_quiz/core/config/env.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/data/models/media/oss_sign_result.dart';
// supabase_flutter 里也有 Headers / MultipartFile（来自 http 与 postgrest），
// 与 dio 的同名——这里以 dio 为准，hide 掉前者。
import 'package:supabase_flutter/supabase_flutter.dart'
    hide AuthException, Headers, MultipartFile;

/// 上传用途。取值必须与网页端 app/api/oss/sign/route.js 的 PURPOSES 一致——
/// 多一个字面量服务端就回「未知的用途类型」，而**大小与 MIME 白名单也在服务端**，
/// 客户端不重复校验（端上校验只是为了少跑一趟网络）。
abstract final class OssPurpose {
  /// 题目媒体（图片/音视频/附件）。上限按类型分档，真源在服务端 lib/media-spec.js：
  /// 图片 ≤20MB、音频 ≤200MB、视频 ≤1GB、文档 ≤200MB。
  static const String questionMedia = 'question_media';

  /// 头像，≤5MB，仅 image/png、image/jpeg、image/webp。
  static const String avatar = 'avatar';
}

class OssUploadService {
  OssUploadService(this._client, {Dio? dio}) : _dio = dio ?? Dio();

  final SupabaseClient _client;
  final Dio _dio;

  /// 取一次上传签名。鉴权用当前会话的 access token（Bearer），
  /// 所以**必须先登录**——未登录直接抛 AuthException，不发请求。
  ///
  /// [size] 是文件字节数，服务端按用途校验上限；[contentType] 必须精确匹配
  /// 白名单（如 image/png），否则签名里 eq Content-Type 的条件会让上传被 OSS 拒绝。
  /// 失败时解析服务端的 `{error: "中文文案"}` 并原样抛出（例如「文件过大」）。
  Future<OssSignResult> sign({
    required String purpose,
    required String contentType,
    required int size,
  }) async {
    try {
      final token = _client.auth.currentSession?.accessToken;
      if (token == null) throw const AuthException();
      final response = await _dio.post<Map<String, dynamic>>(
        '${Env.apiBaseUrl}/api/oss/sign',
        data: {'purpose': purpose, 'contentType': contentType, 'size': size},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: Headers.jsonContentType,
          // 4xx 也让 dio 把响应体交出来：{error: …} 正是要给用户看的话
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      final body = response.data;
      if (response.statusCode != 200 || body == null) {
        throw ServerException(
          _errorOf(body) ?? '获取上传签名失败（HTTP ${response.statusCode}）',
        );
      }
      return OssSignResult.fromJson(body);
    } catch (error) {
      throw mapError(error); // 上面抛的 AppException 会被原样透出
    }
  }

  /// 直传文件到 [sign] 里的 uploadUrl。
  ///
  /// 两个不能动的细节：fields **全部**作为 multipart 表单字段（顺序也照返回的顺序），
  /// 以及 **file 必须放最后**——OSS 只在最后一个字段收到文件后才开始落盘，
  /// 顺序错了会以 400 结束。成功标准是 HTTP 200（policy 里已固定 success_action_status）。
  Future<void> uploadFile({
    required OssSignResult sign,
    required String filePath,
  }) async {
    try {
      final form = FormData();
      for (final field in sign.fields.entries) {
        form.fields.add(MapEntry(field.key, field.value));
      }
      form.files.add(MapEntry('file', await MultipartFile.fromFile(filePath)));
      final response = await _dio.post<dynamic>(
        sign.uploadUrl,
        data: form,
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      if (response.statusCode != 200) {
        // OSS 的错误体是 XML，没有可展示的中文，给一句能定位问题的话就够了
        throw ServerException('文件上传失败（HTTP ${response.statusCode}）');
      }
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 头像直传的便捷入口：读文件长度 → 取签名 → 直传 → 返回服务端生成的**对象 key**。
  /// 这个 key 就是 `profiles.avatar_url` 要存的值（形如 `avatars/2026/09/xx.png`）。
  /// [filePath] 必须是仍存在的本地文件（image_picker 的临时文件在被系统回收前有效）。
  Future<String> uploadAvatar({
    required String filePath,
    required String contentType,
  }) async {
    try {
      final size = await File(filePath).length();
      final result = await sign(
        purpose: OssPurpose.avatar,
        contentType: contentType,
        size: size,
      );
      await uploadFile(sign: result, filePath: filePath);
      return result.objectKey;
    } catch (error) {
      throw mapError(error);
    }
  }
}

String? _errorOf(Map<String, dynamic>? body) {
  final error = body?['error'];
  return error is String && error.isNotEmpty ? error : null;
}
