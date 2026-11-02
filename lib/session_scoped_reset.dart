// 会话从「已登录」变成「未登录」时，清掉所有按账号存的内存状态。
//
// 三个入口（主动退出、令牌过期被踢、刷新失败）都汇到这里；只在
// profile_page 里手动清两个 Store 会漏掉收藏与其它账号级缓存。
//
// 放 lib/ 根下而不是 widgets/：它同时依赖 state 与 UI（widgets 层禁止
// import state），与 error_handling.dart 同类，是"应用壳"的一环。
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/state/state.dart';
import 'package:provider/provider.dart';

class SessionScopedReset extends StatefulWidget {
  const SessionScopedReset({super.key, required this.child});

  final Widget child;

  @override
  State<SessionScopedReset> createState() => _SessionScopedResetState();
}

class _SessionScopedResetState extends State<SessionScopedReset> {
  bool? _signedIn;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final signedIn = context.watch<AuthStore>().isSignedIn;
    if (_signedIn == true && !signedIn) {
      context.read<CheckinStore>().clear();
      context.read<DashboardStore>().clear();
      context.read<FavoriteStore>().clear();
    }
    _signedIn = signedIn;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
