// 记录页：练习记录 / 错题本 / 收藏三个 Tab。
//
// 职责：装配标题、分段控件与三个 Tab；三者的数据各自在 Tab 内部加载与分页。
// 不负责：任何取数（Tab 自己与仓储打交道）。
//
// 错题本与收藏**不是独立页面**，就是这里的第 2、3 个 Tab：
// 练习结果页想直接跳「查看错题」时走 /records?tab=wrong（AppRoutes.recordsOf），
// 由路由把 query 读成 [initialTab] 传进来（取值见 AppRoutes.recordsTab*，未知值落到第一个）。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/favorites_tab.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/practice_history_tab.dart';
import 'package:mianyang_quiz/ui/features/records/widgets/wrong_questions_tab.dart';

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key, this.initialTab});

  /// 打开时落在哪个 Tab。传字符串而不是枚举：它是从 URL query 直接下来的，
  /// 枚举化只会多一层「字符串→枚举→下标」的转换，而且未知值还得再兜一次底。
  final String? initialTab;

  /// Tab 顺序。用路由的常量而不是字符串字面量：路由那边也是同一批常量，
  /// 两边各写一遍迟早会出现「跳错题本却落到了收藏」。
  static const _tabs = [
    AppRoutes.recordsTabRecords,
    AppRoutes.recordsTabWrong,
    AppRoutes.recordsTabFavorites,
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final index = _tabs.indexOf(initialTab ?? AppRoutes.recordsTabRecords);

    return DefaultTabController(
      length: _tabs.length,
      initialIndex: index < 0 ? 0 : index,
      child: Scaffold(
        body: SafeArea(
          // **不套 MaxWidthBox**：记录页是数据页，要铺满窗口宽度。
          // 套上限宽后滚动视图只剩中间那一条，滚动条会跑到内容区右边而不是窗口侧边，
          // 窗口越宽越明显。（专注型页面如刷题/背题仍限宽——1920px 宽的单道题更难读。）
          child: Column(
            children: [
              Padding(
                // 标题与分段控件保留左右安全边距；下面的列表各自也留了同宽的边距。
                padding: EdgeInsets.fromLTRB(
                  AppMetrics.pagePadding.r,
                  AppMetrics.gapLg.r,
                  AppMetrics.pagePadding.r,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('我的记录', style: AppTextStyles.pageTitle(context)),
                    SizedBox(height: AppMetrics.gapMd.r),
                    TabBar(
                      labelColor: scheme.primary,
                      unselectedLabelColor: scheme.onSurfaceVariant,
                      indicatorColor: scheme.primary,
                      dividerColor: scheme.outlineVariant,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: const [
                        Tab(text: '练习记录'),
                        Tab(text: '错题本'),
                        Tab(text: '收藏'),
                      ],
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    PracticeHistoryTab(),
                    WrongQuestionsTab(),
                    FavoritesTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
