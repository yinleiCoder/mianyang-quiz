// 意见反馈页：把使用中遇到的问题/建议发给系统管理员（网页端收件箱处理）。
//
// 职责：收集类型 + 正文 +（选填）联系方式 → 提交 submit_feedback → 返回。
// 不负责：服务端校验（类型/长度/限流都由 0033 的 RPC 判，拒绝文案原样透出）。
//
// 页面级状态就够（不进 state/）：只有这一页用，进去一次提一条。
// 提交成功后只给一个短编号——本功能没有回复流，「已处理」用户看不到，
// 所以文案必须把预期讲清楚，别让人以为会有回信。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/config/env.dart';
import 'package:mianyang_quiz/core/constants/feedback_meta.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/repositories/feedback_repository.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/layout/max_width_box.dart';
import 'package:mianyang_quiz/ui/core/layout/section_header.dart';
import 'package:mianyang_quiz/ui/features/profile/widgets/profile_form_field.dart';
import 'package:provider/provider.dart';

/// 正文最少字数，与 0033 的 submit_feedback 保持一致（这里先拦一道，省一趟网络）。
const int _minContentLength = 5;

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _content = TextEditingController();
  final _contact = TextEditingController();

  FeedbackCategory _category = FeedbackCategory.bug;
  bool _saving = false;

  @override
  void dispose() {
    _content.dispose();
    _contact.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_saving) return;
    final content = _content.text.trim();
    if (content.length < _minContentLength) {
      _toast('请把问题描述得再具体一些（至少 $_minContentLength 个字）');
      return;
    }

    setState(() => _saving = true);
    // 依赖先取好：await 之后除了已判过 mounted 的提示，不再碰 context。
    final feedback = context.read<FeedbackRepository>();
    try {
      final id = await feedback.submit(
        category: _category.wire,
        content: content,
        platform: feedbackPlatform(),
        contact: _contact.text.trim().isEmpty ? null : _contact.text.trim(),
        clientVersion: Env.appVersion.isEmpty ? null : Env.appVersion,
      );
      if (!mounted) return;
      _toast('已提交，编号 ${_shortId(id)}');
      context.pop();
    } on AppException catch (error) {
      if (!mounted) return;
      _toast(error.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// 短编号：只取前 8 位，方便用户在聊天里报给管理员。
  String _shortId(String id) => id.length > 8 ? id.substring(0, 8) : id;

  void _toast(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final muted = AppTextStyles.caption(context)
        .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);

    return Scaffold(
      appBar: AppBar(title: const Text('意见反馈')),
      body: SafeArea(
        child: MaxWidthBox(
          child: ListView(
            padding: EdgeInsets.all(AppMetrics.pagePadding.r),
            children: [
              Text('使用网页端或刷题 App 时遇到的功能问题、改进建议，都可以在这里告诉系统管理员。', style: muted),
              SizedBox(height: AppMetrics.gapXl.r),
              const SectionHeader(title: '反馈类型'),
              Wrap(
                spacing: AppMetrics.gapSm.r,
                runSpacing: AppMetrics.gapSm.r,
                children: [
                  for (final category in FeedbackCategory.values)
                    ChoiceChip(
                      label: Text(category.label),
                      selected: category == _category,
                      onSelected: (_) => setState(() => _category = category),
                    ),
                ],
              ),
              SizedBox(height: AppMetrics.gapXl.r),
              const SectionHeader(title: '问题描述'),
              ProfileFormField(
                controller: _content,
                label: '描述',
                hint: '例如：题库按「计算机类」筛选后翻到第二页，会跳回第一页。',
                help: '至少 $_minContentLength 个字，尽量写清在哪一步、期望是什么。',
                maxLines: 6,
                maxLength: 2000,
              ),
              SizedBox(height: AppMetrics.gapMd.r),
              ProfileFormField(
                controller: _contact,
                label: '联系方式（选填）',
                hint: '手机号 / 微信 / QQ',
                maxLength: 60,
              ),
              SizedBox(height: AppMetrics.gapXl.r),
              DuoButton(
                label: '提交反馈',
                icon: Icons.send_rounded,
                loading: _saving,
                onPressed: _submit,
              ),
              SizedBox(height: AppMetrics.gapSm.r),
              Text('提交后由系统管理员查看，不在这里回复；需要跟进的会通过你留的联系方式联系你。', style: muted),
            ],
          ),
        ),
      ),
    );
  }
}
