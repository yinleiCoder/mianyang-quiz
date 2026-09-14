// 身份二选一：学生 / 教师。
//
// 职责：两张可点的大卡片 + 一句随选项变化的说明，让用户选完立刻知道这个身份
// 意味着什么（要不要审核、能不能出题）。
// 不负责：提交与校验——选中值由页面持有，本组件只上报。
//
// 值用 Identity 枚举而不是 bool：身份在档案、路由守卫、权限判断里都是这个枚举，
// 多一个布尔量只会让"true 到底是哪个"这种问题反复出现。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/identity_meta.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';

class IdentitySelector extends StatelessWidget {
  const IdentitySelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  /// 当前选中项。注册场景只会是 [Identity.student] 或 [Identity.teacherPending]。
  final Identity value;

  final ValueChanged<Identity> onChanged;

  final bool enabled;

  /// 两个选项：值、卡片标题、图标。
  ///
  /// 教师这一项的值取 teacherPending 而不是 teacher——它表达的正是「申请教师」的意图。
  /// AuthService.signUp 落库时会归一成字面量 'teacher'（触发器只认这一个），
  /// 审核通过前档案就是 teacher_pending，所以这里用待审核态最贴切。
  static const _options = <(Identity, String, IconData)>[
    (Identity.student, '学生', Icons.person_outline_rounded),
    (Identity.teacherPending, '教师', Icons.co_present_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            for (var i = 0; i < _options.length; i++) ...[
              if (i > 0) SizedBox(width: AppMetrics.gapMd.r),
              Expanded(
                child: _OptionCard(
                  label: _options[i].$2,
                  icon: _options[i].$3,
                  selected: value == _options[i].$1,
                  onTap: enabled ? () => onChanged(_options[i].$1) : null,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: AppMetrics.gapMd.r),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 16.r,
              color: scheme.onSurfaceVariant,
            ),
            SizedBox(width: AppMetrics.gapSm.r),
            Expanded(
              child: Text(
                _hint,
                style: AppTextStyles.caption(
                  context,
                ).copyWith(color: scheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 说明文案与身份一起变。这段字决定了用户会不会误选教师，值得写全。
  String get _hint => switch (value) {
    Identity.student => '学生可浏览题库与刷题练习',
    _ => '教师身份需学校管理员审核，审核期间可正常刷题',
  };
}

/// 单个身份卡片：图标 + 标题，选中时整卡换成品牌底色并加粗描边。
class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;

  /// 为 null 即禁用（提交中），此时不响应点击。
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(AppMetrics.radiusButton.r);
    final foreground = selected
        ? scheme.onPrimaryContainer
        : scheme.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: ClipRRect(
        borderRadius: radius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
            color: selected
                ? scheme.primaryContainer
                : scheme.surfaceContainerHighest,
            borderRadius: radius,
            border: Border.all(
              color: selected ? scheme.primary : scheme.outlineVariant,
              width: (selected ? AppMetrics.stroke : AppMetrics.hairline).r,
            ),
          ),
          // 水波纹要画在底色之上，所以用透明的 Material 承载 InkWell，
          // 底色交给外层 AnimatedContainer。
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppMetrics.gapLg.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 28.r, color: foreground),
                    SizedBox(height: AppMetrics.gapSm.r),
                    Text(
                      label,
                      style: AppTextStyles.label(
                        context,
                      ).copyWith(color: foreground),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
