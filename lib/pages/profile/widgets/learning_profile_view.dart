// 学生自己的学习画像卡片：雷达图 + 画像标签 + 一句总结 + 六轴数值。
//
// 只给自己看：不显示班级排名/同学对比，不提供公开分享入口。
// persona/summary 来自 utils/profile_persona.dart（与网页端镜像）。
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/utils/profile_persona.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:mianyang_quiz/pages/profile/widgets/learning_profile_radar.dart';
import 'package:mianyang_quiz/pages/profile/widgets/learning_profile_stat.dart';

class LearningProfileView extends StatelessWidget {
  const LearningProfileView({super.key, required this.profile});

  final LearningProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: scheme.onSurfaceVariant,
      height: 1.5,
    );
    final persona = buildProfilePersona(profile.axes);
    final summary = buildProfileSummary(profile.axes, persona);
    final sufficient = profile.axes
        .where((axis) => axis.score != null && axis.sufficient)
        .length;
    final canDraw = sufficient >= 5;
    final missing = profile.axes.where((axis) => axis.score == null).toList();
    final effort = profile.axisOf('effort');
    final accuracy = profile.axisOf('accuracy');
    final mastery = profile.axisOf('mastery');
    final activeDays = effort?.raw['active_days_28'];

    return DuoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.radar_rounded, size: 20.r, color: scheme.primary),
              SizedBox(width: AppMetrics.gapSm.r),
              Expanded(
                child: Text(
                  '我的学习画像',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              DuoChip(
                label: persona.label,
                tone: DuoChipTone.brand,
                dense: true,
              ),
            ],
          ),
          SizedBox(height: AppMetrics.gapXs.r),
          Text(
            '只对自己可见 · 数据窗口 ${profile.windowDays} 天',
            style: muted,
          ),
          if (canDraw) ...[
            SizedBox(height: AppMetrics.gapMd.r),
            LearningProfileRadar(axes: profile.axes),
            if (missing.isNotEmpty)
              Text(
                '数据不足：${missing.map((axis) => axis.label).join('、')}（图上按 0 显示）',
                style: muted?.copyWith(color: scheme.tertiary),
              ),
          ] else ...[
            SizedBox(height: AppMetrics.gapMd.r),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppMetrics.gapMd.r),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '画像还在成长中',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: AppMetrics.gapXs.r),
                  Text(
                    '再完成一些练习（每题至少 5 份已判分作答、连续 5 天活跃），就能画出完整六轴。',
                    style: muted,
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: AppMetrics.gapMd.r),
          Wrap(
            spacing: 6.r,
            runSpacing: 6.r,
            children: profile.axes
                .map(
                  (axis) => DuoChip(
                    label: '${axis.label} ${axis.score?.round() ?? '—'}',
                    dense: true,
                  ),
                )
                .toList(),
          ),
          SizedBox(height: AppMetrics.gapMd.r),
          Row(
            children: [
              Expanded(
                child: LearningProfileStat(
                  label: '练习天数（28 天）',
                  value: activeDays is num ? '${activeDays.toInt()} 天' : '—',
                ),
              ),
              SizedBox(width: AppMetrics.gapSm.r),
              Expanded(
                child: LearningProfileStat(
                  label: '准确率',
                  value: _scoreText(accuracy?.score, '%'),
                ),
              ),
              SizedBox(width: AppMetrics.gapSm.r),
              Expanded(
                child: LearningProfileStat(
                  label: '掌握力',
                  value: _scoreText(mastery?.score, ' 分'),
                ),
              ),
            ],
          ),
          SizedBox(height: AppMetrics.gapMd.r),
          Text(summary, style: theme.textTheme.bodyMedium),
          if (profile.caveats.isNotEmpty) ...[
            SizedBox(height: AppMetrics.gapSm.r),
            Text(profile.caveats.join('；'), style: muted),
          ],
        ],
      ),
    );
  }

  String _scoreText(double? value, String suffix) {
    return value == null ? '—' : '${value.round()}$suffix';
  }
}
