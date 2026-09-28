// 意见反馈元数据。对应 feedback 表与 submit_feedback RPC（网页端仓库 0033 迁移）。
//
// category 与 platform 的取值必须与迁移里的 check 约束逐字一致，改一处要改两处：
//   bug/feature/usage/other；web/android/windows/ios/other。
// platform 由客户端按运行平台上报（网页端恒为 web）；client_version 只有客户端会填，
// 网页端永远是最新部署，不上报。

import 'package:flutter/foundation.dart';

/// 反馈类型。wire 进库，label 给用户看。
enum FeedbackCategory {
  bug('bug', '问题反馈'),
  feature('feature', '功能建议'),
  usage('usage', '使用咨询'),
  other('other', '其他');

  const FeedbackCategory(this.wire, this.label);

  final String wire;
  final String label;
}

/// 当前运行平台，取值见 feedback.platform 的 check 约束。
/// 桌面与移动之外的平台（macOS/Linux 浏览器等）落 other，不猜。
String feedbackPlatform() => switch (defaultTargetPlatform) {
  TargetPlatform.android => 'android',
  TargetPlatform.iOS => 'ios',
  TargetPlatform.windows => 'windows',
  _ => 'other',
};
