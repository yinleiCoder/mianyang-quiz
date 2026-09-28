// 打印链路：中文字体 + PDF 生成，在**真实设备**上跑一遍。
//
// **为什么这条只能做集成测试**：`PdfCjkFont` 读的是**系统字体文件**
// （Windows 的 C:/Windows/Fonts/simhei.ttf 等，Android 的 /system/fonts/…）。
// widget 测试跑在宿主机上、拿到的是测试替身环境，系统里有没有那个字体文件、
// pdf 包认不认那份 .ttc——它一概证明不了。
//
// 而这条路径**真的出过事**：原先用 PdfGoogleFonts 从 fonts.gstatic.com 拉字体，
// 国内网络到不了，且那个调用没有超时，点「打印」既不报错也不出对话框，
// 师生的感受就是「按钮没反应」（2026-09-17 反馈）。改成读系统字体后，
// 「这台机器上到底有没有可用的中文字体」就成了必须实机验证的前提。
//
// **刻意不调 printQuestion**：那会弹出系统打印对话框，自动化里没人去点它，
// 测试会一直挂在那里。这里只验到「能生成一份带汉字的、合法的 PDF 字节」为止。
//
// 跑法：flutter test integration_test/print_flow_test.dart -d windows

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/entity/entity.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('系统里能找到可用的中文字体', (tester) async {
    final font = await PdfCjkFont.load();
    expect(font, isNotNull);
  });

  testWidgets('生成一份含中文的合法 PDF', (tester) async {
    final service = QuestionPdfService();
    final sw = Stopwatch()..start();
    final bytes = await service.buildQuestion(
      title: '打印链路测试',
      meta: '专业目录 / 装备制造类 / 汽车运用 · 测试学校 · 单选题 · 第 1 版',
      qtype: 'single_choice',
      content: _fixture(),
    );
    sw.stop();

    expect(bytes, isA<Uint8List>());
    expect(bytes.length, greaterThan(1000), reason: '一份带汉字的题面不该只有几百字节');

    // PDF 的魔数：`%PDF-`。缺了它说明拿到的是空壳或错误信息，不是文档。
    expect(
      String.fromCharCodes(bytes.take(5)),
      '%PDF-',
      reason: '产物不是合法 PDF —— 多半是字体没加载上，pdf 包写了个空文档',
    );

    // 记录耗时供人工比对（不是断言）：这条链在 UI isolate 上是同步的，
    // 实测约 190ms（首次，含字体解析）/ 65ms（字体已缓存）。
    // 真要下放 isolate 之前，先拿这个数对照 16ms 帧预算。
    debugPrint('[print_flow] PDF 生成耗时 ${sw.elapsedMilliseconds}ms，${bytes.length} 字节');
  });
}

/// 一道形状与真实题目相当的题：长题干 + 四个中文选项 + 解析。
QuestionContent _fixture() => QuestionContent(
  stem: [
    const Block.text(
      text: '下列关于汽车发动机冷却系统工作原理的说法中，正确的是哪一项？'
          '（本题为打印链路测试用题，文字长度与真实题目相当）',
    ),
  ],
  options: [
    for (final k in ['A', 'B', 'C', 'D'])
      QuestionOption(
        key: k,
        label: [Block.text(text: '这是第 $k 个选项的中文文本内容，长度与真实题目相当。')],
      ),
  ],
  answer: const ServerAnswer.choice(keys: ['B']),
  analysis: [
    const Block.text(
      text: '冷却液在发动机水套中吸收热量后流经散热器，由风扇与迎面风散热后再循环回发动机。',
    ),
  ],
);
