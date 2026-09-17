// 考试卷面（start_exam_attempt / get_my_exam_attempt 返回的 paper）。
//
// 与练习的 PracticeSessionSnapshot 分开：考试的卷面**按大题组织**，大题有标题、
// 有整段说明、有分值口径，这些是卷面的一部分（打印出来就是这个样子），
// 而练习只是一串题。硬套一个模型会让练习多出一堆永远为空的字段。
//
// **答案在不在，由服务端决定**：考试中下发的是 exam_paper_json（已剥答案，
// content.answer 为 null），出分后换成带答案的完整快照。客户端不做判断，
// 只按 content.answer 有没有来渲染——见 supabase/migrations/0056。
//
// 题目内容按大题挂在 sections[].items 上（服务端另有一份按 seq 拍平的 items，
// 这里不用：纸面顺序就是大题顺序，拍平会丢掉"这题属于哪一大题"）。

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mianyang_quiz/core/constants/qtype_meta.dart';
import 'package:mianyang_quiz/data/models/content/block.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';

part 'exam_paper.freezed.dart';
part 'exam_paper.g.dart';

@freezed
abstract class ExamItem with _$ExamItem {
  const factory ExamItem({
    /// paper_items.id。**作答按它索引**（不是 question_id——同一份卷里题目不重复，
    /// 但跨版本复用时 question_id 可能相同而题项不同）。
    required String id,
    required int seq,
    required String qtype,
    int? difficulty,
    @Default(0) double score,

    /// 计分点明细：[3] / [2,2,2,2] / [3,3,4]。长度就是"这题有几个给分点"，
    /// 阅卷按它逐点给分，填空题答对几空就得几个点的分。
    @JsonKey(name: 'score_units') @Default(<double>[0]) List<double> scoreUnits,

    required QuestionContent content,
  }) = _ExamItem;

  factory ExamItem.fromJson(Map<String, dynamic> json) =>
      _$ExamItemFromJson(json);
}

extension ExamItemX on ExamItem {
  QuestionType get type => questionTypeFrom(qtype);

  /// 这题要不要教师判：主观题，以及**含主观子题**的复合题。
  /// 口径与 0051 的 grade_exam_units 一致（复合题遇到一个简答子题就整题转人工）。
  bool get needsManualGrading =>
      type.isSelfAssessed ||
      (type.isComposite &&
          content.sub.any((sub) => questionTypeFrom(sub.type).isSelfAssessed));
}

@freezed
abstract class ExamSection with _$ExamSection {
  const factory ExamSection({
    required String id,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,

    /// 中文序号（一、二、…），服务端算好的，别在客户端再写一套。
    @JsonKey(name: 'seq_label') @Default('') String seqLabel,
    String? title,

    /// 大题作答说明（「本大题共 10 小题，每题 2 分」）。
    String? instruction,

    @JsonKey(name: 'section_score') @Default(0) double sectionScore,
    @Default(<ExamItem>[]) List<ExamItem> items,
  }) = _ExamSection;

  factory ExamSection.fromJson(Map<String, dynamic> json) =>
      _$ExamSectionFromJson(json);
}

extension ExamSectionX on ExamSection {
  /// 「一、单项选择题」——标题缺失时只留序号，不要拼出一个空括号。
  String get heading {
    final name = title?.trim() ?? '';
    final label = seqLabel.trim();
    if (label.isEmpty) return name;
    if (name.isEmpty) return '$label、';
    return '$label、$name';
  }
}

@freezed
abstract class ExamPaper with _$ExamPaper {
  const factory ExamPaper({
    @JsonKey(name: 'version_id') required String versionId,
    @JsonKey(name: 'paper_id') required String paperId,
    @Default('') String title,
    @JsonKey(name: 'exam_name') String? examName,
    @JsonKey(name: 'subject_label') String? subjectLabel,
    @JsonKey(name: 'duration_minutes') @Default(90) int durationMinutes,
    @JsonKey(name: 'total_score') @Default(0) double totalScore,

    /// 卷首说明（Block 数组，与题干同一套块模型）。
    @Default(<Block>[]) List<Block> instructions,

    @Default(<ExamSection>[]) List<ExamSection> sections,
  }) = _ExamPaper;

  factory ExamPaper.fromJson(Map<String, dynamic> json) =>
      _$ExamPaperFromJson(json);
}

extension ExamPaperX on ExamPaper {
  /// 按卷面顺序拍平的题目（大题顺序 × 大题内 seq）。
  /// 答题卡、上下题、交卷都按这个顺序走——它就是学生眼里的"第 N 题"。
  List<ExamItem> get items => [
    for (final section in sections) ...section.items,
  ];

  /// 题目总数。sections 为空时是 0（服务端不允许空卷开考，这里只做兜底）。
  int get itemCount => items.length;
}
