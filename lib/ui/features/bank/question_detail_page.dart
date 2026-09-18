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
import 'package:mianyang_quiz/core/constants/report_meta.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/data/models/bank/question_report.dart';
import 'package:mianyang_quiz/data/repositories/question_report_repository.dart';
import 'package:mianyang_quiz/data/repositories/question_repository.dart';
import 'package:mianyang_quiz/data/services/question_pdf_service.dart';
import 'package:mianyang_quiz/state/favorite_store.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/core/feedback/async_view.dart';
import 'package:mianyang_quiz/ui/core/feedback/empty_state.dart';
import 'package:mianyang_quiz/ui/core/feedback/favorite_toggle.dart';
import 'package:mianyang_quiz/ui/core/question/analysis_view.dart';
import 'package:mianyang_quiz/ui/core/question/question_view.dart';
import 'package:mianyang_quiz/ui/features/bank/widgets/question_meta_header.dart';
import 'package:mianyang_quiz/ui/features/bank/widgets/question_report_sheet.dart';
import 'package:mianyang_quiz/ui/features/bank/widgets/share_question_sheet.dart';
import 'package:provider/provider.dart';

class QuestionDetailPage extends StatefulWidget {
  const QuestionDetailPage({super.key, required this.questionId});

  final String questionId;

  @override
  State<QuestionDetailPage> createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState extends State<QuestionDetailPage> {
  AsyncValue<QuestionDetail?> _state = const AsyncLoading();

  /// 我在这道题上提过的反馈（含作者的回复）。
  /// 这是本功能与通用意见反馈最大的不同 —— 那边没有回复闭环，这边有。
  QuestionReport? _myReport;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _state = const AsyncLoading());
    try {
      // 两道请求并行：题目本身与"我的反馈"互不依赖，串行会白白多等一轮往返
      final detailFuture = context.read<QuestionRepository>().fetchDetail(
        widget.questionId,
      );
      final reportFuture = _loadMyReport();
      final detail = await detailFuture;
      final myReport = await reportFuture;
      if (!mounted) return;
      setState(() {
        _state = AsyncData(detail);
        _myReport = myReport;
      });
    } on AppException catch (error) {
      if (!mounted) return;
      setState(() => _state = AsyncFailure(error));
    }
  }

  /// 「我的反馈」失败**不影响整页** —— 它是附加信息，拿不到就不显示那一块，
  /// 题目本身照常看。为一个附加卡片让整页进错误态是本末倒置。
  Future<QuestionReport?> _loadMyReport() async {
    try {
      return await context.read<QuestionReportRepository>().fetchMyReport(
        widget.questionId,
      );
    } catch (_) {
      return null;
    }
  }

  /// 打开纠错弹层。提交成功才重新拉一次"我的反馈"。
  Future<void> _report() async {
    final detail = _state.valueOrNull;
    if (detail == null) return;
    final submitted = await showQuestionReportSheet(
      context,
      questionId: widget.questionId,
      versionId: detail.brief.versionId,
      versionNo: detail.brief.versionNo,
    );
    if (submitted != true || !mounted) return;
    final myReport = await _loadMyReport();
    if (!mounted) return;
    setState(() => _myReport = myReport);
  }

  /// 打印这道题。中文字体从**系统字体文件**读（见 QuestionPdfService 文件头），
  /// 读不到就明确告诉用户，而不是印出一片空白、也不是卡住不响应。
  Future<void> _print() async {
    final detail = _state.valueOrNull;
    if (detail == null) return;
    try {
      await context.read<QuestionPdfService>().printQuestion(
        title: '题目打印',
        brief: detail.brief,
        content: detail.content,
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('生成 PDF 失败：这台电脑上没找到可用的中文字体（需要 simhei/msyh 这类字体）'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // select 而不是 watch：FavoriteStore 是全局共享的，任何一处收藏切换都会通知。
    // watch 整店会让本题的题干、全部选项与解析跟着重建一遍。
    final favorite = context.select<FavoriteStore, bool>(
      (store) => store.isFavorite(widget.questionId),
    );
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('题目详情'),
        actions: [
          // 纠错：把「这题有问题」发给本题作者。题目还没取到时禁用 —— 没有 versionId
          // 就提交不了（服务端要校验版本属于这道题）。
          IconButton(
            onPressed: _state.valueOrNull == null ? null : _report,
            tooltip: '这题有问题',
            icon: const Icon(Icons.flag_outlined),
          ),
          // 打印：排成 A4 交给系统打印对话框（在那儿可「另存为 PDF」）
          IconButton(
            onPressed: _print,
            tooltip: '打印',
            icon: const Icon(Icons.print_outlined),
          ),
          // 分享：把这道题发给别人（系统分享 / 复制链接）。题干摘要一并传下去，
          // 让分享文案和弹层预览都能看出是哪道题
          IconButton(
            onPressed: () => showShareQuestionSheet(
              context,
              questionId: widget.questionId,
              stem: _state.valueOrNull?.brief.stemText,
            ),
            tooltip: '分享',
            icon: const Icon(Icons.ios_share),
          ),
          IconButton(
            // 与题库列表共用同一个动作：切换 + toast，文案必须一致
            onPressed: () => toggleFavoriteWithToast(
              context,
              questionId: widget.questionId,
              toggle: context.read<FavoriteStore>().toggle,
            ),
            tooltip: favorite ? '取消收藏' : '收藏',
            icon: Icon(
              favorite ? Icons.favorite : Icons.favorite_border,
              color: favorite ? scheme.primary : null,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: AsyncView<QuestionDetail?>(
          state: _state,
          onRetry: _load,
          // null 是"题目已下线或不可见"——它不是错误，所以不走错误态
          builder: (detail) => detail == null
              ? const _Invisible()
              : _Body(detail: detail, myReport: _myReport),
        ),
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
  const _Body({required this.detail, this.myReport});

  final QuestionDetail detail;

  /// 我提过的反馈（含作者回复）。为 null 时整块不渲染 —— 没反馈过的人
  /// 不该看到一个空盒子。
  final QuestionReport? myReport;

  @override
  Widget build(BuildContext context) {
    final brief = detail.brief;
    return ListView(
      padding: EdgeInsets.all(AppMetrics.pagePadding.r),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 署名交给元信息条：标签与署名同一行两端对齐（见该组件注释）
            QuestionMetaHeader(brief: brief, credits: detail.credits),
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
                child: AnalysisView(content: detail.content, showAnswer: false),
              ),
            // 我提过的反馈：把作者的回复亮出来。
            // **这是本功能与通用意见反馈最大的不同** —— 那边是"不在这里回复"，
            // 这边有闭环。不显示回音的话，学生的观感和石沉大海没区别。
            if (myReport != null) ...[
              SizedBox(height: AppMetrics.gapMd.r),
              _MyReportCard(report: myReport!),
            ],
          ],
        ),
      ],
    );
  }
}

/// 「我的反馈」卡片：我提的内容 + 作者的处理说明。
class _MyReportCard extends StatelessWidget {
  const _MyReportCard({required this.report});

  final QuestionReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final resolved = report.isResolved;
    // 已处理用成功色，待处理用中性色 —— 语义色对走 semanticColors，
    // 别在这里手拼 onTertiaryContainer 之类（AGENTS.md 二·五警告过那个坑）。
    final badgeColor = resolved ? scheme.primary : scheme.onSurfaceVariant;

    return DuoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag_outlined, size: 18.r, color: badgeColor),
              SizedBox(width: AppMetrics.gapXs.r),
              Text(
                '我的反馈',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(width: AppMetrics.gapSm.r),
              Text(
                resolved ? ReportStatus.resolved.label : ReportStatus.open.label,
                style: theme.textTheme.bodySmall?.copyWith(color: badgeColor),
              ),
              const Spacer(),
              Text(
                reportCategoryLabel(report.category),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: AppMetrics.gapSm.r),
          Text(
            report.content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: AppMetrics.gapSm.r),
          Divider(height: 1, color: scheme.outlineVariant),
          SizedBox(height: AppMetrics.gapSm.r),
          if (resolved)
            Text(
              '作者回复：${report.resolveNote ?? ""}',
              style: theme.textTheme.bodyMedium,
            )
          else
            Text(
              '作者还没处理。处理后会在这里回复你。',
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}
