// 错题本的 DataTable 主体（迁移 0111 的排序/搜索口径）。
//
// 为什么用 DataTable 而不是继续用卡片列表：用户明确要看"按错误次数/最近练习"排序，
// 表头本身就是排序入口，比在列表上方再摆一排排序按钮直观。
//
// 手机宽度放不下三列，所以外面套横向滚动；题干列限宽并截两行，
// 其余两列是紧凑数字/相对时间。不可用的题（已下线/删除）保留行但不可点。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';

class WrongQuestionsTable extends StatelessWidget {
  const WrongQuestionsTable({
    super.key,
    required this.rows,
    required this.sortKey,
    required this.ascending,
    required this.onSort,
    required this.onOpen,
    required this.onLoadMore,
    required this.hasMore,
    required this.loadingMore,
  });

  final List<WrongQuestion> rows;

  /// `wrong`（累计错误次数）或 `recent`（最近练习时间）。
  final String sortKey;

  final bool ascending;

  /// 表头点击：列下标（1=错误次数，2=最近练习）与是否升序。
  final void Function(int column, bool ascending) onSort;

  final ValueChanged<WrongQuestion> onOpen;

  final VoidCallback onLoadMore;
  final bool hasMore;
  final bool loadingMore;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sortIndex = sortKey == 'wrong' ? 1 : 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // DataTable 的列宽默认是 intrinsic（内容多宽就多宽），三列加起来常常
        // 填不满一屏，右边留一条空白。套一层「至少和视口一样宽」的约束后，
        // Table 会把多出来的宽度均分到各列；内容真的超宽时仍然横向滚动。
        LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                showCheckboxColumn: false,
                sortColumnIndex: sortIndex,
                sortAscending: ascending,
                headingRowHeight: 44.r,
                dataRowMinHeight: 56.r,
                dataRowMaxHeight: 72.r,
                horizontalMargin: 12.r,
                columnSpacing: 20.r,
                headingTextStyle: AppTextStyles.caption(context)
                    .copyWith(color: scheme.onSurfaceVariant),
                columns: [
                  const DataColumn(label: Text('题目')),
                  DataColumn(
                    label: const Text('累计错误'),
                    numeric: true,
                    onSort: (_, asc) => onSort(1, asc),
                  ),
                  DataColumn(
                    label: const Text('最近练习'),
                    onSort: (_, asc) => onSort(2, asc),
                  ),
                ],
                rows: [
                  for (final row in rows)
                    DataRow(
                      key: ValueKey(row.questionId),
                      onSelectChanged: row.available
                          ? (_) => onOpen(row)
                          : null,
                      cells: [
                        DataCell(_StemCell(row: row)),
                        DataCell(
                          Text(
                            '${row.wrongCount} 次',
                            textAlign: TextAlign.right,
                            style: AppTextStyles.body(context).copyWith(
                              fontWeight: FontWeight.w700,
                              color: row.available
                                  ? scheme.onSurface
                                  : scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            row.answeredAt == null
                                ? '—'
                                : Formatters.relative(row.answeredAt!),
                            style: AppTextStyles.caption(context)
                                .copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        if (hasMore)
          Padding(
            padding: EdgeInsets.only(top: AppMetrics.gapSm.r),
            child: Center(
              child: TextButton.icon(
                onPressed: loadingMore ? null : onLoadMore,
                icon: loadingMore
                    ? SizedBox(
                        width: 16.r,
                        height: 16.r,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.expand_more_rounded),
                label: Text(loadingMore ? '正在加载…' : '加载更多'),
              ),
            ),
          ),
      ],
    );
  }
}

/// 题干列：题干 + 题型/难度。不可用的题只显示占位说明。
class _StemCell extends StatelessWidget {
  const _StemCell({required this.row});

  final WrongQuestion row;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 300.r,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            row.available ? (row.stemText ?? '（题干为空）') : '题目已不可用',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body(context).copyWith(
              color: row.available ? scheme.onSurface : scheme.onSurfaceVariant,
            ),
          ),
          if (row.hasMeta) ...[
            SizedBox(height: AppMetrics.gapXs.r),
            Wrap(
              spacing: AppMetrics.gapXs.r,
              children: [
                DuoChip(label: row.type.label, dense: true),
                DifficultyChip(difficulty: row.difficulty),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
