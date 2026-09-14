// 编辑资料里的「学校」一行：显示当前学校，点开是选择器。
//
// 职责：拉取可选学校（只取启用中的，与服务端换校的校验一致）、渲染当前值、
// 弹出选择器，把用户的选择回给页面。
// 不负责：写库——这里改的只是**表单值**，用户不点保存就离开，什么都不会发生。
//
// 为什么让组件自己拉列表：学校列表只有这一处用，提到页面只会让页面多一份
// 与它无关的加载状态。它是 feature 内的私有组件，不违反「共享 UI 不得取数」。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/user/school.dart';
import 'package:mianyang_quiz/data/repositories/user_repository.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/features/profile/widgets/school_picker_sheet.dart';
import 'package:provider/provider.dart';

class SchoolPickerField extends StatefulWidget {
  const SchoolPickerField({
    super.key,
    required this.schoolId,
    required this.onChanged,
  });

  /// 当前绑定的学校；null = 未绑定。
  final String? schoolId;

  final ValueChanged<String?> onChanged;

  @override
  State<SchoolPickerField> createState() => _SchoolPickerFieldState();
}

class _SchoolPickerFieldState extends State<SchoolPickerField> {
  List<School> _schools = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final schools = await context.read<UserRepository>().fetchSchools();
      if (!mounted) return;
      setState(() {
        _schools = schools;
        _loading = false;
      });
    } on AppException catch (error) {
      // 拉不到时不让整页崩：显示当前的绑定值，点一下可以重试。
      debugPrint('学校列表加载失败：${error.message}');
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _pick() async {
    await pickSchool(
      context,
      schools: _schools,
      selectedId: widget.schoolId,
      onPicked: (id) {
        if (!mounted) return;
        widget.onChanged(id);
      },
    );
  }

  String get _label {
    final schoolId = widget.schoolId;
    if (schoolId == null) return '暂不绑定';
    for (final school in _schools) {
      if (school.id == schoolId) return school.name;
    }
    if (_loading) return '加载中…';
    // 列表为空且不在加载：要么没拉到，要么这所学校已停用。都别谎报成「未绑定」。
    return _schools.isEmpty ? '学校列表未加载，点击重试' : '已停用学校（请改选一所）';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DuoCard(
      // 列表为空时点一下是「重试加载」，不是打开选择器（打开也是空的）。
      onTap: _loading ? null : (_schools.isEmpty ? _load : _pick),
      padding: EdgeInsets.symmetric(
        horizontal: AppMetrics.gapLg.r,
        vertical: AppMetrics.gapMd.r,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '学校',
                  style: AppTextStyles.caption(context)
                      .copyWith(color: scheme.onSurfaceVariant),
                ),
                SizedBox(height: AppMetrics.gapXs.r),
                Text(
                  _label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body(context),
                ),
              ],
            ),
          ),
          SizedBox(width: AppMetrics.gapSm.r),
          Icon(
            Icons.chevron_right_rounded,
            size: 20.r,
            color: scheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
