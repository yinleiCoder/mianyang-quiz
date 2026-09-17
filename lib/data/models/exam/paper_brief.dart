// 组卷库里的一份试卷（list_papers 的一行）。
//
// 刻意只有"挑卷子"需要的字段：卷面（题目内容）不在这里，它要等 start_exam_attempt
// 才下发——那是唯一带作答状态的入口，也是服务端剥答案的关口。

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';

part 'paper_brief.freezed.dart';
part 'paper_brief.g.dart';

@freezed
abstract class PaperBrief with _$PaperBrief {
  const factory PaperBrief({
    /// 开考要传的就是它（start_exam_attempt 的 p_paper_version_id）。
    @JsonKey(name: 'version_id') required String versionId,
    @JsonKey(name: 'paper_id') required String paperId,
    @Default('') String title,
    @JsonKey(name: 'exam_name') String? examName,
    @JsonKey(name: 'subject_label') String? subjectLabel,

    /// 满分与时长都是**发布时定版**的值，不是实时算的。
    @JsonKey(name: 'total_score') double? totalScore,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,

    @JsonKey(name: 'item_count') @Default(0) int itemCount,
    @JsonKey(name: 'published_at') DateTime? publishedAt,
  }) = _PaperBrief;

  factory PaperBrief.fromJson(Map<String, dynamic> json) =>
      _$PaperBriefFromJson(json);
}

extension PaperBriefX on PaperBrief {
  /// 副标题：考试名 · 科目。两者都空时返回空串（调用方决定要不要占位）。
  String get subtitle => [examName, subjectLabel]
      .where((s) => s != null && s.trim().isNotEmpty)
      .map((s) => s!.trim())
      .join(' · ');

  /// 「20 题 · 90 分钟 · 满分 100」里除题数外的部分，题数由列表另画。
  String get paperMeta {
    final parts = <String>[
      if (durationMinutes != null && durationMinutes! > 0) '$durationMinutes 分钟',
      if (totalScore != null && totalScore! > 0)
        '满分 ${Formatters.score(totalScore)}',
    ];
    return parts.join(' · ');
  }
}
