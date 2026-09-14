// 编辑资料页：姓名 + 学校 + 头像（学生另有就读信息）。
//
// 职责：把当前档案装进表单 → 提交两组 RPC → 让 AuthStore 重拉档案。
// 不负责：头像上传（AvatarPickerField 自己直传 OSS）、学校列表（SchoolPickerField）、
// 申请教师身份（资料页的事）。
//
// 服务端语义：update_own_profile 与 update_my_enrollment 都是**全量覆盖**——
// avatarUrl 传的就是「当前头像」，改名时也要原样带上，漏传（null）等于清空头像。
// 换校/解绑学校还有身份限制（教研组长、学校管理员），那些拒绝由服务端给中文文案；
// 照实提示即可，不要在端上预判。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/identity_meta.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/user/profile.dart';
import 'package:mianyang_quiz/data/repositories/user_repository.dart';
import 'package:mianyang_quiz/state/auth_store.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/layout/section_header.dart';
import 'package:mianyang_quiz/ui/features/profile/widgets/avatar_picker_field.dart';
import 'package:mianyang_quiz/ui/features/profile/widgets/enrollment_form_section.dart';
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
  final _enrollYear = TextEditingController();
  final _majorCategory = TextEditingController();
  final _major = TextEditingController();
  final _className = TextEditingController();

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
      _enrollYear.text = profile.enrollYear?.toString() ?? '';
      _majorCategory.text = profile.majorCategory ?? '';
      _major.text = profile.major ?? '';
      _className.text = profile.className ?? '';
      _schoolId = profile.schoolId;
      _avatarUrl = profile.avatarUrl;
      _initial = profile.initial;
      // 教师没有班级与专业，就读信息收起（服务端也只对学生有意义）。
      _showEnrollment = profile.identityValue != Identity.teacher;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _enrollYear.dispose();
    _majorCategory.dispose();
    _major.dispose();
    _className.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_saving) return;
    final name = _name.text.trim();
    if (name.isEmpty) {
      _toast('请先填写姓名');
      return;
    }
    final yearError = validateEnrollYear(_enrollYear.text);
    if (yearError != null) {
      _toast(yearError);
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
      if (_showEnrollment) {
        await users.updateEnrollment(
          enrollYear: parseEnrollYear(_enrollYear.text),
          majorCategory: optionalText(_majorCategory.text),
          major: optionalText(_major.text),
          className: optionalText(_className.text),
        );
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
                        onChanged: (id) {
                          if (!mounted) return;
                          setState(() => _schoolId = id);
                        },
                      ),
                      if (_showEnrollment) ...[
                        SizedBox(height: AppMetrics.gapXl.r),
                        EnrollmentFormSection(
                          enrollYear: _enrollYear,
                          majorCategory: _majorCategory,
                          major: _major,
                          className: _className,
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
