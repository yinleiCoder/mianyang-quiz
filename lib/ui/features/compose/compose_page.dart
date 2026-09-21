// 组卷页：决定"练什么、练多少、怎么练"，然后开始。
//
// 可以从四个入口进来（首页 / 题库 / 错题本 / 收藏），每处的来源与预填条件不同，
// 所以条件存在 PracticeDraftStore 里而不是本页 State —— 用户退出再进来时，
// 上次调好的条件还在。
//
// 本页最要紧的一件事：**开始新练习会静默作废进行中的会话**。
// 所以进页面先看有没有 active_session，非空时必须让用户选「继续 / 重新开始」——
// 那一段连同「今天练完了」的重试都在 start_practice_flow.dart，本页只管选条件与按钮态。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/models/bank/question_filter.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';
import 'package:mianyang_quiz/state/dashboard_store.dart';
import 'package:mianyang_quiz/data/services/sfx_service.dart';
import 'package:mianyang_quiz/state/practice_draft_store.dart';
import 'package:mianyang_quiz/ui/core/design/duo_button.dart';
import 'package:mianyang_quiz/ui/core/design/duo_card.dart';
import 'package:mianyang_quiz/ui/core/layout/section_header.dart';
import 'package:mianyang_quiz/ui/features/compose/start_practice_flow.dart';
import 'package:mianyang_quiz/ui/features/compose/widgets/compose_options.dart';
import 'package:mianyang_quiz/ui/features/compose/widgets/filter_fields.dart';
import 'package:mianyang_quiz/ui/features/compose/widgets/source_selector.dart';
import 'package:provider/provider.dart';

class ComposePage extends StatefulWidget {
  const ComposePage({super.key});

  @override
  State<ComposePage> createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {
  bool _starting = false;

  PracticeDraftStore get _draft => context.read<PracticeDraftStore>();

  /// 开始练习：本页只管按钮的 loading 态，流程本身在 start_practice_flow.dart
  ///（等看板 → 处理进行中的会话 → 组卷 → 今天练完了的重试 → 跳转）。
  Future<void> _start() async {
    final draft = _draft;
    if (draft.source != PracticeSource.all && draft.filterApplies) {
      // 防御：来源不是题库时筛选条件不生效，不该带着"看起来生效了"的条件去开练
      draft.updateFilter(const QuestionFilter());
    }

    setState(() => _starting = true);
    // 进了练习页就交给那边，不要回写状态（本页马上会被替换掉）
    final entered = await startPracticeFlow(context, draft: draft);
    if (!mounted || entered) return;
    setState(() => _starting = false);
  }

  @override
  void initState() {
    super.initState();
    // 进页面就把进行中的会话读出来（用于上面的提醒），顺便刷新看板
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<DashboardStore>().refresh(silent: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<PracticeDraftStore>();

    return Scaffold(
      appBar: AppBar(title: const Text('开始练习')),
      body: SafeArea(
        child: ListView(
                    padding: const EdgeInsets.all(AppMetrics.pagePadding),
                    children: [
                      const SectionHeader(title: '题目来源'),
                      DuoCard(
                        padding: const EdgeInsets.all(AppMetrics.gapMd),
                        child: SourceSelector(
                          value: draft.source,
                          onChanged: (value) {
                            // 换来源时重置筛选：用户在错题本点"练错题"期望的是练错题，
                            // 而不是"练上次选的科目里的错题"
                            draft.startFrom(source: value);
                          },
                        ),
                      ),
                      const SizedBox(height: AppMetrics.gapXl),
                      const SectionHeader(title: '练习方式'),
                      ComposeOptions(
                        mode: draft.mode,
                        limit: draft.limit,
                        shuffle: draft.shuffleOptions,
                        sound: context.watch<SfxService>().enabled,
                        onModeChanged: draft.setMode,
                        onLimitChanged: draft.setLimit,
                        onShuffleChanged: draft.setShuffleOptions,
                        onSoundChanged: context.read<SfxService>().setEnabled,
                      ),
                      if (draft.filterApplies) ...[
                        const SizedBox(height: AppMetrics.gapXl),
                        const SectionHeader(
                          title: '筛选条件',
                          subtitle: '选了父级科目会包含它下面的全部课程',
                        ),
                        FilterFields(
                          value: draft.filter,
                          onChanged: draft.updateFilter,
                        ),
                      ],
                      const SizedBox(height: AppMetrics.gapXl),
                      DuoButton(
                        label: draft.source == PracticeSource.all
                            ? '开始练习（最多 ${draft.limit} 题）'
                            : '开始练习（${draft.source.label}）',
                        icon: Icons.play_arrow,
                        loading: _starting,
                        onPressed: _start,
                      ),
                      const SizedBox(height: AppMetrics.gapSm),
                      Text(
                        '开始新练习会作废之前未完成的进度。',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
