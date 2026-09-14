// 背题模式：直接看题与答案，不计分、不提交、不产生任何记录。
//
// **刻意不建练习会话。** start_practice_session 会往 practice_sessions 写一行
// （练习记录页正是读这张表），还会静默作废用户正在进行中的刷题会话——
// 用它来实现背题会同时破坏"背题不留痕"和"刷题进度不丢"两件事。
//
// 所以这里走纯 PostgREST：先取一批题的题号与题干（题库筛选 / 错题本 / 收藏三条来源），
// 翻到哪题再取那题的完整内容并按题号缓存。比一次拉全套省得多，翻页也不会卡。
//
// 与刷题页的分工：刷题页有状态机（PracticeRunner）与提交逻辑；本页只有"翻页 + 展示"。

import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/core/utils/async_value.dart';
import 'package:mianyang_quiz/data/models/bank/question_filter.dart';
import 'package:mianyang_quiz/data/models/content/question_content.dart';
import 'package:mianyang_quiz/data/models/practice/practice_session.dart';
import 'package:mianyang_quiz/data/repositories/list_repository.dart';
import 'package:mianyang_quiz/data/repositories/question_repository.dart';
import 'package:mianyang_quiz/ui/core/feedback/empty_state.dart';
import 'package:mianyang_quiz/ui/core/feedback/error_state.dart';
import 'package:mianyang_quiz/ui/core/feedback/loading_state.dart';
import 'package:mianyang_quiz/ui/features/practice/recite_entry.dart';
import 'package:mianyang_quiz/ui/features/practice/widgets/recite_body.dart';
import 'package:provider/provider.dart';

class RecitePage extends StatefulWidget {
  const RecitePage({
    super.key,
    this.filter = const QuestionFilter(),
    this.source = PracticeSource.all,
    this.title = '背题',
  });

  final QuestionFilter filter;
  final PracticeSource source;
  final String title;

  @override
  State<RecitePage> createState() => _RecitePageState();
}

class _RecitePageState extends State<RecitePage> {
  static const _pageSize = 20;

  AsyncValue<List<ReciteEntry>> _queue = const AsyncLoading();
  final Map<String, QuestionContent> _contentCache = {};
  AsyncValue<QuestionContent> _current = const AsyncLoading();
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _loadQueue();
  }

  Future<void> _loadQueue() async {
    setState(() => _queue = const AsyncLoading());
    try {
      final entries = await _fetchEntries();
      if (!mounted) return;
      setState(() {
        _queue = AsyncData(entries);
        _index = 0;
      });
      if (entries.isNotEmpty) await _loadContent(entries.first.questionId);
    } catch (error) {
      if (!mounted) return;
      setState(() => _queue = AsyncFailure(mapError(error)));
    }
  }

  /// 三条来源统一成同一份队列形状。
  Future<List<ReciteEntry>> _fetchEntries() async {
    switch (widget.source) {
      case PracticeSource.all:
        final page = await context.read<QuestionRepository>().listQuestions(
          filter: widget.filter,
          pageSize: _pageSize,
        );
        return [
          for (final row in page.rows)
            (questionId: row.questionId, stemText: row.stemText, qtype: row.qtype),
        ];
      case PracticeSource.wrong:
        final rows = await context.read<ListRepository>().fetchWrongQuestions(
          limit: _pageSize,
        );
        return [
          for (final row in rows)
            if (row.available)
              (
                questionId: row.questionId,
                stemText: row.stemText ?? '',
                qtype: row.qtype ?? '',
              ),
        ];
      case PracticeSource.favorites:
        final rows = await context.read<ListRepository>().fetchFavorites(
          limit: _pageSize,
        );
        return [
          for (final row in rows)
            if (row.available)
              (
                questionId: row.questionId,
                stemText: row.stemText ?? '',
                qtype: row.qtype ?? '',
              ),
        ];
    }
  }

  Future<void> _loadContent(String questionId) async {
    final cached = _contentCache[questionId];
    if (cached != null) {
      setState(() => _current = AsyncData(cached));
      return;
    }
    setState(() => _current = const AsyncLoading());
    try {
      final detail =
          await context.read<QuestionRepository>().fetchDetail(questionId);
      if (!mounted) return;
      if (detail == null) {
        setState(() => _current = const AsyncFailure(
              ServerException('这道题已下线或不可见'),
            ));
        return;
      }
      _contentCache[questionId] = detail.content;
      setState(() => _current = AsyncData(detail.content));
    } catch (error) {
      if (!mounted) return;
      setState(() => _current = AsyncFailure(mapError(error)));
    }
  }

  void _go(int delta) {
    final entries = _queue.valueOrNull;
    if (entries == null) return;
    final next = _index + delta;
    if (next < 0 || next >= entries.length) return;
    setState(() => _index = next);
    unawaited(_loadContent(entries[next].questionId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: switch (_queue) {
                    AsyncLoading() => const LoadingState(message: '正在准备题目…'),
                    AsyncFailure(:final error) => ErrorState(
                      message: error.message,
                      onRetry: _loadQueue,
                    ),
                    AsyncData(:final value) when value.isEmpty => const EmptyState(
                      icon: Icons.menu_book_outlined,
                      title: '这里还没有可背的题',
                      message: '换个来源，或先去题库里找几道题。',
                    ),
                    AsyncData(:final value) => ReciteBody(
                      entries: value,
                      index: _index,
                      content: _current,
                      onPrev: () => _go(-1),
                      onNext: () => _go(1),
                    ),
                  },
      ),
    );
  }
}
