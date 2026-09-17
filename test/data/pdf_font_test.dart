// 打印链路的"前半段"：字体能不能读出来、题目能不能排成 PDF 字节。
//
// 为什么值得测：`Printing.layoutPdf` 打不开对话框时**什么都不会报**，界面上就是"按钮没反应"。
// 把前半段单独钉住，出问题时才能立刻分清是"字体/排版"还是"打印插件"。
//
// 字体是从系统里读的（见 pdf_cjk_font.dart），所以这个测试**依赖本机装了中文 TTF**：
// 一个候选都没有就跳过，而不是红给我们看——CI 上未必有这些字体。

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/data/models/content/block.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/data/models/content/question_option.dart';
import 'package:mianyang_quiz/data/models/content/server_answer.dart';
import 'package:mianyang_quiz/data/services/pdf_cjk_font.dart';
import 'package:mianyang_quiz/data/services/question_pdf_service.dart';

void main() {
  final hasSystemFont = PdfCjkFont.candidates.any(
    (path) => File(path).existsSync(),
  );

  test('系统里有中文字体时能读出来（读不到就抛错，不联网）', () async {
    if (!hasSystemFont) {
      markTestSkipped('本机没有候选字体，跳过（CI 上正常）');
      return;
    }
    final font = await PdfCjkFont.load();
    expect(font, isNotNull);
    // 两次调用拿的是同一份（缓存），不该重复解析 9MB 的字体
    expect(identical(font, await PdfCjkFont.load()), isTrue);
  });

  test('一道题能排成非空 PDF（含中文）', () async {
    if (!hasSystemFont) {
      markTestSkipped('本机没有候选字体，跳过（CI 上正常）');
      return;
    }
    final bytes = await QuestionPdfService().buildQuestion(
      title: '题目打印',
      meta: '计算机 / 办公应用 · 单选题 · 第 1 版',
      qtype: 'single_choice',
      content: const QuestionContent(
        stem: [Block.text(text: '在 Word 中，页码必须放在页脚吗？')],
        analysis: [Block.text(text: '不是，页眉页脚都可以。')],
        options: [
          QuestionOption(key: 'A', label: [Block.text(text: '是')]),
          QuestionOption(key: 'B', label: [Block.text(text: '否')]),
        ],
        answer: ServerAnswer.choice(keys: ['B']),
      ),
    );

    expect(bytes.length, greaterThan(1000), reason: 'PDF 里要真的有内容（含嵌入的字体）');
    // PDF 文件头，确认拿到的确实是 PDF
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });
}
