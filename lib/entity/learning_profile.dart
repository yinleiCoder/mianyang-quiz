// 学习画像（0128 student_learning_profile）。
//
// 服务端只回六轴与聚合计数；persona/summary 由 utils/profile_persona.dart 拼装
// （与网页端 lib/profile-persona.js 逐条镜像）。
// 纯 Dart，无 Flutter 依赖，可独立单测。

class LearningProfile {
  const LearningProfile({
    required this.student,
    required this.windowDays,
    required this.axes,
    required this.caveats,
    this.generatedAt,
  });

  final LearningProfileStudent student;
  final int windowDays;
  final List<LearningProfileAxis> axes;
  final List<String> caveats;
  final String? generatedAt;

  factory LearningProfile.fromJson(Map<String, dynamic> json) {
    return LearningProfile(
      student: LearningProfileStudent.fromJson(
        (json['student'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
      windowDays: _toInt(json['window_days'], 90),
      axes: (json['axes'] as List? ?? const [])
          .map(
            (item) => LearningProfileAxis.fromJson(
              (item as Map).cast<String, dynamic>(),
            ),
          )
          .toList(),
      caveats: (json['caveats'] as List? ?? const [])
          .map((item) => '$item')
          .toList(),
      generatedAt: json['generated_at']?.toString(),
    );
  }

  LearningProfileAxis? axisOf(String key) {
    for (final axis in axes) {
      if (axis.key == key) return axis;
    }
    return null;
  }
}

class LearningProfileStudent {
  const LearningProfileStudent({
    required this.name,
    this.className,
    this.majorName,
  });

  final String name;
  final String? className;
  final String? majorName;

  factory LearningProfileStudent.fromJson(Map<String, dynamic> json) {
    return LearningProfileStudent(
      name: '${json['name'] ?? ''}',
      className: _textOrNull(json['class_name']),
      majorName: _textOrNull(json['major_name']),
    );
  }
}

class LearningProfileAxis {
  const LearningProfileAxis({
    required this.key,
    required this.label,
    this.score,
    required this.raw,
    required this.sample,
    required this.sufficient,
    required this.hint,
  });

  final String key;
  final String label;
  final double? score;
  final Map<String, dynamic> raw;
  final int sample;
  final bool sufficient;
  final String hint;

  factory LearningProfileAxis.fromJson(Map<String, dynamic> json) {
    final score = _toDouble(json['score']);
    return LearningProfileAxis(
      key: '${json['key'] ?? ''}',
      label: '${json['label'] ?? ''}',
      score: score,
      raw: (json['raw'] as Map?)?.cast<String, dynamic>() ?? const {},
      sample: _toInt(json['sample'], 0),
      sufficient: json['sufficient'] == true && score != null,
      hint: '${json['hint'] ?? ''}',
    );
  }
}

double? _toDouble(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse('$value');
}

int _toInt(Object? value, int fallback) {
  if (value is num) return value.toInt();
  return int.tryParse('$value') ?? fallback;
}

String? _textOrNull(Object? value) {
  final text = '${value ?? ''}'.trim();
  return text.isEmpty ? null : text;
}
