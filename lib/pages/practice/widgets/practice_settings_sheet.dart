// 练习页的「练习设置」：练题音效开关。
//
// 为什么不在顶栏放一个图标直接切换：音效是**偏好**而不是一次性动作，
// 用 Switch 能让人看见当前是开还是关；顶栏已经有退出、计时、答题卡三个入口，
// 再塞一个带文字的开关会挤，所以收进底部弹层。
//
// 开关与「开始练习」页的「练题音效」是同一份本地偏好（SfxService），
// 两处任何一边改，另一边下次打开时看到的都是同一个值。

import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:provider/provider.dart';

Future<void> openPracticeSettings(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => const SafeArea(child: _PracticeSettingsSheet()),
  );
}

class _PracticeSettingsSheet extends StatelessWidget {
  const _PracticeSettingsSheet();

  @override
  Widget build(BuildContext context) {
    return Consumer<SfxService>(
      builder: (context, sfx, _) => SwitchListTile(
        value: sfx.enabled,
        onChanged: (value) =>
            unawaited(context.read<SfxService>().setEnabled(value)),
        secondary: Icon(
          sfx.enabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
        ),
        title: const Text('练题音效'),
        subtitle: const Text('答对、答错、交卷时出声；开关记在本机，考试页同样生效'),
      ),
    );
  }
}
