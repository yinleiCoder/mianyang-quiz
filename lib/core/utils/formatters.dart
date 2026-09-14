// 展示格式化：时长、百分比、日期、题量等。
//
// 职责：把原始数值/时间转成界面上的中文短文案，口径全站统一。
// 不负责：任何业务计算（如正确率的分母选择——那是数据层的事）。
//
// 全部是纯函数，无 Flutter 依赖，可独立单测。

abstract final class Formatters {
  /// 毫秒 → 「1 分 23 秒」/「45 秒」/「1 小时 2 分」。
  /// 练习时长与统计里的 duration_ms 都走这里。
  static String duration(int? milliseconds) {
    if (milliseconds == null || milliseconds <= 0) return '0 秒';
    final totalSeconds = milliseconds ~/ 1000;
    if (totalSeconds < 60) return '$totalSeconds 秒';

    final minutes = totalSeconds ~/ 60;
    if (minutes < 60) {
      final seconds = totalSeconds % 60;
      return seconds == 0 ? '$minutes 分' : '$minutes 分 $seconds 秒';
    }

    final hours = minutes ~/ 60;
    final restMinutes = minutes % 60;
    return restMinutes == 0 ? '$hours 小时' : '$hours 小时 $restMinutes 分';
  }

  /// 0~1 的小数 → 「85%」。null 视为 0。
  static String percent(num? ratio, {int fractionDigits = 0}) {
    final value = (ratio ?? 0) * 100;
    return '${value.toStringAsFixed(fractionDigits)}%';
  }

  /// 已答/总数 → 「7/20」。
  static String progress(int answered, int total) => '$answered/$total';

  /// 「2026-09-12」。
  static String date(DateTime? time) {
    if (time == null) return '';
    final local = time.toLocal();
    return '${local.year}-${_two(local.month)}-${_two(local.day)}';
  }

  /// 「09-12 14:30」——列表里够用且不啰嗦。
  static String dateTime(DateTime? time) {
    if (time == null) return '';
    final local = time.toLocal();
    return '${_two(local.month)}-${_two(local.day)} ${_two(local.hour)}:${_two(local.minute)}';
  }

  /// 相对时间：「刚刚」「3 分钟前」「昨天」「3 天前」，超过 7 天回落到日期。
  static String relative(DateTime? time) {
    if (time == null) return '';
    final diff = DateTime.now().difference(time.toLocal());
    if (diff.isNegative) return date(time);
    if (diff.inMinutes < 1) return '刚刚';
    if (diff.inMinutes < 60) return '${diff.inMinutes} 分钟前';
    if (diff.inHours < 24) return '${diff.inHours} 小时前';
    if (diff.inDays == 1) return '昨天';
    if (diff.inDays < 7) return '${diff.inDays} 天前';
    return date(time);
  }

  /// 入学年份 → 「24 级」。数据库存的是 2024 这样的完整年份。
  static String enrollmentYear(int? year) {
    if (year == null) return '';
    final short = year % 100;
    return '${_two(short)} 级';
  }

  /// 文件大小 → 「1.2 MB」。
  static String fileSize(int? bytes) {
    if (bytes == null || bytes <= 0) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB'];
    var size = bytes.toDouble();
    var unit = 0;
    while (size >= 1024 && unit < units.length - 1) {
      size /= 1024;
      unit++;
    }
    final text = size >= 100 || unit == 0
        ? size.toStringAsFixed(0)
        : size.toStringAsFixed(1);
    return '$text ${units[unit]}';
  }

  static String _two(int value) => value.toString().padLeft(2, '0');
}
