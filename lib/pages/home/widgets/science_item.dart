// 首页「科学抽题原理」卡片的数据项。
//
// 单独一个文件是为了过 tool/check_architecture.dart 的「界面层一个文件一个 public class」：
// 卡片是 science_card.dart，这个只是它吃的数据。

import 'package:material_ui/material_ui.dart';

class ScienceItem {
  const ScienceItem(this.icon, this.title, this.body, this.scene, {this.linkLabel});

  final IconData icon;
  final String title;
  final String body;

  /// 网页端动画的章节 id：mix / fsrs / bkt / curve。
  /// 与 lib/showcase-scheduler.js 的 FLUTTER_SCENES 同源，改一处要改另一处。
  final String scene;

  /// 点开后的无障碍提示语（默认「查看动画演示」）。
  final String? linkLabel;
}
