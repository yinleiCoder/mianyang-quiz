// 背题页的展示主体：顶栏 + 当前题的完整内容（题干、答案、解析）。
//
// 从 recite_page.dart 拆出来：页面负责"取数与翻页队列"，这里负责"怎么把一道题
// 连同答案一起摊开给人看"。两者的修改理由完全不同。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/ui/core/feedback/error_state.dart';
import 'package:mianyang_quiz/ui/core/feedback/loading_state.dart';
import 'package:mianyang_quiz/ui/core/question/analysis_view.dart';
import 'package:mianyang_quiz/ui/core/question/question_view.dart';
import 'package:mianyang_quiz/ui/features/practice/recite_entry.dart';
import 'package:mianyang_quiz/ui/features/practice/widgets/recite_top_bar.dart';

class ReciteBody extends StatelessWidget {
  const ReciteBody({
    super.key,
    required this.entries,
    required this.index,
    required this.content,
    required this.onPrev,
    required this.onNext,
  });

  final List<ReciteEntry> entries;
  final int index;
  final AsyncValue<QuestionContent> content;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final entry = entries[index];

    return Column(
      children: [
        ReciteTopBar(
          index: index + 1,
          total: entries.length,
          onPrev: index > 0 ? onPrev : null,
          onNext: index < entries.length - 1 ? onNext : null,
        ),
        Expanded(
          child: switch (content) {
            AsyncLoading() => const LoadingState(),
            AsyncFailure(:final error) => ErrorState(message: error.message),
            AsyncData(:final value) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppMetrics.pagePadding,
                0,
                AppMetrics.pagePadding,
                AppMetrics.gapXl,
              ),
              // 换题时整块重建，避免上一题的滚动位置与输入焦点残留
              key: ValueKey(entry.questionId),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // answerOnly：直接揭示答案，且内部会强制只读
                  QuestionView(
                    qtype: entry.qtype,
                    content: value,
                    answer: null,
                    onAnswerChanged: (_) {},
                    reveal: AnswerReveal.answerOnly,
                  ),
                  const SizedBox(height: AppMetrics.gapXl),
                  // QuestionView 不渲染解析，背题必须单独给出来
                  AnalysisView(content: value, showAnswer: false),
                ],
              ),
            ),
          },
        ),
      ],
    );
  }
}
