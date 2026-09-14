// 就读信息四件套：入学年份 / 专业大类 / 专业 / 班级（只在选学生时出现）。
//
// 职责：把四个字段连同「就读信息」这个小标题一起给出，注册页与档案页可以共用同一套。
// 不负责：取数与提交——三个文本框的 controller 由页面持有，本组件只负责画和拦长度。
//
// 长度限制与服务端保持一致（见 user_repository.updateEnrollment 的注释：
// 专业大类/专业 ≤40 字、班级 ≤20 字；年份 2000~2100）。用 maxLength 直接拦在输入处，
// 而不是等服务端报错——超长被拒时用户已经写完了，「前置拦截」才是省事的那一边。
// 年份用下拉而不是手输：这个范围的年份不多，选比敲快，也免了「2O26」这种手滑。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/ui/core/layout/section_header.dart';

class EnrollmentFields extends StatelessWidget {
  const EnrollmentFields({
    super.key,
    required this.enrollYear,
    required this.onEnrollYearChanged,
    required this.majorCategoryController,
    required this.majorController,
    required this.classNameController,
    this.enabled = true,
  });

  /// 入学年份；null = 暂不填。
  final int? enrollYear;

  final ValueChanged<int?> onEnrollYearChanged;

  final TextEditingController majorCategoryController;
  final TextEditingController majorController;
  final TextEditingController classNameController;

  final bool enabled;

  /// 专业大类 / 专业的长度上限（与 update_my_enrollment 一致）。
  static const int _majorMaxLength = 40;

  /// 班级的长度上限。
  static const int _classMaxLength = 20;

  /// 可选年份，从近到远排——绝大多数用户要选的那一年就在最前面。
  static final List<int> _years = List.generate(101, (i) => 2100 - i);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SectionHeader(title: '就读信息', subtitle: '可先跳过，注册后在「我的」里补全'),
        DropdownButtonFormField<int>(
          initialValue: enrollYear,
          isExpanded: true,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontSize: 15.sp),
          decoration: const InputDecoration(
            labelText: '入学年份',
            prefixIcon: Icon(Icons.event_outlined),
          ),
          items: [
            const DropdownMenuItem<int>(value: null, child: Text('暂不选择')),
            for (final year in _years)
              DropdownMenuItem<int>(value: year, child: Text('$year 年')),
          ],
          onChanged: enabled ? onEnrollYearChanged : null,
        ),
        SizedBox(height: AppMetrics.gapLg.r),
        _enrollmentField(
          context,
          controller: majorCategoryController,
          label: '专业大类',
          hint: '如：装备制造大类',
          icon: Icons.category_outlined,
          maxLength: _majorMaxLength,
        ),
        SizedBox(height: AppMetrics.gapLg.r),
        _enrollmentField(
          context,
          controller: majorController,
          label: '专业',
          hint: '如：数控技术应用',
          icon: Icons.architecture_outlined,
          maxLength: _majorMaxLength,
        ),
        SizedBox(height: AppMetrics.gapLg.r),
        _enrollmentField(
          context,
          controller: classNameController,
          label: '班级',
          hint: '如：23 数控 1 班',
          icon: Icons.groups_outlined,
          maxLength: _classMaxLength,
          action: TextInputAction.done,
        ),
      ],
    );
  }

  Widget _enrollmentField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required int maxLength,
    TextInputAction action = TextInputAction.next,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      maxLength: maxLength,
      textInputAction: action,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
