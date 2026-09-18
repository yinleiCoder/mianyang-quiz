// 邮箱验证页（兜底页，**刻意没有验证码输入框**）。
//
// 为什么没有 6 位验证码框与 60 秒重发倒计时：
// AuthService 只提供 signIn / signUp / signOut 三个方法，没有任何验证码能力
// （verifyOtp / resend 之类），本页写代码时已确认，见 lib/data/services/auth_service.dart；
// 而本项目服务端也已关闭注册邮箱验证——signUp 直接返回会话（AuthService.signUp 返回 false），
// 注册流程正常走不到这里。摆一个点了没反应的「验证」按钮，比少一个表单更糟。
//
// 将来服务端重新开启邮箱验证时，本页再补三件事：
//   1. AuthService 加 verifyOtp(email, code) 与 resend(email)（那是数据层的活）
//   2. 6 位验证码输入 + 一位一个方格的分段输入
//   3. 「重新发送」按钮的 60 秒倒计时
// 在那之前，本页负责把「你已经注册好了，直接登录」说清楚——它仍然是一个深链可达的
// 页面（注册接口返回"需要验证"时也会跳过来），不能是白屏。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/core/utils/phone.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/features/auth/widgets/auth_scaffold.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';

class EmailVerifyPage extends StatelessWidget {
  const EmailVerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // 邮箱从 query 读：本页是深链可达的，参数只有 URI 里那一份是权威的。
    final email = GoRouterState.of(context).uri.queryParameters['email'];

    return AuthScaffold(
      title: '邮箱验证',
      subtitle: '注册的最后一步',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(AppMetrics.gapLg.r),
            decoration: BoxDecoration(
              color: context.semantic.successContainer,
              borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.mark_email_read_outlined,
                  size: 20.r,
                  color: context.semantic.onSuccessContainer,
                ),
                SizedBox(width: AppMetrics.gapSm.r),
                Expanded(
                  child: Text(
                    '本项目已关闭邮箱验证，请直接登录。',
                    style: AppTextStyles.body(context).copyWith(
                      // 底色是 successContainer，前景就必须是同族的 onSuccessContainer：
                      // 拿 onTertiaryContainer 顶替是 AGENTS.md 二·五警告的那个坑 ——
                      // tertiary 由种子色相旋转派生，深色模式下与这块绿底毫无关系。
                      color: context.semantic.onSuccessContainer,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (email != null && email.isNotEmpty) ...[
            SizedBox(height: AppMetrics.gapLg.r),
            Text(
              // 注册页传过来的可能是手机号账号的**合成邮箱**（138…@phone.myquiz.cn）。
              // 学生看到那串东西只会困惑，所以走 displayIdentifier：合成邮箱会被还原成
              // 手机号，真实邮箱原样显示，本来就是纯手机号的输入也原样显示。
              //
              // 注意别写成 `displayEmail(email).isEmpty ? email : ...` —— 那样合成邮箱
              // 恰好落进"空"分支，等于原样把假地址印出来，白折叠一场。
              '注册账号：${displayIdentifier(email: email)}',
              style: AppTextStyles.body(
                context,
              ).copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
          SizedBox(height: AppMetrics.gapLg.r),
          Text(
            '如果你收到了验证邮件，说明服务端开着邮箱验证：请点邮件里的确认链接，'
            '在链接过期前完成验证，再回登录页登录。本客户端不提供验证码输入，'
            '所以邮件里的链接是唯一的验证入口。',
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: scheme.onSurfaceVariant),
          ),
          SizedBox(height: AppMetrics.gapXl.r),
          DuoButton(
            label: '去登录',
            icon: Icons.login_rounded,
            onPressed: () => context.go(AppRoutes.loginPath),
          ),
        ],
      ),
    );
  }
}
