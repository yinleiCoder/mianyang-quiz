// 个人资料页。
//
// 职责：读 AuthStore 显示档案（头像/姓名/邮箱/学校/身份/就读信息），
// 并给出四个入口：编辑资料、修改就读信息、申请教师身份、退出登录。
// 不负责：档案的加载与缓存（AuthStore 的事）、表单编辑（EditProfilePage）。
//
// 学校名要单独查一次 schools：档案里只有 school_id，没有校名。
// 查不到时不阻塞整页——学校名只是锦上添花，用来拦住用户看资料就本末倒置了。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/identity_meta.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/user/profile.dart';
import 'package:mianyang_quiz/data/models/user/school.dart';
import 'package:mianyang_quiz/data/repositories/user_repository.dart';
import 'package:mianyang_quiz/state/auth_store.dart';
import 'package:mianyang_quiz/ui/core/feedback/loading_state.dart';
import 'package:mianyang_quiz/ui/core/layout/section_header.dart';
import 'package:mianyang_quiz/ui/features/profile/widgets/confirm_dialog.dart';
import 'package:mianyang_quiz/ui/features/profile/widgets/profile_entry_tile.dart';
import 'package:mianyang_quiz/ui/features/profile/widgets/profile_header.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<School> _schools = const [];
  bool _requesting = false;

  @override
  void initState() {
    super.initState();
    _loadSchools();
  }

  Future<void> _loadSchools() async {
    try {
      // 不过滤启用状态：停用学校的名字仍要能显示（老档案里可能还挂着它）。
      final schools = await context.read<UserRepository>().fetchSchools(
        onlyActive: false,
      );
      if (!mounted) return;
      setState(() => _schools = schools);
    } on AppException catch (error) {
      // 校名只是加分项，失败就不显示；档案来自 AuthStore，整页照常可用。
      debugPrint('学校列表加载失败：${error.message}');
    }
  }

  String? _schoolName(String? id) {
    if (id == null) return null;
    for (final school in _schools) {
      if (school.id == id) return school.name;
    }
    return null;
  }

  Future<void> _requestTeacher() async {
    final confirmed = await confirmAction(
      context,
      title: '申请教师身份？',
      message: '提交后由学校管理员审核，审核期间可以正常刷题。',
      confirmLabel: '提交申请',
    );
    if (!confirmed) return;
    if (!mounted) return;

    setState(() => _requesting = true);
    try {
      await context.read<UserRepository>().requestTeacherIdentity();
      if (!mounted) return;
      // 档案里的 identity 会变成 teacher_pending，必须重拉一次页面才会变。
      await context.read<AuthStore>().refreshProfile();
      if (!mounted) return;
      _toast('申请已提交，等待学校管理员审核');
    } on AppException catch (error) {
      if (!mounted) return;
      _toast(error.message);
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  Future<void> _signOut() async {
    final confirmed = await confirmAction(
      context,
      title: '退出登录？',
      message: '退出后需要重新输入邮箱和密码。',
      confirmLabel: '退出登录',
      danger: true,
    );
    if (!confirmed) return;
    if (!mounted) return;

    try {
      await context.read<AuthStore>().signOut();
      if (!mounted) return;
      context.go(AppRoutes.loginPath);
    } on AppException catch (error) {
      if (!mounted) return;
      _toast(error.message);
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthStore>();
    final profile = auth.profile;

    return Scaffold(
      body: SafeArea(
        child: profile == null
            ? const LoadingState(message: '正在加载档案…')
            : _body(context, profile),
      ),
    );
  }

  Widget _body(BuildContext context, Profile profile) {
    final identity = profile.identityValue;

    return ListView(
      padding: EdgeInsets.all(AppMetrics.pagePadding.r),
      children: [
        Text('个人资料', style: AppTextStyles.pageTitle(context)),
        SizedBox(height: AppMetrics.gapLg.r),
        ProfileHeader(
          profile: profile,
          schoolName: _schoolName(profile.schoolId),
        ),
        SizedBox(height: AppMetrics.gapXl.r),
        const SectionHeader(title: '账号与身份'),
        ProfileEntryTile(
          icon: Icons.edit_outlined,
          label: '编辑资料',
          subtitle: '姓名、学校、头像',
          onTap: () => context.push(AppRoutes.editProfilePath),
        ),
        if (identity != Identity.teacher) ...[
          SizedBox(height: AppMetrics.gapMd.r),
          ProfileEntryTile(
            icon: Icons.badge_outlined,
            label: '修改就读信息',
            subtitle: '入学年份、专业、班级',
            onTap: () => context.push(AppRoutes.editProfilePath),
          ),
        ],
        if (identity == Identity.student) ...[
          SizedBox(height: AppMetrics.gapMd.r),
          ProfileEntryTile(
            icon: Icons.school_outlined,
            label: '申请教师身份',
            subtitle: '需先绑定学校；通过后可以出题、参与审批',
            onTap: _requesting ? null : _requestTeacher,
            trailing: _requesting
                ? SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
          ),
        ],
        SizedBox(height: AppMetrics.gapXl.r),
        const SectionHeader(title: '其他'),
        ProfileEntryTile(
          icon: Icons.chat_bubble_outline_rounded,
          label: '意见反馈',
          subtitle: '遇到问题或想提建议？告诉系统管理员',
          onTap: () => context.push(AppRoutes.feedbackPath),
        ),
        SizedBox(height: AppMetrics.gapMd.r),
        ProfileEntryTile(
          icon: Icons.logout_rounded,
          label: '退出登录',
          danger: true,
          onTap: _signOut,
        ),
      ],
    );
  }
}
