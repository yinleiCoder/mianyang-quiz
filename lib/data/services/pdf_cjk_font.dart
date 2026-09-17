// 给 PDF 用的中文字体：**从系统字体文件读，不联网**。
//
// pdf 包内置的 Helvetica 不含汉字，不显式加载就会印出一片空白（不报错）。
// 原先是 PdfGoogleFonts.notoSansSCRegular()——运行时从 fonts.gstatic.com 拉，
// 而国内网络到不了那里，**且那个调用没有超时**：点「打印」既不报错也不出对话框，
// 师生的感受就是"按钮没反应"（2026-09-17 反馈的就是这个）。
// 改成读系统字体之后，这条路径彻底不依赖网络。
//
// 从 question_pdf_service.dart 拆出来：那边管"题目怎么排成 A4"，
// 这边只管"汉字从哪来"。单文件行数上限是硬约束（tool/check_architecture.dart）。

import 'dart:io';
import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;

abstract final class PdfCjkFont {
  /// 中文字体的候选路径，按"大概率存在、且 pdf 包吃得下"排序。
  ///
  /// **优先 TTF**：msyh / simsun 那些 .ttc 是字体集合，pdf 包的解析器不一定认，
  /// 所以排在后面，解析失败会自动跳到下一个。黑体 simhei.ttf 在中文 Windows 上几乎必有。
  /// 后两条是给手机端留的（Android 的 Noto CJK 也是 .ttc，认不认同样听天由命）。
  ///
  /// 路径写正斜杠：Windows 的 Dart IO 一样认，还省得跟转义打架。
  static const candidates = <String>[
    'C:/Windows/Fonts/simhei.ttf',
    'C:/Windows/Fonts/simkai.ttf',
    'C:/Windows/Fonts/simfang.ttf',
    'C:/Windows/Fonts/Deng.ttf',
    'C:/Windows/Fonts/NotoSansSC-VF.ttf',
    'C:/Windows/Fonts/msyh.ttc',
    'C:/Windows/Fonts/msyhbd.ttc',
    'C:/Windows/Fonts/simsun.ttc',
    '/system/fonts/NotoSansCJK-Regular.ttc',
    '/system/fonts/NotoSansCJKsc-Regular.otf',
    '/System/Library/Fonts/PingFang.ttc',
  ];

  static pw.Font? _cached;

  /// 读一次，之后复用（字体有几 MB，每次打印都重新解析没必要）。
  ///
  /// 一个都找不到时**抛错**，由调用方转成给用户看的提示——
  /// 不要退回联网下载：那条路在国内会挂住，正是这次要修的病根。
  static Future<pw.Font> load() async => _cached ??= await _readFirstAvailable();

  static Future<pw.Font> _readFirstAvailable() async {
    for (final path in candidates) {
      try {
        final file = File(path);
        if (!await file.exists()) continue;
        final bytes = await file.readAsBytes();
        return pw.Font.ttf(ByteData.sublistView(bytes));
      } catch (_) {
        // 这个候选读不动或解析不了（例如 .ttc），换下一个
        continue;
      }
    }
    throw StateError('没有找到可用的中文字体');
  }
}
