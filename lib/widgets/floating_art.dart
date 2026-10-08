// 会动的插画：把一张静态 SVG 挂进来，然后让它在 Flutter 侧慢慢地漂浮/呼吸。
//
// **为什么不是"播放 SVG 动画"**：flutter_svg 不执行 SVG 内部的 SMIL 或 CSS 动画
// （它只把矢量图形画出来）。所以"会动的 SVG"在本项目里只有一条路：SVG 出图形，
// Flutter 出动作 —— 本组件就是那个动作，资源和代码各管一半。
//
// 动作有两段，都在**一条时间线**上（入场在前、漂浮在后，共用一个 controller）：
//   1. 入场：淡入 + 从 0.92 放到 1；
//   2. 漂浮：三个来回的上下浮 + 轻微摆头 + 呼吸缩放，**然后停住**。
//
// 为什么合成一条时间线、而不是"入场播完再启动漂浮"：后者要等前一个 TickerFuture
// 回调再去 forward 第二个 controller，起算时刻是"下一帧"，看着像两段动画之间卡了一下，
// 而且测试里很难踩准采样点（实测踩在正弦过零点上会得到"它没动"的假象）。
//
// 第 2 段刻意**不是无限循环**，有两个理由：
//   · 无限动画会让 pumpAndSettle 永远等不到静止（本仓的加载转圈就是这个毛病，
//     集成测试里必须改用 waitFor）——一个装饰插图不该把测试逼成那样；
//   · 停住之后画面安静，读题时不会被一块永远在动的东西抢注意力。
// 这是"播三次然后安静"，不是"关掉动画"：它每次都照常播，不做任何减弱动效的判断。
//
// 资源取色写在 SVG 里（见 assets/art/mascot_study.svg）：这是矢量资源，读不到
// ColorScheme，与 assets/mianyang.svg 同例。**组件里不许出现颜色**，只摆位置与大小。

import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';

/// 吉祥物「小书」（见 assets/art/mascot_study.svg）。
///
/// 路径收在这里而不是各页面写字符串：SVG 加载失败是**静默**的（那块地方什么都没有，
/// 不报错），名字写错只能靠一个集中的常量来避免。
const String kMascotStudy = 'assets/art/mascot_study.svg';

class FloatingArt extends StatefulWidget {
  const FloatingArt({
    super.key,
    required this.asset,
    this.size = 96,
    this.semanticLabel,
  });

  /// SVG 资源路径（须已在 pubspec 的 assets 里声明）。
  final String asset;

  /// 边长（正方形，设计稿像素）。
  final double size;

  /// 无障碍标签。**纯装饰时留 null**：这时它不进语义树，读屏用户不会被插图打断。
  final String? semanticLabel;

  @override
  State<FloatingArt> createState() => _FloatingArtState();
}

class _FloatingArtState extends State<FloatingArt>
    with SingleTickerProviderStateMixin {
  /// 入场时长；剩余时间归漂浮。
  static const Duration _enter = AppMotion.slow;

  /// 漂浮几个来回。三次之后停下——见文件头。
  static const int _cycles = 3;

  static final Duration _total = _enter + AppMotion.loop * _cycles;
  static final double _enterShare = _enter.inMilliseconds / _total.inMilliseconds;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _total,
  )..forward();

  /// 入场那一小段：淡入与放大都跟它走。
  late final Animation<double> _entered = CurvedAnimation(
    parent: _controller,
    curve: Interval(0, _enterShare, curve: AppMotion.standard),
  );

  /// 漂浮的进度（0~1，入场结束后才开始走）。
  double get _floatProgress =>
      ((_controller.value - _enterShare) / (1 - _enterShare)).clamp(0.0, 1.0);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _entered,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // 正弦：起止都落在 0（不会"停在半空"），中间三次来回
          final wave = math.sin(_floatProgress * _cycles * 2 * math.pi);
          return Transform.translate(
            offset: Offset(0, -3.5.r * wave),
            child: Transform.rotate(
              angle: 0.02 * wave,
              child: Transform.scale(
                scale: 0.92 + 0.08 * _entered.value,
                child: child,
              ),
            ),
          );
        },
        child: SvgPicture.asset(
          widget.asset,
          width: widget.size.r,
          height: widget.size.r,
          fit: BoxFit.contain,
          semanticsLabel: widget.semanticLabel,
        ),
      ),
    );
  }
}
