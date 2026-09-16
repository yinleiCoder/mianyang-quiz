// 内容块：题干、选项文字、解析都由块数组构成。
//
// 线格式（与网页端 lib/question-model.js 及数据库 validate_question_content 逐条对齐）：
//   {"t":"text","text":"段落文字"}
//   {"t":"media","kind":"image|audio|video|file","key":"qbank/2026/09/<uuid>.png","alt":"原始文件名"}
//
// 判别键是 `t`（不是 freezed 默认的 runtimeType），所以必须写 unionKey。
// 这已经是实测验证过的写法（见 tool 里的一次性探针记录）。
//
// 不负责：把 key 拼成可访问 URL（见 core/network/oss_url.dart）。

import 'package:freezed_annotation/freezed_annotation.dart';

part 'block.freezed.dart';
part 'block.g.dart';

// sealed 而不是 abstract：freezed 的 union 在 Dart 3 里用 sealed 声明后，
// 对它的 switch 会获得**编译期穷举检查**——将来内容契约新增块类型时，
// 所有分发点会直接编译失败，而不是悄悄走到 default 分支漏渲染。
@Freezed(unionKey: 't')
sealed class Block with _$Block {
  @FreezedUnionValue('text')
  const factory Block.text({required String text}) = TextBlock;

  @FreezedUnionValue('media')
  const factory Block.media({
    required String kind,
    required String key,
    String? url,
    String? alt,
  }) = MediaBlock;

  factory Block.fromJson(Map<String, dynamic> json) => _$BlockFromJson(json);
}

extension BlockListX on List<Block> {
  /// 纯文本（媒体块不计入）——与网页端 blocksToText 同口径。
  /// 媒体块的内容不计入，是为了让"题干为空"的判断与数据库 v_blocks_text 一致。
  String get plainText => whereType<TextBlock>().map((b) => b.text).join();

  bool get isBlank => plainText.trim().isEmpty;
}

/// 空位判定。**提为文件级常量**：RegExp 的构造要编译模式，而 countBlanks 会被
/// FillBlankInputView 在每次按键（didUpdateWidget）里调到 —— 写成字面量等于
/// 每敲一个字符就重新编译一次正则。
final _blankPattern = RegExp(r'_{3,}');

/// 填空题空位数量：与数据库一致，只认**连续 3 个以上**下划线。
/// 少于此数的下划线是普通文本，不是空位。
int countBlanks(String text) => _blankPattern.allMatches(text).length;
