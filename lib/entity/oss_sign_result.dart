// OSS 直传签名（网页端 POST /api/oss/sign 的返回）。
//
// 安全边界：密钥永不下发。客户端只拿到一个覆盖单次上传的 policy 与签名，
// 且对象 key 由服务端生成（`{prefix}YYYY/MM/<uuid>.<ext>`，不信任客户端路径）。
//
// 用法：把 fields 全部作为 multipart 字段、**file 放在最后**，
// POST 到 uploadUrl，成功返回 200。

import 'package:freezed_annotation/freezed_annotation.dart';

part 'oss_sign_result.freezed.dart';
part 'oss_sign_result.g.dart';

@freezed
abstract class OssSignResult with _$OssSignResult {
  const factory OssSignResult({
    @JsonKey(name: 'uploadUrl') required String uploadUrl,
    @Default('') String bucket,

    /// 必须原样、按序放进 multipart 的字段（含 key/policy/signature/Content-Type 等）。
    /// 服务端生成的 key 就在这里——上传后要用它拼展示 URL 或登记媒体。
    @Default(<String, String>{}) Map<String, String> fields,
  }) = _OssSignResult;

  factory OssSignResult.fromJson(Map<String, dynamic> json) =>
      _$OssSignResultFromJson(json);
}

extension OssSignResultX on OssSignResult {
  /// 服务端生成的对象 key（`qbank/2026/09/xxx.png`）。
  String get objectKey => fields['key'] ?? '';

  /// 上传时声明的 Content-Type——登记媒体时要一并回传。
  String get contentType => fields['Content-Type'] ?? '';
}
