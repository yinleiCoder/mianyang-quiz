// 题库列表的滚动容器：把一批 QuestionBrief 铺成题卡。
//
// 职责：行间距、滚动与「每行接上收藏状态与两个回调」的接线。
// 不负责：取数、分页、空态（都在 BankPage）。收藏状态以函数形式传入——
// 列表自己不碰全局 Store，页面换了数据来源这里也不用改。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/values/values.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/pages/bank/widgets/question_list_tile.dart';

class QuestionListView extends StatelessWidget {
  const QuestionListView({
    super.key,
    required this.rows,
    required this.isFavorite,
    required this.onOpen,
    required this.onToggleFavorite,
    required this.onRefresh,
    this.accuracy = const {},
  });

  final List<QuestionBrief> rows;

  /// 全站作答统计（question_id → 作答/答对次数）。缺项 = 没人做过，不是错误。
  final Map<String, QuestionAccuracy> accuracy;

  /// 该题当前是否已收藏（页面从 FavoriteStore 读）。
  final bool Function(String questionId) isFavorite;

  final ValueChanged<QuestionBrief> onOpen;
  final ValueChanged<QuestionBrief> onToggleFavorite;

  /// 下拉刷新：重查当前这一页。返回的 Future 由 RefreshIndicator 等待。
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        // 列表短于一屏时也要能下拉（否则只有一两条数据就刷不动了）
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: AppMetrics.gapLg.r),
        itemCount: rows.length,
        separatorBuilder: (_, _) => SizedBox(height: AppMetrics.gapMd.r),
        itemBuilder: (context, index) {
          final brief = rows[index];
          final stat = accuracy[brief.questionId];
          return QuestionListTile(
            brief: brief,
            isFavorite: isFavorite(brief.questionId),
            onTap: () => onOpen(brief),
            onToggleFavorite: () => onToggleFavorite(brief),
            accuracyAttempts: stat?.attempts ?? 0,
            accuracyCorrect: stat?.correct ?? 0,
          );
        },
      ),
    );
  }
}
