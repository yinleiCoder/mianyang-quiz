// 登录后的应用外壳：导航（窄屏底部 / 宽屏侧边）+ 当前分支的内容区。
//
// 由 StatefulShellRoute.indexedStack 驱动——每个分支保留自己的导航栈与滚动位置，
// 来回切分支不会重置页面（对题库列表尤其重要：翻了三页再切走切回来，
// 不该回到第一页）。
//
// ---------------------------------------------------------------------------
// 响应式切换与树形结构（实测结论，不是推测）
// ---------------------------------------------------------------------------
// 用户拖动窗口跨过断点时，外壳会从"底部导航"变成"侧边导航"。直觉上会担心：
// 如果写成两套结构（宽屏 Row[SideNav, Expanded(shell)]、窄屏 Scaffold(body: shell)），
// navigationShell 的位置变了，Element 被重建，页面状态就丢了。
//
// **实测（test/ui/app_shell_test.dart）：这个担心不成立。** 两种写法下，
// 跨断点后页面内计数、当前所在分支都保持不变。原因是 StatefulShellRoute 的分支
// 导航器由路由代理用 GlobalKey 持有 —— 外壳的 Element 即便被替换，
// navigator 子树是被**重新挂载**而不是重建，状态因此保住。
//
// 尽管如此这里仍保持**外壳骨架恒定**，只切换导航栏自身：
//   · body 恒为 Row([导航槽, Expanded(navigationShell)])
//   · navigationShell 永远在 index 1、永远包在 Expanded 里
//   · 导航槽用条件表达式占位（宽屏 AppSideNav、窄屏零尺寸 SizedBox）
//   · 底部导航挂在 Scaffold 的 bottomNavigationBar 槽上，与 body 互不影响
//
// 理由是**避免无谓的重新挂载**（省掉一次子树 reattach 与随之而来的布局抖动），
// 而不是修复一个可复现的 bug。把这个区别写清楚，是为了不让后来者以为
// "改成两套结构就会丢状态"——那是错的，改了测试会告诉你。

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/ui/core/layout/breakpoints.dart';
import 'package:mianyang_quiz/ui/features/shell/widgets/app_bottom_nav.dart';
import 'package:mianyang_quiz/ui/features/shell/widgets/clipboard_link_listener.dart';
import 'package:mianyang_quiz/ui/features/shell/widgets/update_checker.dart';
import 'package:mianyang_quiz/ui/features/shell/widgets/app_side_nav.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  /// go_router 注入的分支导航器。**它的位置必须跨断点保持不变**——见文件头说明。
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= kWideBreakpoint;

        // initialLocation: true 让"再次点击当前项"回到该分支的根，
        // 这是移动端的通用预期（相当于"回到首页"）
        void select(int index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );

        // 两件与页面无关的"全局监听"都挂在外壳上（登录后的所有页面都在它们下面）：
        //   · 剪贴板识别：回到前台时读一次，认出题目分享链接就问要不要打开；
        //   · 检查更新：冷启动后查一次 GitHub 的 latest，有新版本弹一次。
        return UpdateChecker(
          child: ClipboardLinkListener(
            child: Scaffold(
              body: Row(
                children: [
                  // 导航槽：始终占据 index 0。两种形态的元素个数一致，
                  // 所以 index 1 的 navigationShell 不会因切换而重建。
                  if (wide)
                    AppSideNav(
                      currentIndex: navigationShell.currentIndex,
                      onSelect: select,
                    )
                  else
                    const SizedBox.shrink(),
                  Expanded(child: navigationShell),
                ],
              ),
              bottomNavigationBar: wide
                  ? null
                  : AppBottomNav(
                      currentIndex: navigationShell.currentIndex,
                      onSelect: select,
                    ),
            ),
          ),
        );
      },
    );
  }
}
