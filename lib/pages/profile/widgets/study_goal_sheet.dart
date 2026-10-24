// 今日目标题数的设置半屏（5~200，默认 20）。
//
// 为什么要设置而不是写死：学生每天能投入的时间差别很大，10 题对一部分人太少、
// 对另一部分人又完不成。目标只影响首页进度条与提醒，不参与任何统计或排行——
// 这一点要在界面上说清楚，否则学生会以为"没到 20 题就不算练习"。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:provider/provider.dart';

Future<void> showStudyGoalSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => const _StudyGoalSheet(),
    );

class _StudyGoalSheet extends StatefulWidget {
  const _StudyGoalSheet();

  @override
  State<_StudyGoalSheet> createState() => _StudyGoalSheetState();
}

class _StudyGoalSheetState extends State<_StudyGoalSheet> {
  static const _presets = [10, 20, 30, 50];
  late int _goal;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _goal = context.read<CheckinStore>().dailyGoal;
  }

  void _bump(int delta) =>
      setState(() => _goal = (_goal + delta).clamp(5, 200));

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await context.read<CheckinStore>().saveGoal(_goal);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mapError(error).message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppMetrics.gapLg.r,
          0,
          AppMetrics.gapLg.r,
          AppMetrics.gapXl.r,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('今日目标题数', style: theme.textTheme.titleLarge),
            SizedBox(height: AppMetrics.gapSm.r),
            Text(
              '只用于首页进度与提醒，不参与统计或排行。',
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: scheme.onSurfaceVariant),
            ),
            SizedBox(height: AppMetrics.gapLg.r),
            Wrap(
              spacing: AppMetrics.gapSm.r,
              children: [
                for (final preset in _presets)
                  ChoiceChip(
                    label: Text('$preset 题'),
                    selected: _goal == preset,
                    onSelected: (_) => setState(() => _goal = preset),
                  ),
              ],
            ),
            SizedBox(height: AppMetrics.gapLg.r),
            Row(
              children: [
                IconButton.filledTonal(
                  onPressed: _goal > 5 ? () => _bump(-5) : null,
                  icon: const Icon(Icons.remove),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '$_goal 题',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: _goal < 200 ? () => _bump(5) : null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: AppMetrics.gapLg.r),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? SizedBox(
                        width: 18.r,
                        height: 18.r,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('保存'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
