// 题目详情页：**背题式**只读展示。
//
// 职责：取一道题的当前已发布版本，先摆元信息（题型/难度/版本号/入库时间/科目路径/题源学校），
// 再用 QuestionView（reveal: answerOnly）把题干、选项与标准答案一次性铺开，最后附解析。
// 不负责：作答与判分（本页不可作答）、收藏状态的跨页同步（FavoriteStore 负责）、
// 列表与分页（BankPage）。
//
// 不可见（不存在 / 已下线 / 版本不是 published）时显示 EmptyState，而不是抛异常或留白屏：
// 用户可能从旧链接或收藏进来，那时"这题看不了了"本身就是正确答案。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/data/repositories/question_repository.dart';
import 'package:mianyang_quiz/state/favorite_store.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/core/feedback/empty_state.dart';
import 'package:mianyang_quiz/ui/core/feedback/error_state.dart';
import 'package:mianyang_quiz/ui/core/feedback/loading_state.dart';
import 'package:mianyang_quiz/ui/core/question/analysis_view.dart';
import 'package:mianyang_quiz/ui/core/question/question_view.dart';
import 'package:mianyang_quiz/ui/features/bank/favorite_action.dart';
import 'package:mianyang_quiz/ui/features/bank/widgets/question_meta_header.dart';
import 'package:provider/provider.dart';

class QuestionDetailPage extends StatefulWidget {
  const QuestionDetailPage({super.key, required this.questionId});

  final String questionId;

  @override
  State<QuestionDetailPage> createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState extends State<QuestionDetailPage> {
  AsyncValue<QuestionDetail?> _state = const AsyncLoading();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _state = const AsyncLoading());
    try {
      final detail = await context
          .read<QuestionRepository>()
          .fetchDetail(widget.questionId);
      if (!mounted) return;
      setState(() => _state = AsyncData(detail));
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() => _state = AsyncFailure(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final favorite = context
        .watch<FavoriteStore>()
        .isFavorite(widget.questionId);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('题目详情'),
        actions: [
          IconButton(
            // 与题库列表共用同一个动作：切换 + toast，文案必须一致
            onPressed: () =>
                toggleFavoriteWithToast(context, widget.questionId),
            tooltip: favorite ? '取消收藏' : '收藏',
            icon: Icon(
              favorite ? Icons.favorite : Icons.favorite_border,
              color: favorite ? scheme.primary : null,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: switch (_state) {
          AsyncLoading() => const LoadingState(),
          AsyncFailure(:final error) => ErrorState(
            message: error.message,
            onRetry: _load,
          ),
          AsyncData(:final value) => value == null
              ? const _Invisible()
              : _Body(detail: value),
        },
      ),
    );
  }
}

/// 题目不可见：不是错误，不提供"重试"——重试多少次它也不会回来。
class _Invisible extends StatelessWidget {
  const _Invisible();

  @override
  Widget build(BuildContext context) => const EmptyState(
    icon: Icons.visibility_off_outlined,
    title: '这道题暂时看不了',
    message: '它可能已被下线或删除。换一道题继续吧。',
  );
}

/// 详情正文。可滚动：题干、选项、答案、解析加起来通常超过一屏。
class _Body extends StatelessWidget {
  const _Body({required this.detail});

  final QuestionDetail detail;

  @override
  Widget build(BuildContext context) {
    final brief = detail.brief;
    return ListView(
      padding: EdgeInsets.all(AppMetrics.pagePadding.r),
      children: [
        Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      QuestionMetaHeader(brief: brief),
                      SizedBox(height: AppMetrics.gapMd.r),
                      DuoCard(
                        child: QuestionView(
                          qtype: brief.qtype,
                          content: detail.content,
                          // 背题不给作答：answer 恒为 null，回调是空实现
                          answer: null,
                          onAnswerChanged: (_) {},
                          reveal: AnswerReveal.answerOnly,
                          readOnly: true,
                        ),
                      ),
                      SizedBox(height: AppMetrics.gapMd.r),
                      // showAnswer: false —— answerOnly 已在选项/填空上标出标准答案，
                      // 再让 AnswerSummaryView 说一遍就是重复。
                      // 无解析时不渲染这张卡：AnalysisView 只会给出一个空盒子，
                      // 空卡片比"没有解析"更让人觉得是加载失败。
                      if (detail.content.analysis.isNotEmpty)
                        DuoCard(
                          child: AnalysisView(
                            content: detail.content,
                            showAnswer: false,
                          ),
                        ),
                    ],
                  ),
      ],
    );
  }
}
