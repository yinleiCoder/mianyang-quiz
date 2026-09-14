// 档案表单里的一行输入：标签 + 输入框 +（可选）一句说明。
//
// 职责：统一各个输入框的间距与提示写法；输入框本身的外观由主题的
// inputDecorationTheme 决定，这里不另设颜色。
// 不负责：校验与保存——提交时统一校验，错误用 SnackBar 说清楚，
// 逐字段的红字在只有五个字段的表单里只会让界面更吵。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';

class ProfileFormField extends StatelessWidget {
  const ProfileFormField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.help,
    this.keyboardType,
    this.maxLength,
    this.maxLines,
  });

  final TextEditingController controller;

  /// 字段名（如「姓名」）。
  final String label;

  /// 输入框里的示例值。
  final String? hint;

  /// 输入框下方的一句说明（如字符数上限的来由）。
  final String? help;

  final TextInputType? keyboardType;

  /// 长度上限；服务端也有一份，这里只是少跑一趟网络。传了就会显示字数计数。
  final int? maxLength;

  /// 多行输入（如反馈正文）；不传即单行。
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          maxLines: maxLines,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: label, hintText: hint),
        ),
        if (help != null) ...[
          SizedBox(height: AppMetrics.gapXs.r),
          Text(
            help!,
            style: AppTextStyles.caption(context)
                .copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}
