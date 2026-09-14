// 学校选择框：注册时的一格下拉。
//
// 职责：把「加载中 / 加载失败 / 选好了」三态都画成一个输入框的样子，
// 让它在表单里与普通字段对齐（同样的圆角、同样的聚焦描边）。
// 不负责：取数——学校列表由页面拉好后传进来（AsyncValue 已经把三态表达清楚了）。
//
// 可空是刻意的：学校可以先不选，注册后再补。只有申请教师身份前才必须绑定学校
// （服务端会拦：「请先绑定所属学校后再申请教师身份」）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/data/models/user/school.dart';

class SchoolPickerField extends StatelessWidget {
  const SchoolPickerField({
    super.key,
    required this.schools,
    required this.value,
    required this.onChanged,
    this.onRetry,
    this.enabled = true,
  });

  /// 学校列表的三态。加载失败时本组件自己画「失败原因 + 重试」，
  /// 免得每个调用页各写一遍。
  final AsyncValue<List<School>> schools;

  /// 当前选中的学校 id；null = 暂不选择。
  final String? value;

  final ValueChanged<String?> onChanged;

  /// 加载失败时的重试回调；为 null 时不显示重试按钮。
  final VoidCallback? onRetry;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return switch (schools) {
      AsyncLoading<List<School>>() => _Shell(child: _loading(context)),
      AsyncFailure<List<School>>(:final error) => _failure(context, error.message),
      AsyncData<List<School>>(value: final options) => _dropdown(
        context,
        options,
      ),
    };
  }

  Widget _loading(BuildContext context) => Row(
    children: [
      SizedBox(
        width: 16.r,
        height: 16.r,
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
      SizedBox(width: AppMetrics.gapMd.r),
      Text(
        '正在加载学校列表…',
        style: AppTextStyles.body(
          context,
        ).copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    ],
  );

  Widget _failure(BuildContext context, String message) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(AppMetrics.gapMd.r),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 20.r,
            color: scheme.onErrorContainer,
          ),
          SizedBox(width: AppMetrics.gapSm.r),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: scheme.onErrorContainer),
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: scheme.onErrorContainer,
              ),
              child: const Text('重试'),
            ),
        ],
      ),
    );
  }

  Widget _dropdown(BuildContext context, List<School> options) {
    final theme = Theme.of(context);

    return DropdownButtonFormField<String?>(
      // 注意是 initialValue 而不是 value：后者已废弃（见 material_ui 的
      // fix_data/fix_dropdown_button.yaml）。FormField 只在挂载时读它，
      // 后续变化靠 onChanged 回传，所以调用方必须把选中的值同步存进自己的 State。
      initialValue: value,
      isExpanded: true,
      // 下拉的默认文字是 titleMedium，与输入框的 bodyLarge 不一致，这里拉平。
      style: theme.textTheme.bodyLarge?.copyWith(fontSize: 15.sp),
      decoration: const InputDecoration(
        labelText: '学校',
        prefixIcon: Icon(Icons.apartment_outlined),
      ),
      items: [
        const DropdownMenuItem<String?>(value: null, child: Text('暂不选择')),
        for (final school in options)
          DropdownMenuItem<String?>(value: school.id, child: Text(school.name)),
      ],
      onChanged: enabled ? onChanged : null,
    );
  }
}

/// 加载态的壳：与输入框同样的圆角与底色，三态切换时布局不跳。
class _Shell extends StatelessWidget {
  const _Shell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppMetrics.gapLg.r,
        vertical: AppMetrics.gapLg.r,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
        border: Border.all(
          color: scheme.outlineVariant,
          width: AppMetrics.hairline.r,
        ),
      ),
      child: child,
    );
  }
}
