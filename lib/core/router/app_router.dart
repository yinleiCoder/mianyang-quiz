// 路由表与登录守卫。
//
// 结构：登录后的四个主页面挂在 StatefulShellRoute.indexedStack 下（各自保留导航栈与
// 滚动位置，切 tab 不会重置页面）；练习、组卷、题目详情这类"全屏页"挂在壳之外，
// 不显示底部导航。
//
// **登录守卫是全局唯一的会话失效处理点。** 不要在每个页面里各写一遍
// "catch AuthException 就跳登录"：
//   · 令牌过期时 supabase 会在 authStateChanges 上发出 signedOut，
//     AuthStore 收到后刷新档案并 notifyListeners
//   · 本路由 refreshListenable 挂了同一个 store，于是重新求值 redirect，
//     把用户送回登录页
// 页面只需要展示错误文案，跳转由这里统一负责。

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/router/routes.dart';
import 'package:mianyang_quiz/data/models/exam/exam_attempt.dart';
import 'package:mianyang_quiz/data/models/practice/practice_results.dart';
import 'package:mianyang_quiz/state/auth_store.dart';
import 'package:mianyang_quiz/state/practice_mode.dart';
import 'package:mianyang_quiz/ui/core/feedback/empty_state.dart';
import 'package:mianyang_quiz/ui/features/auth/email_verify_page.dart';
import 'package:mianyang_quiz/ui/features/auth/forgot_password_page.dart';
import 'package:mianyang_quiz/ui/features/auth/login_page.dart';
import 'package:mianyang_quiz/ui/features/auth/register_page.dart';
import 'package:mianyang_quiz/ui/features/ai/ai_page.dart';
import 'package:mianyang_quiz/ui/features/bank/bank_page.dart';
import 'package:mianyang_quiz/ui/features/bank/question_detail_page.dart';
import 'package:mianyang_quiz/ui/features/compose/compose_page.dart';
import 'package:mianyang_quiz/ui/features/exam/exam_list_page.dart';
import 'package:mianyang_quiz/ui/features/exam/exam_page.dart';
import 'package:mianyang_quiz/ui/features/exam/exam_result_page.dart';
import 'package:mianyang_quiz/data/models/material/material_brief.dart';
import 'package:mianyang_quiz/ui/features/home/home_page.dart';
import 'package:mianyang_quiz/ui/features/materials/material_viewer_page.dart';
import 'package:mianyang_quiz/ui/features/materials/materials_page.dart';
import 'package:mianyang_quiz/ui/features/practice/practice_page.dart';
import 'package:mianyang_quiz/ui/features/practice/practice_result_page.dart';
import 'package:mianyang_quiz/ui/features/practice/recite_page.dart';
import 'package:mianyang_quiz/ui/features/profile/change_password_page.dart';
import 'package:mianyang_quiz/ui/features/profile/edit_profile_page.dart';
import 'package:mianyang_quiz/core/router/route_observer.dart';
import 'package:mianyang_quiz/ui/features/profile/feedback_page.dart';
import 'package:mianyang_quiz/ui/features/profile/profile_page.dart';
import 'package:mianyang_quiz/ui/features/records/records_page.dart';
import 'package:mianyang_quiz/ui/features/records/session_review_page.dart';
import 'package:mianyang_quiz/ui/features/shell/app_shell.dart';

/// 未登录也能访问的路径。
const _publicPaths = {
  AppRoutes.loginPath,
  AppRoutes.registerPath,
  AppRoutes.emailVerifyPath,
  // 忘记密码必须在这里：要走这条的人**恰恰是登不上的那批人**。
  // 反过来，忘了密码的用户一旦重置成功并自动登录，下面的守卫会把他送回首页 —— 正合预期。
  AppRoutes.forgotPasswordPath,
};

GoRouter createAppRouter(AuthStore auth) {
  return GoRouter(
    initialLocation: AppRoutes.homePath,
    refreshListenable: auth,
    // 给"从子页面返回时该重拉"的页面用（如错题本，见 route_observer.dart）
    observers: [appRouteObserver],
    redirect: (context, state) {
      // 会话还没恢复完就别急着判断——否则冷启动会闪一下登录页
      if (!auth.isReady) return null;

      final path = state.uri.path;
      final isPublic = _publicPaths.contains(path);

      if (!auth.isSignedIn) return isPublic ? null : AppRoutes.loginPath;
      // 已登录还去登录/注册页，直接送回首页
      if (isPublic && path != AppRoutes.emailVerifyPath) return AppRoutes.homePath;
      return null;
    },
    routes: [
      // ---------- 登录后的主壳（底部导航内）----------
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.homePath,
                name: AppRoutes.homeName,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.bankPath,
                name: AppRoutes.bankName,
                builder: (context, state) => const BankPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.aiPath,
                name: AppRoutes.aiName,
                builder: (context, state) => const AiPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.recordsPath,
                name: AppRoutes.recordsName,
                builder: (context, state) => RecordsPage(
                  // 结果页会带 ?tab=wrong 直接落到错题本页签
                  initialTab: state.uri.queryParameters[AppRoutes.recordsTabQuery],
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profilePath,
                name: AppRoutes.profileName,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),

      // ---------- 公开页 ----------
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.loginName,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.registerPath,
        name: AppRoutes.registerName,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.emailVerifyPath,
        name: AppRoutes.emailVerifyName,
        builder: (context, state) => const EmailVerifyPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPasswordPath,
        name: AppRoutes.forgotPasswordName,
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      // ---------- 全屏页（壳之外，不显示底部导航）----------
      GoRoute(
        path: AppRoutes.questionDetailPath,
        name: AppRoutes.questionDetailName,
        builder: (context, state) =>
            QuestionDetailPage(questionId: state.pathParameters['questionId']!),
      ),
      GoRoute(
        path: AppRoutes.composePath,
        name: AppRoutes.composeName,
        builder: (context, state) => const ComposePage(),
      ),
      GoRoute(
        path: AppRoutes.practicePath,
        name: AppRoutes.practiceName,
        builder: (context, state) {
          // 组卷页通过 extra 传子模式与是否乱序；从"继续练习"直接进来时用默认值
          final extra = state.extra;
          final mode = extra is ({PracticeMode mode, bool shuffle})
              ? extra.mode
              : PracticeMode.instant;
          final shuffle = extra is ({PracticeMode mode, bool shuffle})
              ? extra.shuffle
              : true;
          return PracticePage(
            sessionId: state.pathParameters['sessionId']!,
            mode: mode,
            shuffleOptions: shuffle,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.practiceResultPath,
        name: AppRoutes.practiceResultName,
        builder: (context, state) => PracticeResultPage(
          sessionId: state.pathParameters['sessionId']!,
          // extra 的类型不受编译器保证，用 is 判断而不是硬转
          summary: state.extra is FinishSummary ? state.extra! as FinishSummary : null,
        ),
      ),
      GoRoute(
        path: AppRoutes.recitePath,
        name: AppRoutes.reciteName,
        builder: (context, state) => const RecitePage(),
      ),
      GoRoute(
        path: AppRoutes.sessionReviewPath,
        name: AppRoutes.sessionReviewName,
        builder: (context, state) =>
            SessionReviewPage(sessionId: state.pathParameters['sessionId']!),
      ),
      // ---------- 考试 ----------
      // 列表页带页签（试卷库 / 我的考试），答题页与成绩单页是全屏的下一步。
      GoRoute(
        path: AppRoutes.examsPath,
        name: AppRoutes.examsName,
        builder: (context, state) => ExamListPage(
          initialTab: state.uri.queryParameters[AppRoutes.examsTabQuery],
        ),
      ),

      // 复习资料。入口在首页工作台，同样不占底部导航的位置（理由见 routes.dart）。
      GoRoute(
        path: AppRoutes.materialsPath,
        name: AppRoutes.materialsName,
        builder: (context, state) => const MaterialsPage(),
      ),
      GoRoute(
        path: AppRoutes.materialViewPath,
        name: AppRoutes.materialViewName,
        builder: (context, state) {
          // 资料本体随 extra 一起带过来，省一次往返；它不受编译器保证类型，
          // 所以用 is 判断而不是硬转（与考试那两条路由同款处理）。
          final material = state.extra;
          if (material is! MaterialBrief) return const _RouteNotFoundPage();
          return MaterialViewerPage(material: material);
        },
      ),
      GoRoute(
        path: AppRoutes.examAttemptPath,
        name: AppRoutes.examAttemptName,
        builder: (context, state) => ExamPage(
          attemptId: state.pathParameters['attemptId']!,
          // 开考那一跳会把刚拿到的快照一起带过来，省一次往返；
          // extra 的类型不受编译器保证，用 is 判断而不是硬转
          snapshot: state.extra is ExamSnapshot
              ? state.extra! as ExamSnapshot
              : null,
        ),
      ),
      GoRoute(
        path: AppRoutes.examResultPath,
        name: AppRoutes.examResultName,
        builder: (context, state) =>
            ExamResultPage(attemptId: state.pathParameters['attemptId']!),
      ),
      GoRoute(
        path: AppRoutes.editProfilePath,
        name: AppRoutes.editProfileName,
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.feedbackPath,
        name: AppRoutes.feedbackName,
        builder: (context, state) => const FeedbackPage(),
      ),
      // 修改密码要求已登录，所以**不进 _publicPaths**（进去会被"已登录访问公开页"弹回首页）
      GoRoute(
        path: AppRoutes.changePasswordPath,
        name: AppRoutes.changePasswordName,
        builder: (context, state) => const ChangePasswordPage(),
      ),
    ],
    errorBuilder: (context, state) => const _RouteNotFoundPage(),
  );
}

class _RouteNotFoundPage extends StatelessWidget {
  const _RouteNotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('页面不存在')),
      body: EmptyState(
        icon: Icons.explore_off_outlined,
        title: '没有找到这个页面',
        message: '链接可能已失效，或内容已被移除。',
        action: FilledButton(
          onPressed: () => context.go(AppRoutes.homePath),
          child: const Text('回到首页'),
        ),
      ),
    );
  }
}
