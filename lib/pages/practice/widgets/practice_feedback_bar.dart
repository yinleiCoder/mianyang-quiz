// 即时模式的底部反馈条：判定之后从底部升起的作答结果。
//
// 整条底色随对错变化（M3 的成功/错误容器色），左边一个大图标，
// 中间一句话 + 正误说明，右边一个主按钮。
//
// **这条本身不带计时器**：答对后的自动跳题由舞台的 AutoAdvanceController 负责
// （默认开，可在开始练习页关掉），答错永远要学生自己点「继续」。
// 反馈条只做展示与回调——计时路径一旦放进组件，用户正在核对解析时页面会被悄悄抢走，
// 而界面上没有任何地方能解释"为什么自己跳了"。
//
// 组件本身仍需要 State：入场动画要两帧（见 _slide）。
//
// 只做展示与回调，不判分、不提交——判定结果由 PracticeRunner 给出。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';

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
  /// 入场：第一帧先落在下方 20%，下一帧回到 0，AnimatedSlide 于是自己升上来。
  ///
  /// 为什么绕这一下：AnimatedSlide 是**隐式**动画，只在"值变化"时播——
  /// 直接写 `offset: Offset.zero` 一次都不动（原样就是这样，白等一场）。
  /// 判定结果出来时这条从底部升起，正好承接"往上看了一眼题、结果在下面出来了"的视线。
  double _slide = 0.2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _slide = 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final semantic = context.semantic;
    // M3 没有"成功"角色，用主题的 SemanticColors；错误用 error。
    final background = widget.correct ? semantic.successContainer : scheme.errorContainer;
    final foreground = widget.correct ? semantic.onSuccessContainer : scheme.onErrorContainer;

    return AnimatedSlide(
      duration: AppMotion.medium,
      curve: AppMotion.standard,
      offset: Offset(0, _slide),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: background,
          // 顶上两角：M3 给底部弹层的是 extra large（28），但用户看过实机后觉得太空，
          // 收到 large（16）——比卡片（12）圆一点、又不至于像一块软糖。
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppMetrics.radiusLarge.r),
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
