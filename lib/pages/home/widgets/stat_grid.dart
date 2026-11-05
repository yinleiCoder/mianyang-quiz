// 首页三个累计数字：累计答题 / 正确率 / 错题。
//
// 从 home_page.dart 拆出来（那个文件 2026-11-05 加学习画像后顶到 205 行，
// 超过 tool/check_architecture.dart 的 200 行上限）。
//
// 用 DuoStatTile 而不是自绘，保持与其他页的排版一致。
//
// **按可用宽度决定并排还是竖排**：每个统计卡里有一个固定 44px 的图标徽标
// 加上内边距，三个并排实际需要约 480px。窗口更窄时如果强行并排，
// 标签会被压成一个字（「累计答题」→「累…」），看起来像坏了。
// 宁可竖排也不截断——数字本身是重点，指标名不能省。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';

class StatGrid extends StatelessWidget {
  const StatGrid({super.key, required this.dashboard});

  static const double _minWidthForRow = 480;

  final PracticeDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      DuoStatTile(
        label: '累计答题',
        value: '${dashboard.totalAnswers}',
        icon: Icons.task_alt,
      ),
      DuoStatTile(
        label: '正确率',
        value: Formatters.percent(dashboard.accuracy),
        icon: Icons.percent,
      ),
      DuoStatTile(
        label: '错题',
        value: '${dashboard.wrongCount}',
        icon: Icons.error_outline,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _minWidthForRow) {
          return Column(
            children: [
              for (final tile in tiles) ...[
                tile,
                if (tile != tiles.last) const SizedBox(height: AppMetrics.gapSm),
              ],
            ],
          );
        }
        return Row(
          children: [
            for (final tile in tiles) ...[
              Expanded(child: tile),
              if (tile != tiles.last) const SizedBox(width: AppMetrics.gapMd),
            ],
          ],
        );
      },
    );
  }
}
