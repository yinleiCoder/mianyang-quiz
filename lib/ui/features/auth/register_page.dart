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
// 不为它单开一个 Store（没有第二个页面要写它）。班级列表**跟着所选学校走**，
// 所以在换校时按需拉（见 _onSchoolChanged）——学校没选之前没有"哪个学校的班"可言。

import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/identity_meta.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/data/models/user/school.dart';
import 'package:mianyang_quiz/data/models/user/school_class.dart';
import 'package:mianyang_quiz/data/repositories/user_repository.dart';
import 'package:mianyang_quiz/state/auth_store.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/layout/section_header.dart';
import 'package:mianyang_quiz/ui/features/auth/widgets/auth_scaffold.dart';
import 'package:mianyang_quiz/ui/features/auth/widgets/basic_info_fields.dart';
import 'package:mianyang_quiz/ui/core/form/enrollment_fields.dart';
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
  // 班级是下拉，值是 id 而不是文本（专业大类/专业已由班级派生，不再单独选）
  String? _classId;

  Identity _identity = Identity.student;
  String? _schoolId;
  int? _enrollYear;
  AsyncValue<List<School>> _schools = const AsyncLoading<List<School>>();
  // 所选学校的班级（0063，表对 anon 开了只读，注册前就能拉）。
  // 没选学校时是"有数据的空列表"，好让班级下拉落进"禁用 + 说明"而不是一直转圈。
  AsyncValue<List<SchoolClass>> _classes = const AsyncData<List<SchoolClass>>([]);
  bool _busy = false;
  String? _error;

  bool get _isStudent => _identity == Identity.student;

  @override
  void initState() {
    super.initState();
    _loadReferenceData();
  }

  @override
  void dispose() {
    for (final controller in [_name, _email, _password]) {
      controller.dispose();
    }
    super.dispose();
  }

  /// 注册要用的参考数据：学校名单。失败不阻断注册（学校是可选项，页面上给一次重试）。
  /// 班级不在这里拉——它随所选学校而变，见 [_onSchoolChanged]。
  Future<void> _loadReferenceData() async {
    setState(() => _schools = const AsyncLoading<List<School>>());
    final schools = await asAsyncValue(
      context.read<UserRepository>().fetchSchools,
    );
    if (!mounted) return;
    setState(() => _schools = schools);
  }

  /// 换学校必须清掉班级：旧班级属于另一所学校，留着提交上去服务端会静默丢弃
  /// （handle_new_user 里不 raise，只退化成"未分班"），学生却以为自己分好班了。
  void _onSchoolChanged(String? schoolId) {
    if (schoolId == _schoolId) return;
    setState(() {
      _schoolId = schoolId;
      _classId = null;
      _classes = const AsyncData<List<SchoolClass>>([]);
    });
    if (schoolId != null) unawaited(_loadClasses(schoolId));
  }

  /// 拉某所学校的班级。失败只让班级下拉禁用，不影响注册主流程。
  Future<void> _loadClasses(String schoolId) async {
    setState(() => _classes = const AsyncLoading<List<SchoolClass>>());
    final classes = await asAsyncValue(
      () => context.read<UserRepository>().fetchClasses(schoolId: schoolId),
    );
    // 期间又换了学校：这份结果已经是上一所学校的，丢掉（否则会盖住新学校的班级）
    if (!mounted || _schoolId != schoolId) return;
    setState(() => _classes = classes);
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
        classId: _isStudent ? _classId : null,
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
      // 底部次要动作：主按钮只有一个，这里要的是「顺手点一下」，所以用文字按钮
      footer: TextButton(
        onPressed: _busy ? null : () => context.go(AppRoutes.loginPath),
        child: const Text('已有账号？去登录'),
      ),
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
              onRetry: _loadReferenceData,
              onChanged: _onSchoolChanged,
            ),
            if (_isStudent) ...[
              SizedBox(height: AppMetrics.gapXl.r),
              EnrollmentFields(
                enrollYear: _enrollYear,
                onEnrollYearChanged: (year) =>
                    setState(() => _enrollYear = year),
                classId: _classId,
                onClassIdChanged: (v) => setState(() => _classId = v),
                classes: _classes.valueOrNull ?? const [],
                hasSchool: _schoolId != null,
                classesLoading: _classes.isLoading,
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
}