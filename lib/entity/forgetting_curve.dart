// 遗忘曲线的一个数据点：**距上次练同一道题 N 天之后，答对率是多少**。
//
// 服务端（迁移 0067）把每一次作答按「距上次练同一道题的间隔天数」分桶，
// 统计该桶的答对率。间隔越长答对率越低 —— 这条下降的线就是学生**自己**的
// 遗忘保持率，不是理论值。
//
// 分桶是**固定档**（0/1/2/3/5/7/14/30 天），由服务端决定；客户端不要自己再分，
// 否则两端口径会漂移。空桶不会出现（没人练到那个间隔就没有那一行）。
//
// 第一次练某道题没有"上一次"，天然不计入曲线 —— 所以 [attempts] 之和
// **小于**总答题数，这是对的，不是丢数据。

import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgetting_curve.freezed.dart';
part 'forgetting_curve.g.dart';

@freezed
abstract class ForgettingBucket with _$ForgettingBucket {
  const factory ForgettingBucket({
    /// 该桶的代表间隔天数（x 轴位置）。服务端给的就是档位本身，不是区间中点。
    @Default(0) int days,

    /// 落在这个桶里的作答次数（分母）。
    @Default(0) int attempts,

    /// 其中答对的次数（分子）。
    @Default(0) int correct,
  }) = _ForgettingBucket;

  factory ForgettingBucket.fromJson(Map<String, dynamic> json) =>
      _$ForgettingBucketFromJson(json);
}

extension ForgettingBucketX on ForgettingBucket {
  /// 该桶的答对率。**attempts 为 0 时返回 0**——调用方要先判 attempts，
  /// 别把这个 0 当成"全错"（与 NodeAccuracy.accuracy 同一条规矩）。
  double get accuracy => attempts == 0 ? 0 : correct / attempts;

  /// 样本够不够画出可信的点。
  ///
  /// 1~2 次的桶画出来是一条抖得没法看的折线，还会让人以为"我 14 天后就忘光了"
  /// —— 其实那天他只是碰巧答错了一道。少于 3 次的一律不画。
  bool get isReliable => attempts >= 3;
}
