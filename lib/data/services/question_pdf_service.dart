// 单题打印：把一道题排成 A4，交给系统打印对话框（在那儿可以「另存为 PDF」）。
//
// 为什么是 pdf + printing 这两个包：Flutter 没有内置的打印/PDF 能力，这是事实标准组合，
// 且 printing 覆盖本客户端的两个目标平台（Android / Windows）。
//
// **中文字体**：pdf 包内置的 Helvetica 不含汉字，不显式加载就会印出一片空白（不报错）。
// 这里用 PdfGoogleFonts 运行时拉 Noto Sans SC（几 MB，按会话缓存一次）——
// 已实测本项目网络可达 fonts.gstatic.com；拉不到会抛错，由调用方转成「需要联网」的提示。
//
// **v1 只排文字**：媒体块（插图/附件）不进 PDF。含图或有表格的题，请用网页端的打印页
//（/print/question/<id>，浏览器排版什么都支持）。

import 'dart:typed_data';

import 'package:mianyang_quiz/core/constants/difficulty_meta.dart';
import 'package:mianyang_quiz/data/models/bank/question_brief.dart';
import 'package:mianyang_quiz/data/models/content/block.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/data/models/content/question_option.dart';
import 'package:mianyang_quiz/data/models/content/server_answer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class QuestionPdfService {
  pw.Font? _regular;
  pw.Font? _bold;

  /// 字体只拉一次，整个会话复用（PdfGoogleFonts 自己也有缓存，这里再兜一层）。
  Future<(pw.Font, pw.Font)> _fonts() async {
    _regular ??= await PdfGoogleFonts.notoSansSCRegular();
    _bold ??= await PdfGoogleFonts.notoSansSCBold();
    return (_regular!, _bold!);
  }

  /// 直接打印一道题（拼元信息 → 生成 PDF → 交给系统打印对话框，在那儿可另存为 PDF）。
  ///
  /// 元信息那行由**服务**拼而不是页面：它的口径（科目路径/题源/题型/难度/版本号）
  /// 与打印内容是一体的，散在页面里下次改版式就会漏一处。
  Future<void> printQuestion({
    required String title,
    required QuestionBrief brief,
    required QuestionContent content,
  }) async {
    final bytes = await buildQuestion(
      title: title,
      meta: [
        brief.nodePath,
        brief.schoolName,
        brief.type.label,
        if (brief.difficulty != null) '难度 ${difficultyLabel(brief.difficulty)}',
        if (brief.versionNo != null) '第 ${brief.versionNo} 版',
      ].where((part) => part.isNotEmpty).join(' · '),
      qtype: brief.qtype,
      content: content,
    );
    await Printing.layoutPdf(
      onLayout: (_) => bytes,
      name: '题目-${brief.questionId}',
    );
  }

  /// 生成 PDF 字节。[title] 是打印页的大标题，[meta] 是题源/题型那行小字。
  Future<Uint8List> buildQuestion({
    required String title,
    required String meta,
    required String qtype,
    required QuestionContent content,
  }) async {
    final (regular, bold) = await _fonts();
    final doc = pw.Document(
      theme: pw.ThemeData.withFont(base: regular, bold: bold),
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Text(
            title,
            style: const pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            meta,
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
          pw.Divider(color: PdfColors.grey400),
          pw.SizedBox(height: 8),
          ..._questionBlock(qtype: qtype, content: content, numbered: false),
          pw.SizedBox(height: 16),
          pw.Divider(color: PdfColors.grey300),
          pw.Text(
            '绵阳市中职共建题库 · 本题为全市共享题目，内容经两级审核入库',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
        ],
      ),
    );
    return doc.save();
  }

  /// 一道题的正文：题干 → 选项 → 答案 → 解析；复合题递归排子题。
  List<pw.Widget> _questionBlock({
    required String qtype,
    required QuestionContent content,
    required bool numbered,
    int? number,
  }) {
    final out = <pw.Widget>[];
    final stem = content.stem.plainText.trim();
    if (stem.isNotEmpty) {
      out.add(
        pw.Paragraph(
          text: number == null ? stem : '$number. $stem',
          style: const pw.TextStyle(fontSize: 12, lineSpacing: 2),
        ),
      );
    }
    for (final option in content.options) {
      out.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 12, top: 2),
          child: pw.Text(
            '${option.key}. ${option.plainText.trim()}',
            style: const pw.TextStyle(fontSize: 11),
          ),
        ),
      );
    }
    final answer = answerText(content.answer);
    if (answer != null) {
      out.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 4),
          child: pw.Text(
            '答案：$answer',
            style: const pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      );
    }
    final analysis = content.analysis.plainText.trim();
    if (analysis.isNotEmpty) {
      out.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 3),
          child: pw.Text(
            '解析：$analysis',
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey800,
              lineSpacing: 2,
            ),
          ),
        ),
      );
    }
    // 复合题：子题依次排开，各自带答案（根节点的 answer 是 null）
    for (var i = 0; i < content.sub.length; i++) {
      final sub = content.sub[i];
      out.add(pw.SizedBox(height: 6));
      out.addAll(
        _questionBlock(
          qtype: sub.type,
          content: QuestionContent(
            stem: sub.stem,
            options: sub.options,
            answer: sub.answer,
          ),
          numbered: true,
          number: i + 1,
        ),
      );
    }
    return out;
  }
}

/// 标准答案 → 一行可打印文本；没有答案返回 null（不印「答案：」空行）。
String? answerText(ServerAnswer? answer) => switch (answer) {
  null => null,
  ChoiceServerAnswer(:final keys) => keys.isEmpty ? null : keys.join(''),
  TrueFalseServerAnswer(:final value) => value ? '对' : '错',
  BlankServerAnswer(:final values) =>
    values.where((v) => v.trim().isNotEmpty).join(' / ').trim().isEmpty
        ? null
        : values.where((v) => v.trim().isNotEmpty).join(' / '),
  TextServerAnswer(:final samples) => samples.isEmpty ? null : samples.first,
};
