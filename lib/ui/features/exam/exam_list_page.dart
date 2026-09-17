// 考试页：试卷库 / 我的考试两个页签。
//
// 从首页工作台进来（不动底部导航：考试是"被安排的事"，不像刷题那样随时发生）。
// 答题页与成绩单页是它推出去的全屏页，不在本页里。
//
// **刻意不给这两个页签加 AutomaticKeepAliveClientMixin**（记录的三个页签加了）：
// 这两个列表会因别处的动作而变——刚交完卷回到这里，"我的考试"必须显示交卷后的状态，
// 留住页面状态反而会显示"进行中"。代价是切页签要重拉一次，这两个列表都很短，值得。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/ui/features/exam/widgets/exam_attempt_list_tab.dart';
import 'package:mianyang_quiz/ui/features/exam/widgets/exam_paper_list_tab.dart';

class ExamListPage extends StatelessWidget {
  const ExamListPage({super.key, this.initialTab});

  /// 打开时落在哪个页签（取值见 AppRoutes.examsTab*，未知值落到试卷库）。
  final String? initialTab;

  static const _tabs = [AppRoutes.examsTabLibrary, AppRoutes.examsTabMine];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final index = _tabs.indexOf(initialTab ?? AppRoutes.examsTabLibrary);

    return DefaultTabController(
      length: _tabs.length,
      initialIndex: index < 0 ? 0 : index,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('考试'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(AppMetrics.touchTarget.r),
            child: TabBar(
              labelColor: scheme.primary,
              unselectedLabelColor: scheme.onSurfaceVariant,
              indicatorColor: scheme.primary,
              dividerColor: scheme.outlineVariant,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [Tab(text: '试卷库'), Tab(text: '我的考试')],
            ),
          ),
        ),
        body: const SafeArea(
          // **不套 MaxWidthBox**：数据页要铺满窗口宽度（同记录页）。
          child: TabBarView(
            children: [ExamPaperListTab(), ExamAttemptListTab()],
          ),
        ),
      ),
    );
  }
}
