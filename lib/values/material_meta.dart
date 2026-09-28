// 复习资料的类型元数据：线格式字符串 ↔ 枚举 ↔ 中文名 ↔ 图标 ↔ 打开方式。
//
// 线格式（wire）必须与 0070 的 review_materials_kind_check 约束逐字一致：
//   pdf / word / sheet / slide / image / audio / video / other
//
// 不知道的取值一律落到 other，**不要抛异常**：将来后端加了新分类时，
// 旧客户端应当能显示成"资料"而不是整页崩溃（与 qtype_meta 同一条取舍）。
//
// 「能不能在应用内直接看」这条口径**两端必须一致**：服务端那份在网页端
// lib/materials.js 的 INLINE_KINDS，改了这里要同步改那边。

import 'package:material_ui/material_ui.dart';

enum MaterialKind {
  pdf('pdf', 'PDF', Icons.picture_as_pdf_outlined),
  word('word', 'Word', Icons.description_outlined),
  sheet('sheet', 'Excel', Icons.table_chart_outlined),
  slide('slide', 'PPT', Icons.slideshow_outlined),
  image('image', '图片', Icons.image_outlined),
  audio('audio', '音频', Icons.headphones_outlined),
  video('video', '视频', Icons.movie_outlined),
  other('other', '资料', Icons.attach_file);

  const MaterialKind(this.wire, this.label, this.icon);

  /// 与数据库 review_materials.kind 一致的字符串。
  final String wire;
  final String label;
  final IconData icon;

  /// 能不能在应用内直接渲染。
  ///
  /// **只有 PDF 与图片可以**：Android 的系统 WebView 没有内置 PDF 阅读器，
  /// 所以 PDF 走 pdfrx（PDFium）；Office 与音视频在 Flutter 上没有可靠的跨端渲染方案
  ///（Windows 没有官方 video_player/just_audio，Office 更是完全没有），
  /// 一律交给系统程序打开——这与题库里音视频/附件的既有口径一致。
  bool get opensInline => this == pdf || this == image;
}

/// 线格式字符串 → 枚举。认不出的一律 other。
MaterialKind materialKindFrom(String? wire) {
  for (final kind in MaterialKind.values) {
    if (kind.wire == wire) return kind;
  }
  return MaterialKind.other;
}
