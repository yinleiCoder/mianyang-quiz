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
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/ui/core/layout/section_header.dart';
import 'package:mianyang_quiz/ui/features/profile/widgets/profile_entry_tile.dart';

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
    ],
  );
}
