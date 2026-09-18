// 题目反馈元数据。对应 public.question_reports 与 submit_question_report RPC（0066）。
//
// category 的取值必须与迁移里的 check 约束逐字一致（stem/answer/explanation/other），
// 也要与网页端 lib/question-reports.js 的 REPORT_CATEGORIES 一致 —— 改一处要改三处：
//   · supabase/migrations/0066_question_reports.sql 的 check 约束
//   · lib/question-reports.js（网页端文案）
//   · 本文件
//
// 注意这与 core/constants/feedback_meta.dart 是**两回事**：
// 那边是通用意见反馈（提交给系统管理员），这边是题目纠错（提交给本题作者）。
// 两者的收件人、可见性、有没有回复闭环都不一样，别合并。

/// 题目反馈类型。wire 进库，label 给用户看。
enum ReportCategory {
  stem('stem', '题干有误'),
  answer('answer', '答案有误'),
  explanation('explanation', '解析有误'),
  other('other', '其他问题');

  const ReportCategory(this.wire, this.label);

  final String wire;
  final String label;
}

/// 反馈处理状态。只有两态，与服务端 check 约束一致。
enum ReportStatus {
  open('open', '待处理'),
  resolved('resolved', '已处理');

  const ReportStatus(this.wire, this.label);

  final String wire;
  final String label;

  /// 未知取值（服务端将来加了状态）按"待处理"显示，不崩。
  static ReportStatus fromWire(String? wire) => ReportStatus.values.firstWhere(
    (s) => s.wire == wire,
    orElse: () => ReportStatus.open,
  );
}

/// wire → 中文标签。未知取值原样返回，便于排查。
String reportCategoryLabel(String? wire) => ReportCategory.values
    .firstWhere(
      (c) => c.wire == wire,
      orElse: () => ReportCategory.other,
    )
    .label;

/// 与服务端 0066 的 check 约束（btrim 后 2–500）对齐。
/// 下限 2 是拦"？""。"这种没有信息量的提交 —— 作者收到一个字也没法审。
const int reportMinLength = 2;
const int reportMaxLength = 500;
