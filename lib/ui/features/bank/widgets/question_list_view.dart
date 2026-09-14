// 题库列表的滚动容器：把一批 QuestionBrief 铺成题卡。
//
// 职责：行间距、滚动与「每行接上收藏状态与两个回调」的接线。
// 不负责：取数、分页、空态（都在 BankPage）。收藏状态以函数形式传入——
// 列表自己不碰全局 Store，页面换了数据来源这里也不用改。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/models/bank/question_brief.dart';
import 'package:mianyang_quiz/ui/features/bank/widgets/question_list_tile.dart';

class QuestionListView extends StatelessWidget {
  const QuestionListView({
    super.key,
    required this.rows,
    required this.isFavorite,
    required this.onOpen,
    required this.onToggleFavorite,
  });

  final List<QuestionBrief> rows;

  /// 该题当前是否已收藏（页面从 FavoriteStore 读）。
  final bool Function(String questionId) isFavorite;

  final ValueChanged<QuestionBrief> onOpen;
  final ValueChanged<QuestionBrief> onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(bottom: AppMetrics.gapLg.r),
      itemCount: rows.length,
      separatorBuilder: (_, _) => SizedBox(height: AppMetrics.gapMd.r),
      itemBuilder: (context, index) {
        final brief = rows[index];
        return QuestionListTile(
          brief: brief,
          isFavorite: isFavorite(brief.questionId),
          onTap: () => onOpen(brief),
          onToggleFavorite: () => onToggleFavorite(brief),
        );
      },
    );
  }
}
