// 题库列表的一行（PostgREST 查询 question_versions 内嵌 questions 的结果）。
//
// 查询口径必须与网页端 app/(app)/bank/page.jsx 一致：
//   status = published 且 question.state = live
// 外键 hint 必须带 `!question_versions_question_id_fkey`——
// questions ↔ question_versions 是双外键，不带会让 PostgREST 返回 300。

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mianyang_quiz/core/constants/qtype_meta.dart';

part 'question_brief.freezed.dart';
part 'question_brief.g.dart';

@freezed
abstract class QuestionBrief with _$QuestionBrief {
  const factory QuestionBrief({
    /// 内嵌的 questions 行——PostgREST 把它嵌在 question 键下，由仓储层摊平后传入。
    @JsonKey(name: 'question_id') required String questionId,
    @JsonKey(name: 'version_id') required String versionId,
    required String qtype,
    int? difficulty,
    @JsonKey(name: 'course_node_id') String? courseNodeId,
    @JsonKey(name: 'school_id') String? schoolId,
    @Default('') String stemText,
    @JsonKey(name: 'version_no') int? versionNo,
    @JsonKey(name: 'published_at') DateTime? publishedAt,
    @Default(<String>[]) List<String> tags,
    @JsonKey(name: 'node_path') @Default('') String nodePath,
    @JsonKey(name: 'school_name') @Default('') String schoolName,

    /// 题目当前是否可用（已下线/已删除的题在错题本与收藏里是占位行）。
    @Default(true) bool available,
  }) = _QuestionBrief;

  factory QuestionBrief.fromJson(Map<String, dynamic> json) =>
      _$QuestionBriefFromJson(json);
}

extension QuestionBriefX on QuestionBrief {
  QuestionType get type => questionTypeFrom(qtype);
}
