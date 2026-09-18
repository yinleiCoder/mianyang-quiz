// 编辑资料页：姓名 + 学校 + 头像（学生另有就读信息）。
//
// 职责：把当前档案装进表单 → 提交两组 RPC → 让 AuthStore 重拉档案。
// 不负责：头像上传（AvatarPickerField 自己直传 OSS）、学校列表（SchoolPickerField）、
// 申请教师身份（资料页的事）。
//
// 服务端语义：update_own_profile 与 update_my_study_info 都是**全量覆盖**——
// avatarUrl 传的就是「当前头像」，改名时也要原样带上，漏传（null）等于清空头像；
// classId 传 null 也是「清掉班级」而不是「不改」。
// 换校/解绑学校还有身份限制（教研组长、学校管理员），那些拒绝由服务端给中文文案；
// 照实提示即可，不要在端上预判。

import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/identity_meta.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/data/models/user/profile.dart';
import 'package:mianyang_quiz/data/models/user/school_class.dart';
import 'package:mianyang_quiz/data/repositories/user_repository.dart';
import 'package:mianyang_quiz/state/auth_store.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/layout/section_header.dart';
import 'package:mianyang_quiz/ui/features/profile/widgets/avatar_picker_field.dart';
import 'package:mianyang_quiz/ui/core/form/enrollment_fields.dart';
import 'package:mianyang_quiz/ui/features/profile/widgets/profile_form_field.dart';
import 'package:mianyang_quiz/ui/features/profile/widgets/school_picker_field.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _name = TextEditingController();
  // 入学年份与班级都是"选"而不是"填"（与注册页同一套组件）；专业由班级派生，不在这儿选
  int? _enrollYear;
  String? _classId;
  // 所选学校的班级。与注册页同一套：拉不到不阻断保存，只让班级下拉不可用。
  // 没绑学校时是"有数据的空列表"，好让下拉落进"禁用 + 说明"而不是一直转圈
  AsyncValue<List<SchoolClass>> _classes = const AsyncData<List<SchoolClass>>([]);

  String? _schoolId;
  String? _avatarUrl;
  String? _localAvatarPath;
  String _initial = '?';
  // 就读信息默认显示（学生是多数），只有确认身份是教师时才收起——
  // 档案拉不到时宁可多给一段，也别让学生找不到改班级的地方。
  bool _showEnrollment = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final profile = context.read<AuthStore>().profile;
    if (profile != null) {
      _name.text = profile.name;
      _enrollYear = profile.enrollYear;
      _classId = profile.classId;
      _schoolId = profile.schoolId;
      _avatarUrl = profile.avatarUrl;
      _initial = profile.initial;
      // 教师没有班级与专业，就读信息收起（服务端也只对学生有意义）。
      _showEnrollment = profile.identityValue != Identity.teacher;
    }
    // 班级按档案里的学校拉（登录后读，权限本来就有）：失败只让班级下拉禁用，不阻断本页
    final schoolId = _schoolId;
    if (schoolId != null) unawaited(_loadClasses(schoolId));
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  /// 换学校必须清掉班级：旧班级属于原学校，服务端 update_my_study_info 会直接拒
  /// （「该班级不属于你所在的学校，或已停用」），留着只会让人白存一次。
  /// 学校清空后班级也归零——没有学校就没有可选的班。
  void _onSchoolChanged(String? schoolId) {
    if (schoolId == _schoolId) return;
    setState(() {
      _schoolId = schoolId;
      _classId = null;
      _classes = const AsyncData<List<SchoolClass>>([]);
    });
    if (schoolId != null) unawaited(_loadClasses(schoolId));
  }

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
    if (_saving) return;
    final name = _name.text.trim();
    if (name.isEmpty) {
      _toast('请先填写姓名');
      return;
    }
    setState(() => _saving = true);
    // 依赖先取好：await 之后除了已判过 mounted 的提示，不再碰 context。
    final users = context.read<UserRepository>();
    final auth = context.read<AuthStore>();
    try {
      // 两个 RPC 不是一个事务：档案成功、就读信息失败时重试保存即可，不会回滚姓名。
      await users.updateProfile(
        name: name,
        schoolId: _schoolId,
        avatarUrl: _avatarUrl,
      );
      // 没绑学校时不发这次请求：update_my_study_info 的第一道断言就是「已绑定学校」，
      // 连"只改入学年份"都会被拒（「请先绑定所属学校后再选择班级」），
      // 那会让没绑校的学生连改个名字都存不下去。班级在没学校时本来就无从选起，
      // 入学年份也就跟着一起留着——就读信息这一段在页面上是禁用 + 说明的。
      if (_showEnrollment && _schoolId != null) {
        await users.updateStudyInfo(enrollYear: _enrollYear, classId: _classId);
      }
      await auth.refreshProfile();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('已保存')));
      context.pop();
    } on AppException catch (error) {
      if (!mounted) return;
      _toast(error.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final muted = AppTextStyles.caption(context)
        .copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);

    return Scaffold(
      appBar: AppBar(title: const Text('编辑资料')),
      body: SafeArea(
        child: ListView(
                    padding: EdgeInsets.all(AppMetrics.pagePadding.r),
                    children: [
                      AvatarPickerField(
                        initial: _initial,
                        avatarUrl: _avatarUrl,
                        localPath: _localAvatarPath,
                        onUploaded: (upload) {
                          if (!mounted) return;
                          setState(() {
                            _avatarUrl = upload.key;
                            _localAvatarPath = upload.path;
                          });
                        },
                        onError: _toast,
                      ),
                      SizedBox(height: AppMetrics.gapXl.r),
                      const SectionHeader(title: '基本信息'),
                      ProfileFormField(
                        controller: _name,
                        label: '姓名',
                        hint: '与学籍一致的姓名',
                      ),
                      SizedBox(height: AppMetrics.gapMd.r),
                      SchoolPickerField(
                        schoolId: _schoolId,
                        onChanged: _onSchoolChanged,
                      ),
                      if (_showEnrollment) ...[
                        SizedBox(height: AppMetrics.gapXl.r),
                        EnrollmentFields(
                          enrollYear: _enrollYear,
                          onEnrollYearChanged: (v) =>
                              setState(() => _enrollYear = v),
                          classId: _classId,
                          onClassIdChanged: (v) =>
                              setState(() => _classId = v),
                          classes: _classes.valueOrNull ?? const [],
                          hasSchool: _schoolId != null,
                          classesLoading: _classes.isLoading,
                          enabled: !_saving,
                        ),
                      ],
                      SizedBox(height: AppMetrics.gapXl.r),
                      DuoButton(
                        label: '保存',
                        icon: Icons.check_rounded,
                        loading: _saving,
                        onPressed: _submit,
                      ),
                      SizedBox(height: AppMetrics.gapSm.r),
                      Text('姓名与头像会显示在练习记录里。', style: muted),
                    ],
                  ),
      ),
    );
  }
}
