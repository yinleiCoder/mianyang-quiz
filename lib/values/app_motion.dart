// 动效常量：时长与曲线。全站的"动多快、怎么动"只在这里定义。
//
// 为什么要有这个文件：时长与曲线原先散落在各组件里（120 / 150 / 180 / 220ms 各写各的），
// 同一个"切一块内容"的动作在两个页面上快慢不同，一屏里就会显得杂乱。收敛到一处之后，
// 调"整体手感"是改这里，而不是全局搜索毫秒数。
//
// 节奏是按"这是学习工具、不是游戏"定的：最快的 120ms（按下、图标切换）到最慢的
// 320ms（整块插画入场）。**没有一档会拖过 350ms**——刷题时用户的手是连续的，
// 动画每慢 100ms，一整场练习就是几十次可感知的等待。
//
// 注意：**不做"减弱动效"的开关**。本项目明确不按 MediaQuery.disableAnimations
// 关掉动画（用户的取舍）：动效是界面的一部分，不是可选项。

import 'package:material_ui/material_ui.dart';

abstract final class AppMotion {
  /// 微交互：图标切换、按下/悬停反馈、状态底色过渡。
  static const Duration fast = Duration(milliseconds: 120);

  /// 标准切换：列表项入场、卡片内容替换、反馈条升起。
  static const Duration medium = Duration(milliseconds: 220);

  /// 大块内容入场：整段插画、空状态、结果卡。
  static const Duration slow = Duration(milliseconds: 320);

  /// 循环类动画的周期（吉祥物漂浮/呼吸）：慢到不抢注意力，又足以看出"它是活的"。
  static const Duration loop = Duration(milliseconds: 2600);

  /// 相邻列表项之间的错开间隔。**上限见 [maxStagger]**：长长的列表不是
  /// 让第 30 项等 1.2 秒，而是让前几项错开、后面的立刻跟上。
  static const Duration stagger = Duration(milliseconds: 40);

  /// 错开的档数上限（配合 [stagger]：最多 240ms）。
  static const int maxStagger = 6;

  /// 入场：起步快、收尾稳。绝大多数"出现"都用它。
  static const Curve standard = Curves.easeOutCubic;

  /// 退场：比入场略快，用户的注意力已经跟着新内容走了。
  static const Curve exit = Curves.easeInCubic;

  /// 循环往复（漂浮、呼吸）：两端都要平顺，否则会看到"顿一下"。
  static const Curve loopCurve = Curves.easeInOutSine;

  /// 第 [order] 项（0 起）的入场延迟，已按 [maxStagger] 截断。
  static Duration staggerFor(int order) {
    final capped = order.clamp(0, maxStagger);
    return stagger * capped;
  }

  /// 长列表里"值得播入场"的行数上限：**只有首屏那几行**。
  ///
  /// 为什么要有这个上限，而不是给每一行都播：列表行在滚出屏幕后会被回收，
  /// 滚回来时重建 —— 那意味着每滚回来一次就重播一次入场。配合 [staggerFor]
  /// 封顶后的 240ms，一行滚进视口会先空白四分之一秒再淡入，快速滚动时整屏
  /// 都像慢半拍。而屏幕外的行本来也谈不上"入场"：它是被用户滚出来的。
  ///
  /// 首屏那几行（首次加载 / 换一批数据后）照常依次落位；更靠后的行直接出现。
  static const int entranceRows = 6;
}
