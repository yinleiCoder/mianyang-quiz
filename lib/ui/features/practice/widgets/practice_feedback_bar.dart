// 即时模式的底部反馈条：判定之后从底部升起的作答结果。
//
// 学多邻国：整条底色随对错变化（浅绿/浅红），左边一个大图标，
// 中间一句话 + 正误说明，右边一个主按钮。
//
// **答对后自动跳下一题，答错必须自己点「继续」**（用户 2026-09-24）：
// 答对的人基本不用看解析，直接刷下一题更顺；答错的人要看解析，自动跳会把它抢走。
// 当年是一刀切地取消自动跳（连答错也跳，学生抱怨"看不到解析"），现在只保留答对这条。
//
// 计时器挂在这个组件上、不挂在舞台上：它只在"已判定"时挂载，切题那一刻就被换掉，
// dispose 里取消即可。舞台（practice_stage.dart）已经 180/200 行，再塞计时器会撞
// 架构守卫的 200 行上限。
//
// 只做展示与回调，不判分、不提交——判定结果由 PracticeRunner 给出。

import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';

class PracticeFeedbackBar extends StatefulWidget {
  const PracticeFeedbackBar({
    super.key,
    required this.correct,
    required this.onContinue,
    this.summary,
    this.isLast = false,
    this.busy = false,
    this.onToggleFavorite,
    this.isFavorite = false,
  });

  final bool correct;

  /// 主按钮在途（末题就是交卷）。转圈并挡重复点击，见 PracticeStage._finishing。
  final bool busy;

  /// 一句话说明（如「正确答案：B」或主观题的提示）。可为空。
  final String? summary;

  final bool isLast;

  final VoidCallback onContinue;
  final VoidCallback? onToggleFavorite;
  final bool isFavorite;

  @override
  State<PracticeFeedbackBar> createState() => _PracticeFeedbackBarState();
}

class _PracticeFeedbackBarState extends State<PracticeFeedbackBar> {
  /// 答对后停留多久再跳。
  ///
  /// 2 秒 = 看清「答对了」+ 瞄一眼解析开头。比当年那版（1.5 秒）长一点，
  /// 因为解析现在是判完就出现的，抢走的代价比以前大。
  static const Duration _dwell = Duration(seconds: 2);

  Timer? _auto;

  @override
  void initState() {
    super.initState();
    _schedule();
  }

  @override
  void didUpdateWidget(covariant PracticeFeedbackBar old) {
    super.didUpdateWidget(old);
    // 判定结果可能后到（主观题要学生先自评），条件变了就重排一次
    if (old.correct != widget.correct || old.isLast != widget.isLast) {
      _auto?.cancel();
      _schedule();
    }
  }

  void _schedule() {
    // 答错不跳（要看解析）；末题不跳（「完成」就是交卷，不能替学生按下去）
    if (!widget.correct || widget.isLast) return;
    _auto = Timer(_dwell, () {
      if (mounted) widget.onContinue();
    });
  }

  @override
  void dispose() {
    _auto?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final semantic = context.semantic;
    // M3 没有"成功"角色，用主题的 SemanticColors；错误用 error。
    final background = widget.correct ? semantic.successContainer : scheme.errorContainer;
    final foreground = widget.correct ? semantic.onSuccessContainer : scheme.onErrorContainer;
    final autoAdvancing = widget.correct && !widget.isLast;

    return AnimatedSlide(
      duration: const Duration(milliseconds: 180),
      offset: Offset.zero,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppMetrics.radiusCard.r),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppMetrics.gapLg,
          AppMetrics.gapLg,
          AppMetrics.gapLg,
          AppMetrics.gapLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  widget.correct ? Icons.check_circle : Icons.cancel,
                  size: 28.r,
                  color: foreground,
                ),
                const SizedBox(width: AppMetrics.gapMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.correct ? '答对了' : '答错了',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (widget.summary != null && widget.summary!.isNotEmpty) ...[
                        SizedBox(height: 4.r),
                        Text(
                          widget.summary!,
                          style: theme.textTheme.bodyMedium?.copyWith(color: foreground),
                        ),
                      ],
                      // 说一句"马上要跳"：不说话就切页，学生会以为点错了
                      if (autoAdvancing) ...[
                        SizedBox(height: 4.r),
                        Text(
                          '2 秒后自动进入下一题',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: foreground.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.onToggleFavorite != null)
                  IconButton(
                    onPressed: widget.onToggleFavorite,
                    icon: Icon(
                      widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: foreground,
                      size: 24.r,
                    ),
                    tooltip: widget.isFavorite ? '取消收藏' : '收藏本题',
                  ),
              ],
            ),
            const SizedBox(height: AppMetrics.gapLg),
            DuoButton(
              label: widget.isLast ? '完成' : '继续',
              onPressed: widget.onContinue,
              loading: widget.busy,
              icon: widget.isLast ? Icons.flag_outlined : Icons.arrow_forward,
            ),
          ],
        ),
      ),
    );
  }
}
