// 入场动效：淡入 + 从下方轻轻滑上来。
//
// 用途：列表项、卡片、整块内容**第一次出现**时，别硬邦邦地"啪"一下出现。
// 同一屏里多项时按顺序错开（[order]），看过去是一串依次落位，而不是一起闪出来。
//
// 不负责：切题、翻页那种"换内容"的过渡（那用 AnimatedSwitcher，见练习/考试的答题区），
// 也不负责循环类的漂浮（见 FloatingArt）。
//
// 为什么延迟用 Interval 而不是 Future.delayed：**一次 ticker 都不多开**。
// 延时与动画合成在同一条时间线上（controller 的总时长 = 延迟 + 动画），
// 因此天然对齐、可被 pumpAndSettle 收尾，也不会在页面 dispose 之后还在跑。
//
// 时长的上限是刻意的（见 AppMotion.staggerFor 的 maxStagger）：越往后的项越接近
// 立即出现，长列表不会变成"等 30 项依次入场"。**这不是可选项**——本仓不做
// "减弱动效"开关，动画一律播。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';

/// 长列表的行入场：**只有首屏那几行播**（[AppMotion.entranceRows]），更靠后的直接给原样。
///
/// 列表行滚出屏幕会被回收、滚回来时重建——逐行播就是每滚回来一次重播一次；
/// 而屏幕外的行本来也谈不上"入场"，它是被用户滚出来的。所以长列表一律走这个函数。
Widget rowEntrance(int index, Widget child) =>
    index < AppMotion.entranceRows ? FadeSlideIn(order: index, child: child) : child;

class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.order = 0,
    this.offset = 12,
    this.duration,
    this.delay,
  });

  final Widget child;

  /// 同一屏里的顺序（0 起）：第 n 项延后 AppMotion.staggerFor(n)。
  /// 超出 AppMotion.maxStagger 之后不再累加（封顶 240ms）。
  final int order;

  /// 入场时的位移（设计稿像素，正值 = 从下方滑入）。
  final double offset;

  /// 动画时长；默认 AppMotion.medium。二者都给就等于绕过 [order] 自己定节奏。
  final Duration? duration;
  final Duration? delay;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final Duration _delay = widget.delay ?? AppMotion.staggerFor(widget.order);
  late final Duration _duration = widget.duration ?? AppMotion.medium;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _delay + _duration,
  )..forward();

  /// 曲线只作用在动画区段上：延迟那一段保持在起点（淡入 0、位移满格）。
  late final Animation<double> _progress = CurvedAnimation(
    parent: _controller,
    curve: Interval(
      _delay.inMicroseconds / _controller.duration!.inMicroseconds,
      1,
      curve: AppMotion.standard,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _progress,
      // child 传进去：每帧只重建 Transform 这一层，内容不跟着重建
      child: AnimatedBuilder(
        animation: _progress,
        child: widget.child,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, widget.offset.r * (1 - _progress.value)),
          child: child,
        ),
      ),
    );
  }
}
