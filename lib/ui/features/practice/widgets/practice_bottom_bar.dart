// 练习页底部操作区：按当前模式与判定状态决定显示哪一条。
//
// 单独成文件而不是写在舞台里：这四种形态（检查 / 反馈 / 翻页 / 交卷）的分支
// 与"什么时候自动判题"是两件事，混在一起会让舞台既管规则又管排版。
//
// 本组件只做**选择与排版**，判定状态与回调全部由舞台传入。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/state/favorite_store.dart';
import 'package:mianyang_quiz/state/practice_mode.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/feedback/favorite_toggle.dart';
import 'package:mianyang_quiz/ui/features/practice/state/practice_runner.dart';
import 'package:mianyang_quiz/ui/features/practice/widgets/batch_nav_bar.dart';
import 'package:mianyang_quiz/ui/features/practice/widgets/practice_feedback_bar.dart';
import 'package:provider/provider.dart';

class PracticeBottomBar extends StatelessWidget {
  const PracticeBottomBar({
    super.key,
    required this.runner,
    required this.checking,
    required this.onCheck,
    required this.onContinue,
    required this.onFinish,
  });

  final PracticeRunner runner;

  /// 正在提交（即时模式的"检查"之后）。
  final bool checking;

  final VoidCallback onCheck;
  final VoidCallback onContinue;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    if (runner.mode == PracticeMode.batch) {
      return BatchNavBar(runner: runner, onFinish: onFinish);
    }

    // 即时模式：未判定给「检查」，已判定给反馈条
    final runtime = runner.current;
    if (!runtime.isGraded) {
      return _CheckBar(
        enabled: runtime.isAnswered,
        busy: checking || runtime.submitting,
        onCheck: onCheck,
      );
    }
    return PracticeFeedbackBar(
      correct: runtime.verdict == true,
      isLast: runner.isLast,
      // 收藏本题。FavoriteStore 的注释把「练习反馈条」列为收藏按钮的四个入口之一，
      // 但这里一直没接线——组件里的心形按钮存在、tooltip 也有，永远不显示。
      // 答错时尤其需要：刚做完就想把这题收起来，不必先退出练习去题库找。
      isFavorite: context.select<FavoriteStore, bool>(
        (store) => store.isFavorite(runtime.item.questionId),
      ),
      onToggleFavorite: () => toggleFavoriteWithToast(
        context,
        questionId: runtime.item.questionId,
        toggle: context.read<FavoriteStore>().toggle,
      ),
      onContinue: onContinue,
    );
  }
}

/// 未判定时的底部条：只有一颗「检查」。
class _CheckBar extends StatelessWidget {
  const _CheckBar({
    required this.enabled,
    required this.busy,
    required this.onCheck,
  });

  final bool enabled;
  final bool busy;
  final VoidCallback onCheck;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppMetrics.pagePadding),
      child: DuoButton(
        label: '检查',
        icon: Icons.check,
        loading: busy,
        // 未作答时禁用：让"还不能检查"这件事从按钮状态上直接看出来
        onPressed: enabled && !busy ? onCheck : null,
      ),
    );
  }
}
