// 认证三页（登录 / 注册 / 邮箱验证）共用的外壳：品牌区 + 居中卡片 + 错误条。
//
// 职责：把「限宽 480、一屏装得下就垂直居中、装不下就能滚、失败原因摆在表单上方」
// 这几件三页都要做的事收在一处，页面只交出表单内容与底部链接。
// 不负责：任何业务字段——本组件不认识邮箱、密码、身份，它只是个盒子。
//
// 错误条放在这里而不是各页自绘：登录失败、注册失败、"重发验证码失败"长得一样，
// 而且都必须出现在**表单上方**。只弹 toast 的话，用户点完按钮视线还在输入框附近，
// 几秒后 toast 消失，看起来就是"点了没反应"。

import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/ui/core/design/brand_mark.dart';
import 'package:mianyang_quiz/ui/core/layout/max_width_box.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.error,
    this.footer,
  });

  /// 卡片主标题，如「登录」。
  final String title;

  /// 标题下的一句说明；可选。
  final String? subtitle;

  /// 失败文案（AppException.message，已经是可直接展示的中文）；null 时不占位。
  final String? error;

  /// 表单内容。
  final Widget child;

  /// 卡片下方的次要动作（「还没有账号？去注册」之类）。
  final Widget? footer;

  /// 认证卡片限宽。比 pageMaxWidth(640) 窄：单列表单太宽会显得空、眼睛要横着扫。
  static const double _maxWidth = 480;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            // 软键盘弹起时可用高度只剩一小半，内容必须能滚，否则「注册」按钮点不到。
            padding: EdgeInsets.symmetric(
              horizontal: AppMetrics.pagePadding.r,
              vertical: AppMetrics.gapXl.r,
            ),
            child: ConstrainedBox(
              // 内容比一屏矮就垂直居中（视觉上不吊在顶上），比一屏高就自然从顶部滚。
              constraints: BoxConstraints(
                minHeight: math.max(
                  0.0,
                  constraints.maxHeight - AppMetrics.gapXl * 2,
                ),
              ),
              child: Center(
                child: MaxWidthBox(
                  maxWidth: _maxWidth,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _Brand(),
                      SizedBox(height: AppMetrics.gapXl.r),
                      // **不套 DuoCard**：登录/注册页整屏就这一件事，再给它一圈圆角卡片
                      // 背景反而像"页面里嵌了一个组件"，而它本来就该是这一屏本身。
                      // 表单直接落在页面底色上，靠留白与字号分层，不靠容器。
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(title, style: AppTextStyles.pageTitle(context)),
                          if (subtitle != null) ...[
                            SizedBox(height: AppMetrics.gapXs.r),
                            Text(
                              subtitle!,
                              style: AppTextStyles.body(context).copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                          if (error != null) ...[
                            SizedBox(height: AppMetrics.gapLg.r),
                            _ErrorBanner(message: error!),
                          ],
                          SizedBox(height: AppMetrics.gapXl.r),
                          child,
                        ],
                      ),
                      if (footer != null) ...[
                        SizedBox(height: AppMetrics.gapLg.r),
                        footer!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 品牌区：图标 + 站名。与首页同一套图形，让"这是哪个 App"一眼可辨。
class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BrandMark(size: 56),
        SizedBox(height: AppMetrics.gapMd.r),
        Text(
          '绵阳市中职共建题库',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle(context),
        ),
      ],
    );
  }
}

/// 浅色底的错误条：底色取自 errorContainer，暗色模式下自动跟着变深。
/// 不用红色描边而用整块底色：一眼就能在表单里定位到它。
class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(AppMetrics.gapMd.r),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 20.r,
            color: scheme.onErrorContainer,
          ),
          SizedBox(width: AppMetrics.gapSm.r),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.body(context).copyWith(
                color: scheme.onErrorContainer,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
