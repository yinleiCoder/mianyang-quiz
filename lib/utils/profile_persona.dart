// 学习画像的 persona/summary（与网页端 lib/profile-persona.js 逐条镜像）。
//
// 规则表命中，不调用大模型；理由必须带实际数值；成长语气，禁止“学困/差生/没天赋”；
// 不推断人格/心理特征。改规则时两端的测试要同步改（互为清单）。
//
// 纯 Dart，无 Flutter 依赖，可独立单测。

import 'package:mianyang_quiz/entity/entity.dart';

class ProfilePersona {
  const ProfilePersona({
    required this.key,
    required this.label,
    required this.reason,
  });

  final String key;
  final String label;
  final String reason;
}

const _minSufficient = 5;

List<LearningProfileAxis> _sufficientAxes(List<LearningProfileAxis> axes) {
  return axes
      .where((axis) => axis.score != null && axis.sufficient)
      .toList();
}

double? _scoreOf(List<LearningProfileAxis> axes, String key) {
  for (final axis in axes) {
    if (axis.key == key) return axis.score;
  }
  return null;
}

String _fmt(double? value) => '${(value ?? 0).round()}';

bool _atLeast(double? value, double line) => value != null && value >= line;

bool _below(double? value, double line) => value != null && value < line;

ProfilePersona buildProfilePersona(List<LearningProfileAxis> axes) {
  final list = _sufficientAxes(axes);
  if (list.length < _minSufficient) {
    return ProfilePersona(
      key: 'newcomer',
      label: '新同学',
      reason: '还差 ${_minSufficient - list.length} 个维度有数据；再练几题就能生成画像',
    );
  }

  final mastery = _scoreOf(axes, 'mastery');
  final accuracy = _scoreOf(axes, 'accuracy');
  final effort = _scoreOf(axes, 'effort');
  final growth = _scoreOf(axes, 'growth');
  final breadth = _scoreOf(axes, 'breadth');
  final stability = _scoreOf(axes, 'stability');
  final scores = list.map((axis) => axis.score ?? 0).toList();
  final spread = scores.reduce((a, b) => a > b ? a : b) -
      scores.reduce((a, b) => a < b ? a : b);

  if (_atLeast(mastery, 75) &&
      _atLeast(accuracy, 75) &&
      _atLeast(stability, 70)) {
    return ProfilePersona(
      key: 'steady',
      label: '稳健型',
      reason:
          '掌握力 ${_fmt(mastery)}、准确率 ${_fmt(accuracy)}、稳定性 ${_fmt(stability)} 均在 70 以上',
    );
  }
  if (_atLeast(growth, 60) && _atLeast(effort, 70)) {
    return ProfilePersona(
      key: 'sprinter',
      label: '冲刺型',
      reason: '进步力 ${_fmt(growth)}、勤奋度 ${_fmt(effort)}，近期上升明显',
    );
  }
  if (_atLeast(breadth, 70) && _below(accuracy, 70)) {
    return ProfilePersona(
      key: 'explorer',
      label: '探索型',
      reason: '知识面 ${_fmt(breadth)} 很宽，准确率 ${_fmt(accuracy)} 还有提升空间',
    );
  }
  if (_atLeast(effort, 75) && _below(accuracy, 65)) {
    return ProfilePersona(
      key: 'diligent',
      label: '勤奋型',
      reason: '勤奋度 ${_fmt(effort)} 很高，准确率 ${_fmt(accuracy)} 暂时偏低',
    );
  }
  if (spread <= 15) {
    return ProfilePersona(
      key: 'balanced',
      label: '均衡型',
      reason: '六轴最高与最低只差 ${_fmt(spread)}，发展比较均衡',
    );
  }
  return const ProfilePersona(
    key: 'growing',
    label: '成长型',
    reason: '六轴已有数据，仍在形成稳定形状',
  );
}

String buildProfileSummary(
  List<LearningProfileAxis> axes, [
  ProfilePersona? persona,
]) {
  final list = _sufficientAxes(axes);
  if (list.isEmpty) return '再练几题，就能生成你的学习画像。';
  final sorted = [...list]..sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
  final top = sorted.first;
  final bottom = sorted.last;
  final topText = '${top.label} ${_fmt(top.score)}';
  final actualPersona = persona ?? buildProfilePersona(axes);
  if (top.key == bottom.key) {
    return '目前$topText；下一步保持练习节奏，再看看其他维度。';
  }
  final bottomText = '${bottom.label} ${_fmt(bottom.score)}';
  final advice = switch (bottom.key) {
    'effort' => '下一步先把练习频率提上来',
    'accuracy' => '下一步优先补准确率，做完先核对再提交',
    'breadth' => '下一步可以多换几个知识点练',
    'stability' => '下一步把每天的练习量稳住',
    'growth' => '下一步用近两周的正确率对比找回升点',
    _ => '下一步优先补${bottom.label}',
  };
  return '你的强项是$topText；$bottomText 是最该补的。$advice。${actualPersona.reason}。';
}
