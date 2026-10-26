// 打卡区里的"为什么"：科学抽题 + 艾宾浩斯遗忘曲线。
//
// 用户 2026-10-24：连续打卡区域太空了，要给出本软件的科学抽题工作原理与
// 遗忘曲线原理。文案与「我的 → 学习计划」同源（values/science_notes.dart）。
//
// 单独成文件：streak_header.dart 已接近 200 行上限。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';

class ScienceNote extends StatelessWidget {
  const ScienceNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const _Line(
          icon: Icons.filter_alt_outlined,
          title: '科学抽题',
          body: ScienceNotes.selection,
        ),
        SizedBox(height: AppMetrics.gapMd.r),
        const _Line(
          icon: Icons.timeline_rounded,
          title: '遗忘曲线',
          body: ScienceNotes.forgetting,
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16.r, color: scheme.primary),
        SizedBox(width: AppMetrics.gapXs.r),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$title：',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                TextSpan(text: body),
              ],
            ),
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}
