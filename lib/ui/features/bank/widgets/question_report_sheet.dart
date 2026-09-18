// 题目纠错弹层：学生把"这题有问题"提交给**本题作者**。
//
// 与通用意见反馈（lib/ui/features/shell/ 的反馈入口）的区别，文案上必须说清：
//   · 收件人是本题作者，不是系统管理员；
//   · **有回复闭环** —— 作者处理时会写一句说明，学生在这道题下面看得到。
// 不写清楚的话，学生会以为又是石沉大海，这个功能就白做了。
//
// 版本号要摆在明面上：作者改版之后，这条反馈在作者那边会标成"针对 vN 的"。
// 不告诉学生，他改天发现题已经变了会以为反馈没被采纳。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/report_meta.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/repositories/question_report_repository.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:provider/provider.dart';

/// 打开纠错弹层。返回 true 表示已提交成功（调用方据此刷新"我的反馈"那块）。
Future<bool?> showQuestionReportSheet(
  BuildContext context, {
  required String questionId,
  required String versionId,
  required int? versionNo,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    showDragHandle: true,
    // 弹层里有输入框，键盘弹起时要能滚 —— 不设这个在窄屏上按钮会被顶出可视区
    isScrollControlled: true,
    builder: (_) => QuestionReportSheet(
      questionId: questionId,
      versionId: versionId,
      versionNo: versionNo,
    ),
  );
}

class QuestionReportSheet extends StatefulWidget {
  const QuestionReportSheet({
    super.key,
    required this.questionId,
    required this.versionId,
    required this.versionNo,
  });

  final String questionId;
  final String versionId;
  final int? versionNo;

  @override
  State<QuestionReportSheet> createState() => _QuestionReportSheetState();
}

class _QuestionReportSheetState extends State<QuestionReportSheet> {
  // 默认选「答案有误」：实际收到的问题里这一类最多，少一次点击。
  ReportCategory _category = ReportCategory.answer;
  final _content = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _content.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _content.text.trim();
    if (_busy || text.length < reportMinLength) return;
    setState(() => _busy = true);
    try {
      await context.read<QuestionReportRepository>().submit(
        questionId: widget.questionId,
        versionId: widget.versionId,
        category: _category.wire,
        content: text,
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已发给本题作者，处理结果会显示在这道题下面')),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _busy = false);
      // RPC 的中文报错原样透出（「你已经反馈过这道题了，作者还在处理中」等）
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mapError(error).message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final length = _content.text.trim().length;
    final tooShort = length < reportMinLength;

    return SafeArea(
      child: Padding(
        // 键盘弹起时把内容顶上去，否则输入框会被挡住
        padding: EdgeInsets.only(
          left: AppMetrics.pagePadding.r,
          right: AppMetrics.pagePadding.r,
          top: AppMetrics.pagePadding.r,
          bottom: MediaQuery.viewInsetsOf(context).bottom + AppMetrics.pagePadding.r,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '反馈这道题的问题',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: AppMetrics.gapXs.r),
            Text(
              '反馈会直接发给本题作者。作者核对后会写一句处理说明，届时你可以在这道题下方看到。',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: AppMetrics.gapLg.r),

            Text('问题类型', style: theme.textTheme.labelMedium),
            SizedBox(height: AppMetrics.gapSm.r),
            Wrap(
              spacing: AppMetrics.gapSm.r,
              runSpacing: AppMetrics.gapSm.r,
              children: ReportCategory.values
                  .map(
                    (c) => ChoiceChip(
                      label: Text(c.label),
                      selected: _category == c,
                      onSelected: _busy
                          ? null
                          : (v) => setState(() => _category = c),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: AppMetrics.gapLg.r),

            TextField(
              controller: _content,
              enabled: !_busy,
              maxLines: 4,
              maxLength: reportMaxLength,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: '具体问题',
                hintText: '例如：第二问的答案给的是 B，但按题干条件算出来应该是 C。',
                alignLabelWithHint: true,
              ),
            ),
            Text(
              '说清楚哪里不对，作者才好核对 · 已写 $length/$reportMaxLength',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: AppMetrics.gapMd.r),

            // 版本号摆出来：作者改版后这条反馈会被标成"针对 vN 的"，学生得知道这件事。
            Text(
              widget.versionNo == null
                  ? '本次反馈针对当前在线版本。题目若之后被改版，这条反馈仍会保留在作者的处理列表里。'
                  : '本次反馈针对当前在线版本 v${widget.versionNo}。题目若之后被改版，这条反馈仍会保留在作者的处理列表里。',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: AppMetrics.gapLg.r),

            DuoButton(
              label: '提交反馈',
              icon: Icons.flag_outlined,
              loading: _busy,
              onPressed: tooShort ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
