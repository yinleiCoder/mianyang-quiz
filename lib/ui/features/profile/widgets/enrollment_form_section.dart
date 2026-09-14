// 就读信息表单段（学生）：入学年份、专业大类、专业、班级。
//
// 职责：把四个字段摆成一段，并把服务端的**全量覆盖**语义写在副标题里——
// 用户必须知道「留空 = 清空」，不然会以为不填就等于不改（这是服务端行为，
// update_my_enrollment 对每个字段都做 nullif(trim())）。
// 不负责：校验与保存；控制器由页面持有，提交时页面直接读，避免表单值在
// 「组件内部 → 回调 → 页面」之间来回同步。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/ui/core/layout/section_header.dart';
import 'package:mianyang_quiz/ui/features/profile/widgets/profile_form_field.dart';

class EnrollmentFormSection extends StatelessWidget {
  const EnrollmentFormSection({
    super.key,
    required this.enrollYear,
    required this.majorCategory,
    required this.major,
    required this.className,
  });

  final TextEditingController enrollYear;
  final TextEditingController majorCategory;
  final TextEditingController major;
  final TextEditingController className;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SectionHeader(title: '就读信息', subtitle: '留空的项会被清空'),
        ProfileFormField(
          controller: enrollYear,
          label: '入学年份',
          hint: '如 2024',
          keyboardType: TextInputType.number,
          maxLength: 4,
        ),
        SizedBox(height: AppMetrics.gapMd.r),
        ProfileFormField(
          controller: majorCategory,
          label: '专业大类',
          hint: '如 计算机类',
          maxLength: 40,
        ),
        SizedBox(height: AppMetrics.gapMd.r),
        ProfileFormField(
          controller: major,
          label: '专业',
          hint: '如 计算机应用',
          maxLength: 40,
        ),
        SizedBox(height: AppMetrics.gapMd.r),
        ProfileFormField(
          controller: className,
          label: '班级',
          hint: '如 24 计应 1 班',
          maxLength: 20,
        ),
      ],
    );
  }
}

/// 入学年份的端上校验：返回 null = 合法，否则是给用户看的文案。
/// 服务端同样校验（2000~2100），这里只是为了少跑一趟网络、提示也更具体。
/// 留空是合法的——它的含义是「清空这一项」，不是「填错」。
String? validateEnrollYear(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return null;
  final year = int.tryParse(trimmed);
  if (year == null || year < 2000 || year > 2100) {
    return '入学年份请填 2000~2100 之间的年份，如 2024';
  }
  return null;
}

/// 表单文本 → 入库值。去空白；空串归一成 null——服务端按 nullif(trim()) 落库，两者同义。
String? optionalText(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

/// 已通过 [validateEnrollYear] 的年份文本 → int?。
int? parseEnrollYear(String text) {
  final trimmed = text.trim();
  return trimmed.isEmpty ? null : int.tryParse(trimmed);
}
