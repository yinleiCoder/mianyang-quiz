// 平台规模：学校 / 学生 / 教师 / 市区（迁移 0114 的 platform_stats）。
//
// 用户 2026-10-24：首页要能看到当前系统的这四个总数（四川全省共享）。
// 数据是全局口径，走 RPC 而不是直查 profiles —— 学生只能看到本校本班的人，
// 直接 count 会数少；RPC 只返回四个整数，不泄露任何个人行。
//
// 失败不影响首页其他内容：这一段自己显示一句"暂时取不到"与重试按钮。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:provider/provider.dart';

class PlatformScaleSection extends StatefulWidget {
  const PlatformScaleSection({super.key});

  @override
  State<PlatformScaleSection> createState() => _PlatformScaleSectionState();
}

class _PlatformScaleSectionState extends State<PlatformScaleSection> {
  PlatformStats? _stats;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _load();
    });
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final stats = await context.read<StatsRepository>().fetchPlatformStats();
      if (!mounted) return;
      setState(() {
        _stats = stats;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = mapError(error).message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: '平台规模',
          subtitle: '四川全省共享：学校、学生、教师与市区数量',
        ),
        SizedBox(height: AppMetrics.gapMd.r),
        if (_loading)
          const DuoCard(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
        else if (_error != null)
          DuoCard(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _error!,
                    style: AppTextStyles.caption(context).copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                TextButton(onPressed: _load, child: const Text('重试')),
              ],
            ),
          )
        else
          _StatsGrid(stats: _stats ?? const PlatformStats()),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final PlatformStats stats;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      DuoStatTile(
        label: '学校',
        value: '${stats.schools}',
        icon: Icons.school_outlined,
      ),
      DuoStatTile(
        label: '学生',
        value: '${stats.students}',
        icon: Icons.groups_outlined,
      ),
      DuoStatTile(
        label: '教师',
        value: '${stats.teachers}',
        icon: Icons.badge_outlined,
      ),
      DuoStatTile(
        label: '市区',
        value: '${stats.cities}',
        icon: Icons.location_city_outlined,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 720 ? 4 : 2;
        final gap = AppMetrics.gapMd.r;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final tile in tiles) SizedBox(width: width, child: tile),
          ],
        );
      },
    );
  }
}
