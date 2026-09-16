// 难度标签：把 smallint 难度（1/2/3）映射成 DuoChip 的语气与文案。
//
// **放在 ui/core/ 而不是某个 feature 里**：题库列表、错题本、收藏、复盘卡片
// 四处都显示它。散在各 feature 里的结果已经发生过一次——题库列表那份把「中」
// 映射成 warning（橙），其它三处映射成 neutral（灰），同一道题在两个页面颜色不同。
//
// 语气以 core/constants/difficulty_meta.dart 的说明为准：**易=绿、中=橙、难=红**。
//
// 不负责：筛选交互（可点的是 ChoiceChip）；难度的中文名在 difficulty_meta.dart。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/difficulty_meta.dart';
import 'package:mianyang_quiz/ui/core/design/duo_chip.dart';

class DifficultyChip extends StatelessWidget {
  const DifficultyChip({
    super.key,
    required this.difficulty,
    this.dense = true,
  });

  /// 难度值，null（服务端没给）时不渲染任何东西。
  final int? difficulty;

  final bool dense;

  @override
  Widget build(BuildContext context) {
    final value = difficulty;
    if (value == null) return const SizedBox.shrink();

    final tone = switch (difficultyTone(value)) {
      DifficultyTone.easy => DuoChipTone.success,
      DifficultyTone.medium => DuoChipTone.warning,
      DifficultyTone.hard => DuoChipTone.danger,
    };

    return DuoChip(
      // 带上前缀：孤零零一个「中」字看不出是难度还是别的
      label: '难度 ${difficultyLabel(value)}',
      tone: tone,
      dense: dense,
    );
  }
}
