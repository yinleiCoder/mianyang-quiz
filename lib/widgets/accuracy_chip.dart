// 错误率标签：把「作答次数 + 答对次数」映射成 DuoChip 的语气与文案，外带「易错」标识。
//
// **放在 widgets/ 而不是某个 feature 里**：题库列表、题目详情、练习复盘、考试成绩单
// 四处都要它 —— 与 difficulty_chip.dart 同一个理由（散在各处必然出现"同一个数
// 在两个页面颜色不同"）。
//
// 判据在 values/accuracy_meta.dart（与网页端 lib/accuracy.js 同源），这里只负责显示：
//   · 易错（错误率 ≥60% 且样本 ≥5）：danger 语气 +「易错」前缀
//   · 有数据但不算易错：neutral +「错误率」
//   · **没有作答数据（attempts ≤ 0）：什么都不渲染** —— 「0 次作答 ≠ 0%」是本仓库
//     反复强调的规矩，摆一个 0% 会被读成"大家都做对了"
//
// 错误次数（错 N 次）放在 Tooltip 里，不占列表行的宽度；需要摊开显示的地方
// （复盘卡片那种有整行余量的）自己拼文案，别把 chip 撑长。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/utils/formatters.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/widgets/duo_chip.dart';

class AccuracyChip extends StatelessWidget {
  const AccuracyChip({
    super.key,
    required this.attempts,
    required this.correct,
    this.scopeLabel,
    this.dense = true,
  });

  /// 画了多少次（卷内口径传「判过分的人数」）。
  final int attempts;

  /// 其中答对多少次。
  final int correct;

  /// 口径说明，进 tooltip。全站口径不传（默认就是全站），卷内口径传「本场考试」之类。
  final String? scopeLabel;

  final bool dense;

  @override
  Widget build(BuildContext context) {
    if (attempts <= 0) return const SizedBox.shrink();

    final easilyWrong = isEasilyWrong(attempts: attempts, correct: correct);
    final rate = 1 - correct / attempts;
    final wrong = wrongAttempts(attempts: attempts, correct: correct);
    final scope = scopeLabel ?? '全站';

    return Tooltip(
      message: '$scope $attempts 次作答，答对 $correct 次，错 $wrong 次（不含主观自评题）',
      child: DuoChip(
        label: easilyWrong
            ? '易错 ${Formatters.percent(rate)}'
            : '错误率 ${Formatters.percent(rate)}',
        tone: easilyWrong ? DuoChipTone.danger : DuoChipTone.neutral,
        dense: dense,
      ),
    );
  }
}
