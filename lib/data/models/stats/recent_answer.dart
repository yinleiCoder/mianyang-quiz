// 看板里的两个小块：最近作答流水、进行中的会话摘要。
//
// 单独成文件是因为它们被 practice_dashboard 与 practice_overview 共用，
// 而且进行中会话的摘要在「继续练习」入口处也要用。

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';

part 'recent_answer.freezed.dart';
part 'recent_answer.g.dart';

@freezed
abstract class RecentAnswer with _$RecentAnswer {
  const factory RecentAnswer({
    @JsonKey(name: 'question_id') required String questionId,
    @JsonKey(name: 'version_id') String? versionId,
    String? qtype,
    int? difficulty,
    @JsonKey(name: 'is_correct') bool? isCorrect,
    @Default('auto') String grading,
    @JsonKey(name: 'answered_at') DateTime? answeredAt,

    /// 题干摘要（数据库取当前发布版 search_text 左 120 字）。
    /// 题目已下线或已删除时为 null——界面要显示占位而不是空白。
    @JsonKey(name: 'stem_text') String? stemText,
  }) = _RecentAnswer;

  factory RecentAnswer.fromJson(Map<String, dynamic> json) =>
      _$RecentAnswerFromJson(json);
}

extension RecentAnswerX on RecentAnswer {
  /// 题目已不可用（下线/删除）——此时点击不应跳详情页。
  bool get isAvailable => stemText != null && stemText!.isNotEmpty;
}

@freezed
abstract class ActiveSessionBrief with _$ActiveSessionBrief {
  const factory ActiveSessionBrief({
    @JsonKey(name: 'session_id') required String sessionId,
    @Default('all') String source,
    @JsonKey(name: 'total_count') @Default(0) int totalCount,
    @JsonKey(name: 'answered_count') @Default(0) int answeredCount,
    @JsonKey(name: 'started_at') DateTime? startedAt,
  }) = _ActiveSessionBrief;

  factory ActiveSessionBrief.fromJson(Map<String, dynamic> json) =>
      _$ActiveSessionBriefFromJson(json);
}

extension ActiveSessionBriefX on ActiveSessionBrief {
  int get remaining => (totalCount - answeredCount).clamp(0, totalCount);

  double get progress =>
      totalCount == 0 ? 0 : (answeredCount / totalCount).clamp(0, 1);

  /// 来源的展示名（题库/错题本/收藏）。取不到时原样返回线格式字符串。
  PracticeSource get sourceValue {
    for (final value in PracticeSource.values) {
      if (value.wire == source) return value;
    }
    return PracticeSource.all;
  }
}
