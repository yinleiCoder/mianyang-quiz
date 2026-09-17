// 成绩单里的一道题：题面 + 学生的作答 + 得分（+ 出分后的标准答案）。
//
// 复用 QuestionView 而不是另画一套：它本来就懂"reveal = graded 时标出对错与标准答案"，
// 而考试要的正是这个——区别只在主观题要用 essay 模式（学生的原话在输入框里）。
//
// **答案什么时候给是服务端的事**（见 0056）：出分后卷面带 answer，之前不带。
// 所以这里不看状态，只看 content 里有没有答案——服务端不给，这里自然就什么都不显示。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/constants/qtype_meta.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/core/theme/semantic_colors.dart';
import 'package:mianyang_quiz/core/utils/formatters.dart';
import 'package:mianyang_quiz/data/models/exam/exam_answer.dart';
import 'package:mianyang_quiz/data/models/exam/exam_paper.dart';
import 'package:mianyang_quiz/domain/submitted_answer.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/core/design/duo_chip.dart';
import 'package:mianyang_quiz/ui/core/question/answer_summary_view.dart';
import 'package:mianyang_quiz/ui/core/question/input/short_answer_mode.dart';
import 'package:mianyang_quiz/ui/core/question/question_view.dart';

class ExamReviewCard extends StatelessWidget {
  const ExamReviewCard({
    super.key,
    required this.number,
    required this.item,
    required this.record,
    required this.revealed,
  });

  /// 题号（1 起）。
  final int number;

  final ExamItem item;

  /// 这道题的作答与判分；没作答过就是 null。
  final ExamAnswerRecord? record;

  /// 是否揭示对错与标准答案（出分后为 true）。
  final bool revealed;

  @override
  Widget build(BuildContext context) {
    final answer = submittedAnswerFrom(record?.answer);

    return DuoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('第 $number 题', style: AppTextStyles.sectionTitle(context)),
              const Spacer(),
              DuoChip(
                label: item.type.label,
                tone: DuoChipTone.neutral,
                dense: true,
              ),
              SizedBox(width: AppMetrics.gapXs.r),
              // Flexible：得分文案的长度随卷面分值变（"得 12.5 / 20 分"比"得 1 / 2 分"
              // 宽一倍多），不给孩子宽度上限的 Row 在窄屏上会直接溢出。
              Flexible(child: _ScoreChip(item: item, record: record)),
            ],
          ),
          SizedBox(height: AppMetrics.gapMd.r),
          QuestionView(
            qtype: item.qtype,
            content: item.content,
            answer: answer,
            onAnswerChanged: _ignore,
            reveal: revealed ? AnswerReveal.graded : AnswerReveal.none,
            readOnly: true,
            shortAnswerMode: ShortAnswerMode.essay,
          ),
          // 主观题的作答区自带「参考答案」（贴在输入框上方），不必再叠一遍
          if (revealed && item.type != QuestionType.shortAnswer) ...[
            SizedBox(height: AppMetrics.gapMd.r),
            AnswerSummaryView(content: item.content),
          ],
          if (record?.comment != null && record!.comment!.trim().isNotEmpty) ...[
            SizedBox(height: AppMetrics.gapMd.r),
            _Comment(text: record!.comment!.trim()),
          ],
        ],
      ),
    );
  }
}

void _ignore(SubmittedAnswer answer) {}

/// 得分：待阅卷 / 得 x 分。
///
/// 只报总分，不报"对了几 个给分点"——填空题的逐空对错由作答区自己标（每空一个勾/叉），
/// 再说一遍既占地方又容易和卷面分值对不上。
class _ScoreChip extends StatelessWidget {
  const _ScoreChip({required this.item, required this.record});

  final ExamItem item;
  final ExamAnswerRecord? record;

  @override
  Widget build(BuildContext context) {
    if (record?.isPending ?? false) {
      return const DuoChip(
        label: '待阅卷',
        tone: DuoChipTone.warning,
        dense: true,
      );
    }
    final score = record?.score ?? 0;
    final full = item.score <= 0 ? 1.0 : item.score;
    final tone = score >= full
        ? DuoChipTone.success
        : (score <= 0 ? DuoChipTone.danger : DuoChipTone.neutral);

    return DuoChip(
      label: '得 ${Formatters.score(score)} / ${Formatters.score(item.score)} 分',
      tone: tone,
      dense: true,
    );
  }
}

class _Comment extends StatelessWidget {
  const _Comment({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(AppMetrics.gapMd.r),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppMetrics.radiusButton.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 16.r,
            color: context.semantic.success,
          ),
          SizedBox(width: AppMetrics.gapSm.r),
          Expanded(
            child: Text(
              '老师评语：$text',
              style: AppTextStyles.body(context),
            ),
          ),
        ],
      ),
    );
  }
}
