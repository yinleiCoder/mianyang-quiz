// 难度标签。错题本与收藏两处的行都显示它，所以单独成件——两处各写一遍 switch
// 迟早会出现「一边易=绿、一边易=蓝」。
//
// 职责：把 smallint 难度（1/2/3）映射成 DuoChip 的语气与文案。
// 不负责：筛选交互（可点的是 ChoiceChip）；难度的中文名在 core/constants/difficulty_meta.dart。

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

    // 语气取自主题语义色：易=成功（SemanticColors.success）、难=危险（error）、中=中性。
    final tone = switch (difficultyTone(value)) {
      DifficultyTone.easy => DuoChipTone.success,
      DifficultyTone.hard => DuoChipTone.danger,
      DifficultyTone.medium => DuoChipTone.neutral,
    };

    return DuoChip(
      label: '难度 ${difficultyLabel(value)}',
      tone: tone,
      dense: dense,
    );
  }
}
