// 「我的反馈」下的往来消息 + 撤回（迁移 0084 的申诉机制在客户端的落点）。
//
// 两件事在 App 里原本都缺：学生只能看到作者那一句处理说明（0066），
// 既不能追问、也没有撤回 —— 而网页端 0084 起已经能（提交人 / 作者 / 审题人三方对话）。
//
// 口径跟服务端走，这里不复制判据：
//   · 能发言 / 能撤回 = 反馈还没结案（status == open）；服务端 can_post_question_report_message
//     与 withdraw_question_report 各有一道，这里只是提前把输入框收掉。
//   · 撤回**不是删除**：那条反馈仍在（状态变 withdrawn），往来消息保留。
//
// 不显示发言人姓名：客户端没有 people 加载器（那是网页端的 lib/people.js），
// 而这一段里能出现的只有"我"和"对方"（作者/审题人）—— 按 uid 比一下就够了，
// 猜错名字比不显示更糟（见 AGENTS.md 里那类"别猜"的教训）。
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReportThread extends StatefulWidget {
  const ReportThread({
    super.key,
    required this.reportId,
    required this.isOpen,
    this.onChanged,
  });

  final String reportId;

  /// 反馈还没结案（status == open）才允许发言与撤回。
  final bool isOpen;

  /// 撤回成功 / 发言成功后回调（调用方据此重刷"我的反馈"那块）。
  final VoidCallback? onChanged;

  @override
  State<ReportThread> createState() => _ReportThreadState();
}

class _ReportThreadState extends State<ReportThread> {
  List<QuestionReportMessage>? _messages;
  final _controller = TextEditingController();
  bool _busy = false;

  String? get _uid => context.read<SupabaseClient>().auth.currentUser?.id;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final list =
          await context.read<QuestionReportRepository>().fetchMessages(widget.reportId);
      if (!mounted) return;
      setState(() => _messages = list);
    } catch (_) {
      // 读不到就当作空：往来是附加信息，不该把整张"我的反馈"卡打崩
      if (!mounted) return;
      setState(() => _messages = const []);
    }
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _busy) return;
    setState(() => _busy = true);
    try {
      await context
          .read<QuestionReportRepository>()
          .postMessage(widget.reportId, text);
      if (!mounted) return;
      _controller.clear();
      await _load();
      widget.onChanged?.call();
    } on AppException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _withdraw() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('撤回这条反馈？'),
        content: const Text('撤回后这条反馈关闭、不会再有人处理它（想反悔可以重新提一条）。已经说过的往来消息会保留。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('撤回'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await context.read<QuestionReportRepository>().withdraw(widget.reportId);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('已撤回这条反馈')));
      widget.onChanged?.call();
    } on AppException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = AppTextStyles.caption(context)
        .copyWith(color: theme.colorScheme.onSurfaceVariant);
    final messages = _messages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: AppMetrics.gapSm.r),
        Row(
          children: [
            Text(
              '往来${messages == null ? '' : '（${messages.length}）'}',
              style: AppTextStyles.caption(context).copyWith(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            if (widget.isOpen)
              TextButton(
                onPressed: _busy ? null : _withdraw,
                child: Text('撤回', style: AppTextStyles.caption(context)),
              ),
          ],
        ),
        if (messages == null)
          Text('加载中…', style: muted)
        else if (messages.isEmpty)
          Text('还没有往来消息。', style: muted)
        else
          for (final m in messages)
            Padding(
              padding: EdgeInsets.only(top: AppMetrics.gapXs.r),
              child: Container(
                padding: EdgeInsets.all(AppMetrics.gapSm.r),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppMetrics.radiusCard.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          m.authorId != null && m.authorId == _uid ? '我' : '对方',
                          style: AppTextStyles.caption(context)
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        const Spacer(),
                        Text(Formatters.dateTime(m.createdAt), style: muted),
                      ],
                    ),
                    SizedBox(height: AppMetrics.gapXs.r),
                    Text(m.body, style: AppTextStyles.body(context)),
                  ],
                ),
              ),
            ),
        if (widget.isOpen) ...[
          SizedBox(height: AppMetrics.gapSm.r),
          TextField(
            controller: _controller,
            maxLines: 3,
            minLines: 2,
            maxLength: 1000,
            decoration: const InputDecoration(
              hintText: '补充说明、回应对方的疑问…',
              border: OutlineInputBorder(),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: DuoButton(
              label: '发送',
              onPressed: _busy ? null : _send,
            ),
          ),
        ] else
          Text('这条反馈已结案，不能再回复。', style: muted),
      ],
    );
  }
}
