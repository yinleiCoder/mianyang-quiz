// 题目反馈（public.question_reports，迁移 0066）。
//
// 这里只建模**学生自己提的那一条**（题目页上"我的反馈"那块）。
// 作者视角的收件箱字段更多（题目、版本、提交人……），那是网页端的活 ——
// 本客户端是纯学生端，没有教师功能（见 lib/ui/features/ 下没有 review/approval）。
//
// 与 feedback（通用意见反馈）最大的区别：**有回复闭环**。作者处理时写的
// resolveNote 会显示给提交人，所以这个模型必须带上它。
//
// 字段来自 RLS 放行的直接 select（策略 qr_select 只放行"自己的行"），
// 不是 RPC —— list_question_reports 只给处理人，学生调会抛错。

import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_report.freezed.dart';
part 'question_report.g.dart';

@freezed
abstract class QuestionReport with _$QuestionReport {
  const factory QuestionReport({
    required String id,
    @Default('open') String status,
    @Default('other') String category,
    @Default('') String content,
    /// 作者处理时写的说明。**学生会看到这句话** —— 这是本功能的全部意义所在。
    /// 未处理时为 null。
    @JsonKey(name: 'resolve_note') String? resolveNote,
    @JsonKey(name: 'resolved_at') DateTime? resolvedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _QuestionReport;

  factory QuestionReport.fromJson(Map<String, dynamic> json) =>
      _$QuestionReportFromJson(json);
}

extension QuestionReportX on QuestionReport {
  bool get isResolved => status == 'resolved';
}
