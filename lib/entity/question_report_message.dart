// 反馈 / 申诉的往来消息（public.question_report_messages，迁移 0084）。
//
// **故意不用 freezed**：四个字段、只读、没有 copyWith / 值相等的需求，
// 而 freezed 要为每个实体跑一轮 build_runner（那套 codegen 在本仓库有两个已知坑）。
// 客户端只读它、发出去的是纯文本，手写 fromJson 就够。
//
// 可见性完全在服务端（提交人 / 本题作者 / 本题审题人；结案后不能再发）——
// 这里不做任何二次过滤。
class QuestionReportMessage {
  const QuestionReportMessage({
    required this.id,
    required this.authorId,
    required this.body,
    this.createdAt,
  });

  final String id;

  /// 发言人的 uid。可能为 null —— 账号注销后外键置空（0084 的口径：话还在）。
  final String? authorId;

  final String body;
  final DateTime? createdAt;

  factory QuestionReportMessage.fromJson(Map<String, dynamic> json) =>
      QuestionReportMessage(
        id: json['id'] as String,
        authorId: json['author_id'] as String?,
        body: (json['body'] as String?) ?? '',
        createdAt: DateTime.tryParse((json['created_at'] as String?) ?? ''),
      );
}
