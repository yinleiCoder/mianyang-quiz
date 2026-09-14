// 收藏按钮的动作：切换 + 把结果 toast 出来。
//
// 为什么是独立函数而不是各页写一遍：题库列表与题目详情都要这个动作，
// 两处的文案（已收藏 / 已取消收藏）与失败处理必须逐字一致，否则用户会以为行为不同。
// 它既不是组件、也不属于某个页面，所以既不进 widgets/ 也不进任一页面文件。
//
// await 之前先把 messenger 取出来：这样 await 之后不再碰 context，
// 天然满足 use_build_context_synchronously，调用方也不必再判 mounted。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/error/app_exception.dart';
import 'package:mianyang_quiz/state/favorite_store.dart';
import 'package:provider/provider.dart';

Future<void> toggleFavoriteWithToast(
  BuildContext context,
  String questionId,
) async {
  final store = context.read<FavoriteStore>();
  final messenger = ScaffoldMessenger.of(context);
  try {
    final favorite = await store.toggle(questionId);
    messenger.showSnackBar(
      SnackBar(content: Text(favorite ? '已收藏' : '已取消收藏')),
    );
  } on AppException catch (error) {
    messenger.showSnackBar(SnackBar(content: Text(error.message)));
  }
}
