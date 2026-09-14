// 复盘的顶部汇总：正确率 / 答对 / 答错 / 未作答 / 用时。
//
// 职责：把快照里的数字摆成一组 DuoStatTile，并按可用宽度决定一行放几个。
// 不负责：取数（快照由复盘页给）、口径换算——正确率的分母是**总题数**（含未作答），
// 与交卷结算、练习记录列表完全一致，这里照实展示，不做二次加工。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';
import 'package:mianyang_quiz/ui/core/design/duo_icon_badge.dart';
import 'package:mianyang_quiz/ui/core/design/duo_stat_tile.dart';

class ReviewSummary extends StatelessWidget {
  const ReviewSummary({super.key, required this.snapshot});

  final PracticeSessionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final total = snapshot.totalCount;
    final answered = snapshot.answeredCount;
    final correct = snapshot.correctCount;
    // 服务端的计数理论上自洽；这里仍然夹一下，脏数据不该让界面显示负数。
    final wrong = (answered - correct).clamp(0, total);
    final omitted = (total - answered).clamp(0, total);
    final accuracy = total == 0 ? 0.0 : correct / total;

    final tiles = <Widget>[
      DuoStatTile(
        label: '正确率',
        value: Formatters.percent(accuracy),
        caption: '共 $total 题',
        icon: Icons.percent_rounded,
      ),
      DuoStatTile(
        label: '答对',
        value: '$correct',
        icon: Icons.check_circle_outline_rounded,
        tone: DuoIconBadgeTone.success,
      ),
      DuoStatTile(
        label: '答错',
        value: '$wrong',
        icon: Icons.cancel_outlined,
        tone: DuoIconBadgeTone.danger,
      ),
      DuoStatTile(
        label: '未作答',
        value: '$omitted',
        icon: Icons.remove_circle_outline_rounded,
        tone: DuoIconBadgeTone.neutral,
      ),
      DuoStatTile(
        label: '用时',
        value: Formatters.duration(snapshot.durationMs),
        icon: Icons.timer_outlined,
      ),
    ];

    // 宽屏一行三个、手机一行两个。写成 LayoutBuilder 而不是 GridView：
    // 这些卡高度一致、数量固定，GridView 的滚动语义在这里只会碍事。
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 560.r ? 3 : 2;
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
