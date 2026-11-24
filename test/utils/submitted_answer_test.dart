// 逐键编辑的判定：决定 Runner 要不要通知界面重建。
//
// 这条判据很窄，但两个方向都值钱：
//   · 判成"要重建" → 每敲一个字，整道题（题干/选项/答题卡/按钮）都重画一遍；
//   · 判成"不用重建" → 主观题删空之后，答题卡还记着"已答"、底部还写"还差 0 题"。
// 所以这里把边界逐条钉住，而不是只测 happy path。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/utils/utils.dart';

void main() {
  test('填空与考试主观题的文字变化 = 逐键编辑，不必通知', () {
    expect(
      isTypingOnlyEdit(const BlankAnswer(['北']), const BlankAnswer(['北京'])),
      isTrue,
    );
    expect(
      isTypingOnlyEdit(const EssayAnswer('答'), const EssayAnswer('答案')),
      isTrue,
    );
  });

  test('选中/改选选项不是逐键编辑：选中态必须重画', () {
    expect(
      isTypingOnlyEdit(const ChoiceAnswer(['A']), const ChoiceAnswer(['B'])),
      isFalse,
    );
    expect(
      isTypingOnlyEdit(
        const TrueFalseAnswer(true),
        const TrueFalseAnswer(false),
      ),
      isFalse,
    );
  });

  test('从无到有、从有到无都必须通知（进度与答题卡依赖它）', () {
    expect(isTypingOnlyEdit(null, const BlankAnswer(['北京'])), isFalse);
    expect(isTypingOnlyEdit(const BlankAnswer(['北京']), null), isFalse);
    expect(isTypingOnlyEdit(null, const EssayAnswer('答案')), isFalse);
    // "写了又删空"在 ExamDraftBuffer 里会变成 null，走的就是上面那条。
    expect(isTypingOnlyEdit(const EssayAnswer('答案'), null), isFalse);
  });

  test('不同作答形态之间切换不是逐键编辑', () {
    expect(
      isTypingOnlyEdit(const BlankAnswer(['北京']), const TextAnswer()),
      isFalse,
    );
    expect(
      isTypingOnlyEdit(const TextAnswer(), const EssayAnswer('答案')),
      isFalse,
    );
  });

  test('复合题一律通知：它的拼装依赖父级下发的旧快照', () {
    expect(
      isTypingOnlyEdit(
        const CompositeAnswer([BlankAnswer(['北'])]),
        const CompositeAnswer([BlankAnswer(['北京'])]),
      ),
      isFalse,
    );
  });
}
