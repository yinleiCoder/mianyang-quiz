// 知识点标签（tags 表）。
//
// name 在数据库里是 citext（忽略大小写唯一），所以「安全用电」与「安全用电」
// 的不同大小写写法是同一个标签。客户端比较时也应忽略大小写（用 name.toLowerCase()）。

import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_tag.freezed.dart';
part 'question_tag.g.dart';

@freezed
abstract class QuestionTag with _$QuestionTag {
  const factory QuestionTag({
    required String id,
    required String name,
  }) = _QuestionTag;

  factory QuestionTag.fromJson(Map<String, dynamic> json) =>
      _$QuestionTagFromJson(json);
}

extension QuestionTagX on QuestionTag {
  /// 客户端查重用的归一化键（与数据库 citext 的忽略大小写语义一致）。
  String get normalized => name.trim().toLowerCase();
}
