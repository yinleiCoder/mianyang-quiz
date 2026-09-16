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
import 'package:mianyang_quiz/data/models/bank/subject_node.dart';
import 'package:mianyang_quiz/data/models/user/school.dart';
import 'package:mianyang_quiz/data/repositories/subject_repository.dart';
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
  final _className = TextEditingController();
  // 专业大类/专业改成从科目树里选，所以是值而不是控制器
  String? _majorCategory;
  String? _major;

  Identity _identity = Identity.student;
  String? _schoolId;
  int? _enrollYear;
  AsyncValue<List<School>> _schools = const AsyncLoading<List<School>>();
  // 专业目录（subject_nodes 的专业树）：注册时还没登录，靠迁移 0039 对 anon 开的只读
  AsyncValue<List<SubjectNode>> _nodes = const AsyncLoading<List<SubjectNode>>();
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
    for (final controller in [_name, _email, _password, _className]) {
      controller.dispose();
    }
    super.dispose();
  }

  /// 注册要用的两份参考数据：学校名单 + 专业目录（后者供专业大类/专业下拉）。
  /// 两份并行拉、各自独立失败——任何一份拉不到都不该阻断注册（对应的选择项禁用即可）。
  Future<void> _loadReferenceData() async {
    setState(() {
      _schools = const AsyncLoading<List<School>>();
      _nodes = const AsyncLoading<List<SubjectNode>>();
    });
    // 两个 future 同时起，再依次 await：并行取数、类型清晰、任一失败都不影响另一个
    final schoolsFuture = asAsyncValue(context.read<UserRepository>().fetchSchools);
    final nodesFuture = asAsyncValue(context.read<SubjectRepository>().fetchNodes);
    final schools = await schoolsFuture;
    final nodes = await nodesFuture;
    if (!mounted) return;
    setState(() {
      _schools = schools;
      _nodes = nodes;
    });
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
        majorCategory: _isStudent ? _majorCategory : null,
        major: _isStudent ? _major : null,
        className: _isStudent ? optionalText(_className.text) : null,
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
              onChanged: (schoolId) => setState(() => _schoolId = schoolId),
            ),
            if (_isStudent) ...[
              SizedBox(height: AppMetrics.gapXl.r),
              EnrollmentFields(
                enrollYear: _enrollYear,
                onEnrollYearChanged: (year) =>
                    setState(() => _enrollYear = year),
                majorCategory: _majorCategory,
                onMajorCategoryChanged: (v) =>
                    setState(() => _majorCategory = v),
                major: _major,
                onMajorChanged: (v) => setState(() => _major = v),
                classNameController: _className,
                nodes: _nodes.valueOrNull ?? const [],
                nodesLoading: _nodes.isLoading,
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