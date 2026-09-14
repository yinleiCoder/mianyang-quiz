// 注册页。
//
// 职责：收姓名/邮箱/密码/身份/学校，选学生时再收就读信息，然后调 AuthStore.signUp。
// 不负责：写库细节——资料随 user_metadata 一起提交，由数据库的 handle_new_user 触发器
// 落进 profiles（键名不能改，见 auth_service.dart）。
//
// 两个分支值得记住：
//   · signUp 返回 true 表示服务端没直接给会话（邮箱验证还开着）→ 去验证页。
//     本项目服务端已关闭邮箱验证，正常走的是 false 那一支，直接进首页。
//   · 就读信息只在选学生时出现，提交时也只传学生的字段——服务端不会把教师填的
//     就读信息当成学生档案。
//
// 学校列表在本页拉：它是注册流程的一部分，失败时页面上给一次重试即可，
// 不为它单开一个 Store（没有第二个页面要写它）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/identity_meta.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/data/models/user/school.dart';
import 'package:mianyang_quiz/data/repositories/user_repository.dart';
import 'package:mianyang_quiz/state/auth_store.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/layout/section_header.dart';
import 'package:mianyang_quiz/ui/features/auth/widgets/auth_scaffold.dart';
import 'package:mianyang_quiz/ui/features/auth/widgets/basic_info_fields.dart';
import 'package:mianyang_quiz/ui/features/auth/widgets/enrollment_fields.dart';
import 'package:mianyang_quiz/ui/features/auth/widgets/identity_selector.dart';
import 'package:mianyang_quiz/ui/features/auth/widgets/school_picker_field.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _majorCategory = TextEditingController();
  final _major = TextEditingController();
  final _className = TextEditingController();

  Identity _identity = Identity.student;
  String? _schoolId;
  int? _enrollYear;
  AsyncValue<List<School>> _schools = const AsyncLoading<List<School>>();
  bool _busy = false;
  String? _error;

  bool get _isStudent => _identity == Identity.student;

  @override
  void initState() {
    super.initState();
    _loadSchools();
  }

  @override
  void dispose() {
    for (final controller in [
      _name,
      _email,
      _password,
      _majorCategory,
      _major,
      _className,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadSchools() async {
    setState(() => _schools = const AsyncLoading<List<School>>());
    try {
      final schools = await context.read<UserRepository>().fetchSchools();
      if (!mounted) return;
      setState(() => _schools = AsyncData(schools));
    } catch (error) {
      if (!mounted) return;
      setState(() => _schools = AsyncFailure(mapError(error)));
    }
  }

  Future<void> _submit() async {
    if (_busy || !(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final needsVerify = await context.read<AuthStore>().signUp(
        email: _email.text,
        password: _password.text,
        name: _name.text,
        // 选教师时传 teacherPending：它表达的正是「申请教师」的意图，
        // AuthService 落库时会归一成触发器认的那个 'teacher'。
        identity: _identity,
        schoolId: _schoolId,
        enrollYear: _isStudent ? _enrollYear : null,
        majorCategory: _isStudent ? _filled(_majorCategory) : null,
        major: _isStudent ? _filled(_major) : null,
        className: _isStudent ? _filled(_className) : null,
      );
      if (!mounted) return;
      if (needsVerify) {
        // 邮箱走 query 传过去：验证页是深链可达的，参数从 URI 读才不会丢。
        context.go(
          '${AppRoutes.emailVerifyPath}'
          '?email=${Uri.encodeQueryComponent(_email.text.trim())}',
        );
      } else {
        context.go(AppRoutes.homePath);
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = mapError(error).message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: '注册',
      subtitle: '填好基本信息就能开始刷题',
      error: _error,
      footer: _footer(context),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BasicInfoFields(
              nameController: _name,
              emailController: _email,
              passwordController: _password,
              enabled: !_busy,
            ),
            SizedBox(height: AppMetrics.gapXl.r),
            const SectionHeader(title: '身份'),
            IdentitySelector(
              value: _identity,
              enabled: !_busy,
              onChanged: (identity) => setState(() => _identity = identity),
            ),
            SizedBox(height: AppMetrics.gapLg.r),
            SchoolPickerField(
              schools: _schools,
              value: _schoolId,
              enabled: !_busy,
              onRetry: _loadSchools,
              onChanged: (schoolId) => setState(() => _schoolId = schoolId),
            ),
            if (_isStudent) ...[
              SizedBox(height: AppMetrics.gapXl.r),
              EnrollmentFields(
                enrollYear: _enrollYear,
                onEnrollYearChanged: (year) =>
                    setState(() => _enrollYear = year),
                majorCategoryController: _majorCategory,
                majorController: _major,
                classNameController: _className,
                enabled: !_busy,
              ),
            ],
            SizedBox(height: AppMetrics.gapXl.r),
            DuoButton(label: '注册', loading: _busy, onPressed: _submit),
          ],
        ),
      ),
    );
  }

  /// 底部次要动作。主按钮只有一个，这里要的是「顺手点一下」，所以用文字按钮。
  Widget _footer(BuildContext context) => TextButton(
    onPressed: _busy ? null : () => context.go(AppRoutes.loginPath),
    child: const Text('已有账号？去登录'),
  );
}

/// 控制器里的可选文本：只有空白当成「没填」，其余去掉首尾空白再传。
/// 服务端对空串与 null 的处理一致，但少传几个空值能让 metadata 干净些。
String? _filled(TextEditingController controller) {
  final value = controller.text.trim();
  return value.isEmpty ? null : value;
}
