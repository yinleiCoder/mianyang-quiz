// 复盘里的一道题：题面（只读、已揭示标准答案）+「你的作答」+ 正确答案与解析。
//
// 关于「为什么 QuestionView 的 answer 传 null」——这是复盘页最关键的一个取舍。
// snapshot.answersByQuestion 里是**读到的作答记录**（Map<String,dynamic>，形状与
// SubmittedAnswer.toJson() 相同，但没有经过反序列化）。硬把它重建为 SubmittedAnswer 有两个坑：
//   · 主观题存的是 {'type':'text'}，不带任何内容；复合题的主观子题是 {'mastered':bool}，
//     连 type 键都没有——重建出来要么丢信息，要么把「已答」显示成「未作答」；
//   · 选项乱序结果没有存进快照（它是刷题时算一次物化的），重建后的作答会与眼前的
//     选项顺序对不上，标错位置比不标更糟。
// 所以：QuestionView 只揭示标准答案（reveal: graded + 不传作答），
// 「当时选了什么」由下面的文字行如实列出——文字行不会因为解码猜错而说谎。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/core/design/duo_chip.dart';
import 'package:mianyang_quiz/ui/core/question/analysis_view.dart';
import 'package:mianyang_quiz/ui/core/question/question_view.dart';
import 'package:mianyang_quiz/ui/core/design/difficulty_chip.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/submitted_answer_text.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';

class ReviewQuestionCard extends StatelessWidget {
  const ReviewQuestionCard({
    super.key,
    required this.index,
    required this.item,
    this.record,
  });

  /// 题号，从 0 开始（显示时 +1）。
  final int index;

  final PracticeItem item;

  /// 该题的历史作答；null = 当时没作答。
  final PracticeAnswerRecord? record;

  @override
  Widget build(BuildContext context) {
    final record = this.record;

    return DuoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: AppMetrics.gapXs.r,
                  runSpacing: AppMetrics.gapXs.r,
                  children: [
                    DuoChip(
                      label: '第 ${index + 1} 题',
                      tone: DuoChipTone.brand,
                      dense: true,
                    ),
                    DuoChip(label: item.type.label, dense: true),
                    DifficultyChip(difficulty: item.difficulty),
                  ],
                ),
              ),
              SizedBox(width: AppMetrics.gapSm.r),
              _VerdictChip(record: record),
            ],
          ),
          SizedBox(height: AppMetrics.gapLg.r),
          QuestionView(
            qtype: item.qtype,
            content: item.content,
            answer: null,
            // 只读展示也要给回调，但什么都不做（QuestionView 是纯受控组件）。
            onAnswerChanged: (_) {},
            reveal: AnswerReveal.graded,
            readOnly: true,
            selfMastered: record?.selfMastered,
          ),
          SizedBox(height: AppMetrics.gapLg.r),
          _YourAnswerLine(record: record),
          SizedBox(height: AppMetrics.gapLg.r),
          // 标准答案与解析一起给：选项上的标记只解决选择题，填空与主观题
          // 靠这里的文字才看得清，复合题还会自动逐子题展开。
          AnalysisView(content: item.content),
        ],
      ),
    );
  }
}

/// 判定徽标：答对 / 答错 / 未作答；主观题显示自评结果（它的对错由自评决定）。
class _VerdictChip extends StatelessWidget {
  const _VerdictChip({required this.record});

  final PracticeAnswerRecord? record;

  @override
  Widget build(BuildContext context) {
    final record = this.record;
    if (record == null) {
      return const DuoChip(label: '未作答', tone: DuoChipTone.neutral, dense: true);
    }
    if (record.grading == 'self') {
      final mastered = record.selfMastered == true;
      return DuoChip(
        label: mastered ? '自评掌握' : '自评未掌握',
        tone: mastered ? DuoChipTone.success : DuoChipTone.danger,
        dense: true,
      );
    }
    final correct = record.isCorrect == true;
    return DuoChip(
      label: correct ? '答对' : '答错',
      tone: correct ? DuoChipTone.success : DuoChipTone.danger,
      dense: true,
    );
  }
}

/// 「你的作答」一行。颜色跟着判定走（对=语义绿 semantic.success、错=error、未作答=中性），
/// 因为选项上标的是标准答案，用户当时的选择只能从这里看出来。
class _YourAnswerLine extends StatelessWidget {
  const _YourAnswerLine({required this.record});

  final PracticeAnswerRecord? record;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final correct = record?.isCorrect;
    final color = correct == null
        ? scheme.onSurfaceVariant
        // 「对」用语义绿，不用 tertiary —— 种子色派生的 tertiary 是粉红，与 error 的红撞色
        : (correct ? context.semantic.success : scheme.error);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '你的作答：',
          style: AppTextStyles.label(context).copyWith(color: scheme.onSurfaceVariant),
        ),
        Expanded(
          child: Text(
            submittedAnswerText(record),
            style: AppTextStyles.body(context).copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
