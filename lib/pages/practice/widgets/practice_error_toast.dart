// 练习里「提交 / 交卷」失败时的统一收尾。
//
// PracticeStage 的两个 catch 分支（_check 与 _finish）本来逐字相同，
// 只有前缀不同。抽出来的同时把顺序也钉在这里：
//   1. 先回查会话是否已经结束——结束了界面会换成结束态并说明原因，
//      再叠一句「提交失败」只会让人以为再点一次就能好（见 syncEndedState）；
//   2. 没结束才弹一句能读的错误。
//
// 文案用 mapError(...).message，不要插值原始异常：AppException.toString() 是
// '$runtimeType: $message'，用户会看到「ServerException: …」。

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/pages/practice/state/practice_runner.dart';

Future<void> showPracticeSubmitError(
  BuildContext context,
  PracticeRunner runner,
  Object error, {
  required String prefix,
}) async {
  await runner.syncEndedState();
  if (!context.mounted || runner.ended != null) return;
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('$prefix：${mapError(error).message}')));
}
