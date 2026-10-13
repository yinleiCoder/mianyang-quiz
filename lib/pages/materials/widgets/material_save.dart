// 「保存到本地」的共用实现：资料**列表页**与**查看页**各有一个入口，落到这里一份。
//
// 顺序是刻意的：**先存成功、再计一次下载**——那个数字是"这份资料被拿走了几次"的凭据，
// 老师看的就是它（用户原话：以此尊重教师的付出）。存失败却计数等于给数字灌水。
// 计数失败则不打扰用户（仓储内部已经吞掉异常）。

import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:provider/provider.dart';

/// 保存一份资料到本地，并用 SnackBar 说清存到哪了。
Future<void> saveMaterialToDevice(
  BuildContext context,
  MaterialBrief material,
) async {
  // 先取好依赖再 await：跨 await 用 context.read 会被 lint 拦（而且页面可能已经没了）
  final downloads = context.read<MaterialDownloadService>();
  final repository = context.read<MaterialRepository>();
  final messenger = ScaffoldMessenger.of(context);

  try {
    final outcome = await downloads.saveToDevice(material);
    unawaited(repository.countDownload(material.id));
    messenger.showSnackBar(
      SnackBar(
        content: Text(switch (outcome.target) {
          // Windows：已经写进系统「下载」文件夹，把路径给他
          SaveTarget.downloadsFolder => '已保存到 ${outcome.path}',
          // Android：没有等价的写法，交给系统分享面板（见 material_download_service 文件头）
          SaveTarget.shareSheet => '已下载。在分享面板里选「保存到文件」就能存进手机',
        }),
      ),
    );
  } catch (error) {
    messenger.showSnackBar(SnackBar(content: Text(mapError(error).message)));
  }
}
