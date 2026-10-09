// 复盘里的一道题：题面（只读、已揭示标准答案）+「你的作答」+ 正确答案与解析。
//
// 关于「为什么要重建作答」：snapshot.answersByQuestion 里是**读到的作答记录**
// （Map<String,dynamic>，形状与 SubmittedAnswer.toJson() 相同，但没有经过反序列化）。
// 必须把它喂回 QuestionView，否则选项上只会标出标准答案的绿底——**学生选错的那一项
// 反而是中性色**，一眼看不出自己错在哪（填空同理：不传作答时逐空的对错图标根本不画，
// 见 fill_blank_input_view.dart 的 `widget.answer != null`）。
//
// 曾经这里刻意传 null，理由是"重建会标错位置"。**那个理由是错的**：
//   · 选项乱序只改显示顺序，ChoiceAnswer.keys 存的**始终是原始 key**
//     （见 utils/submitted_answer.dart 与 choice_input_view.dart 的文件头），
//     optionStateOf 也是按原始 key 匹配的——所以无论按什么顺序画，红底都会落在
//     学生真正选中的那个选项实体上。乱序结果没存进快照，只影响"显示字母"这一个
//     对不上（复盘按原始顺序画），不影响标色对不对。
//   · 主观题存的 {'type':'text'} 与复合题主观子题的 {'mastered':bool} 由
//     submittedAnswerFrom 分别还原成 TextAnswer / SubMasteredAnswer；认不出的形状
//     它返回 null，自动退化成"只标标准答案"，不会把「已答」显示成「未作答」。
// 下面的文字行照旧保留：填空与主观题看不出选项标色，仍要靠它说清当时写了什么。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';
import 'package:mianyang_quiz/pages/records/widgets/submitted_answer_text.dart';

class ReviewQuestionCard extends StatelessWidget {
  const ReviewQuestionCard({
    super.key,
    required this.index,
    required this.item,
    this.record,
    this.accuracyAttempts = 0,
    this.accuracyCorrect = 0,
  });

  /// 题号，从 0 开始（显示时 +1）。
  final int index;

  final PracticeItem item;

  /// 该题的历史作答；null = 当时没作答。
  final PracticeAnswerRecord? record;

  /// 全站作答统计（question_accuracy）。0/0 = 没人做过，那时不显示 ——
  /// 复盘页要回答的是"这题是不是很多人都错"，没有数据就别摆一个 0%。
  final int accuracyAttempts;
  final int accuracyCorrect;

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
                    // 全站错误率 / 易错标识：复盘时"我错在哪"之外，还想知道
                    // "这题是不是本来就难"（判据两端同源，见 values/accuracy_meta.dart）
                    if (accuracyAttempts > 0)
                      AccuracyChip(
                        attempts: accuracyAttempts,
                        correct: accuracyCorrect,
                      ),
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
            // 重建当时的选择：学生选错的那一项要靠它才能标红（见文件头）。
            answer: submittedAnswerFrom(record?.answer),
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
