// 个人资料页「其他」区：意见反馈 / 修改密码 / 退出登录。
//
// 为什么单独成文件：ProfilePage 已顶到 200 行上限（tool/check_architecture.dart 卡死），
// 再加一个入口就必须拆。这三件事同属"与档案无关的账号动作"，是天然的一刀。
//
// 退出登录需要父页面的状态（二次确认 + 清会话 + 跳转），所以由外面传回调进来；
// 另外两个只是跳路由，本组件自己 go 掉即可。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/router/router.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mianyang_quiz/pages/profile/widgets/appearance_sheet.dart';
import 'package:mianyang_quiz/pages/profile/widgets/profile_entry_tile.dart';

/// 作者主页。只有这一处用，就先放这里（将来有第二处再上提到 values/）。
const _authorHomeUrl = 'https://yinleilei.cn';

class ProfileActionsSection extends StatelessWidget {
  const ProfileActionsSection({super.key, required this.onSignOut});

  /// 退出登录（由 ProfilePage 实现：二次确认 → 清会话 → 回登录页）。
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SectionHeader(title: '其他'),
      ProfileEntryTile(
        icon: Icons.palette_outlined,
        label: '外观',
        subtitle: '深色模式、主题色',
        onTap: () => showAppearanceSheet(context),
      ),
      SizedBox(height: AppMetrics.gapMd.r),
      // 联系作者：交给系统浏览器打开（站外链接一律外部应用，理由见 ai_page 同款处理）
      ProfileEntryTile(
        icon: Icons.language_outlined,
        label: '联系作者',
        subtitle: '作者主页：yinleilei.cn',
        onTap: () => launchUrl(
          Uri.parse(_authorHomeUrl),
          mode: LaunchMode.externalApplication,
        ),
      ),
      SizedBox(height: AppMetrics.gapMd.r),
      ProfileEntryTile(
        icon: Icons.chat_bubble_outline_rounded,
        label: '意见反馈',
        subtitle: '遇到问题或想提建议？告诉系统管理员',
        onTap: () => context.push(AppRoutes.feedbackPath),
      ),
      SizedBox(height: AppMetrics.gapMd.r),
      ProfileEntryTile(
        icon: Icons.password_rounded,
        label: '修改密码',
        subtitle: '记得旧密码时走这条；忘了就用登录页的「忘记密码」',
        onTap: () => context.push(AppRoutes.changePasswordPath),
      ),
      SizedBox(height: AppMetrics.gapMd.r),
      ProfileEntryTile(
        icon: Icons.logout_rounded,
        label: '退出登录',
        danger: true,
        onTap: onSignOut,
      ),
      // 版本号摆在明面上：下载页、更新弹窗、意见反馈三处用的是同一个 APP_VERSION，
      // 用户报"版本不同步"时能直接念出当前装的是哪一版。
      SizedBox(height: AppMetrics.gapLg.r),
      Center(
        child: Text(
          Env.appVersion.isEmpty ? '开发版' : '当前版本 ${Env.appVersion}',
          style: AppTextStyles.caption(context).copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    ],
  );
}
