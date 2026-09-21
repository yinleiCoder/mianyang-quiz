// 一份复习资料（列表项与详情共用）。
//
// 字段与 0070 的 review_materials 一一对应；creator_name / school_name 不是表上的列，
// 是服务端装载时补上的（creator_id 指向 auth.users，与 profiles 之间没有外键，
// PostgREST 嵌入不了，所以由 lib/materials.js 单独查一次名字再拼进来）。

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mianyang_quiz/core/constants/material_meta.dart';
import 'package:mianyang_quiz/core/network/oss_url.dart';

part 'material_brief.freezed.dart';
part 'material_brief.g.dart';

@freezed
abstract class MaterialBrief with _$MaterialBrief {
  const factory MaterialBrief({
    required String id,
    @JsonKey(name: 'object_key') required String objectKey,
    required String title,
    String? description,
    @Default('other') String kind,
    @JsonKey(name: 'course_node_id') String? courseNodeId,
    @JsonKey(name: 'creator_id') String? creatorId,
    @JsonKey(name: 'creator_name') String? creatorName,
    @JsonKey(name: 'school_name') String? schoolName,
    @JsonKey(name: 'download_count') @Default(0) int downloadCount,
    @Default(0) int size,
    String? mime,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _MaterialBrief;

  factory MaterialBrief.fromJson(Map<String, dynamic> json) =>
      _$MaterialBriefFromJson(json);
}

extension MaterialBriefX on MaterialBrief {
  MaterialKind get type => materialKindFrom(kind);

  /// 可直接访问的 OSS 地址（公网只读，不需要鉴权）。
  ///
  /// **原件地址**：保存到本地、分享、交给系统程序打开都用它。
  String get fileUrl => OssUrl.of(objectKey);

  /// 应用内预览用的地址。
  ///
  /// **只有图片**才叠加 OSS 图片处理（缩放 + 转 webp）：非图片带上 `x-oss-process`
  /// 会得到 HTTP 400「This image format is not supported.」，整条打不开
  ///（实测 .xlsx 如此，见 core/network/oss_url.dart 的规则）。
  /// 一张讲义截图原图可能十几 MB，走归档比原图省得多，而全屏放着看也够清楚。
  String get previewUrl =>
      type == MaterialKind.image ? OssUrl.media(objectKey, width: OssUrl.fullWidth) : fileUrl;

  /// 扩展名（小写、不含点）。取自 objectKey —— 那是服务端生成的权威来源，
  /// 不拿标题去猜（标题里可能压根没有扩展名）。
  String get ext {
    final dot = objectKey.lastIndexOf('.');
    if (dot < 0 || dot == objectKey.length - 1) return '';
    return objectKey.substring(dot + 1).toLowerCase();
  }

  /// 保存到本地时的建议文件名。
  ///
  /// 标题是用户输入的，可能带 `/ \ : * ? " < > |` 这些在 Windows 上非法、
  /// 在 Android 上也会出问题的字符 —— 一律换成下划线，别让"保存"在系统层面失败。
  String get suggestedFileName {
    final safe = title.replaceAll(RegExp(r'[\\/:*?"<>|\x00-\x1f]'), '_').trim();
    final base = safe.isEmpty ? '资料' : safe;
    return ext.isEmpty ? base : '$base.$ext';
  }

  /// 卡片上那行「1.2 MB」。
  String get sizeLabel {
    if (size >= 1024 * 1024) return '${(size / 1024 / 1024).toStringAsFixed(1)} MB';
    if (size >= 1024) return '${(size / 1024).round()} KB';
    return '$size B';
  }
}
