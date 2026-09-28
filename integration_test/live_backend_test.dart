// 真实账号 + 真实后端的端到端流程：**登录 → 首页学情 → 题库列表 → 题目详情**。
//
// **这条测试为什么值钱**：它走的是全链路——真 Supabase 认证、真 PostgREST 查询、
// 真 OSS 图片地址、真数据渲染。widget 测试里 client 指向假地址、请求被 flutter_test
// 拦掉，所以下面这些东西**一条都证明不了**：
//   · 账号密码真的能登进去（认证链路 + 合成邮箱口径）
//   · 题库列表那条查询真的不报 300（questions ↔ question_versions 双外键，
//     少带 `!question_versions_question_id_fkey` 就会崩，而假 client 永远发现不了）
//   · RLS 对这些表真的放行
//   · 服务端返回的真实题面能被客户端解析并画出来
//
// **全程只读**：不建会话、不提交作答、不写任何业务表。
// 会写库的那条在 practice_flow_test.dart，且默认不跑。
//
// 跑法：
//   flutter test integration_test/live_backend_test.dart -d windows \
//     --dart-define-from-file=config/dev.json \
//     --dart-define-from-file=config/test.local.json
//
// 没给测试账号时会 skip，不会红。

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mianyang_quiz/pages/bank/widgets/question_list_tile.dart';
import 'package:mianyang_quiz/pages/shell/widgets/app_side_nav.dart';
import 'package:mianyang_quiz/widgets/widgets.dart';

import 'support/live_account.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('真实账号：登录 → 首页学情 → 题库列表 → 题目详情', (tester) async {
    if (skipUnlessAccountConfigured()) return;

    await launchAndLogin(tester);

    // ---- 宽屏侧栏的两个快捷入口（在真实窗口里确认一遍）----
    // widget 测试用的是自己搭的壳、自己摆的窗口；这里跑的是真应用 + 真 ScreenUtil 配置，
    // 桌面端"缩放没关掉"那类问题只在这条路径上暴露（1280 宽被按 390 放大 3.3 倍）。
    expect(
      find.byType(AppSideNav),
      findsOneWidget,
      reason: '桌面窗口应当是宽屏档（≥$kWideBreakpoint），侧栏没出来',
    );
    expect(find.text('开始练习'), findsOneWidget, reason: '侧栏缺「开始练习」入口');
    expect(find.text('参加考试'), findsOneWidget, reason: '侧栏缺「参加考试」入口');

    // ---- 首页：等真实学情加载完 ----
    // 信号取「你好，xxx」：它是首页列表的**第一项**，且只在 AsyncView
    // 拿到数据后才存在。**别用「最近做过的题」那种靠后的标题**——
    // 首页是 ListView，视口外的子项根本没被构建，`find` 找不到它，
    // 结果是数据早就回来了却报超时。
    await waitFor(tester, find.textContaining('你好，'), what: '首页学情加载完成');

    // ---- 题库：真查询、真列表 ----
    // 此时只有导航栏上有「题库」（题库分支是首次进入才构建的），所以这个 finder 是唯一的
    await tester.tap(find.text('题库'));
    await tester.pump();

    await waitFor(tester, find.text('筛选'), what: '题库页出现筛选条');
    await waitFor(
      tester,
      find.byType(QuestionListTile),
      what: '题库列表拉到真实题目（这条查询带不带外键 hint 差别就在这里）',
    );

    // ---- 题目详情：真题面渲染 ----
    await tester.tap(find.byType(QuestionListTile).first);
    await tester.pump();

    await waitFor(tester, find.text('题目详情'), what: '进入题目详情页');

    // 详情页取不到数据时会显示「重试」；没出现才说明真题面拿到了
    expect(
      find.text('重试'),
      findsNothing,
      reason: '详情页落到了失败态 —— 真实查询或解析出了问题',
    );
    expect(tester.takeException(), isNull);
  });
}
