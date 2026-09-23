// 依赖装配：把 SupabaseClient 展开成仓储、服务与 Store，供 MultiProvider 注册。
//
// 为什么单独一个文件而不是塞进 main.dart 或 app.dart：
//   · main.dart 要保持极短（入口一旦开始长东西就说明有依赖没归位）
//   · app.dart 只该关心"怎么渲染"
//   装配是第三件事，放这里。
//
// 依赖方向：仓储/服务只依赖 client，Store 依赖仓储/服务。
// 页面通过 context.read<Xxx>() 取，**不在 widget 里 new**（AGENTS.md 约定）。

import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:mianyang_quiz/data/repositories/app_update_repository.dart';
import 'package:mianyang_quiz/data/repositories/favorite_repository.dart';
import 'package:mianyang_quiz/data/repositories/feedback_repository.dart';
import 'package:mianyang_quiz/data/repositories/list_repository.dart';
import 'package:mianyang_quiz/data/repositories/material_repository.dart';
import 'package:mianyang_quiz/data/repositories/paper_repository.dart';
import 'package:mianyang_quiz/data/repositories/password_repository.dart';
import 'package:mianyang_quiz/data/repositories/practice_repository.dart';
import 'package:mianyang_quiz/data/repositories/question_report_repository.dart';
import 'package:mianyang_quiz/data/repositories/question_repository.dart';
import 'package:mianyang_quiz/data/repositories/stats_repository.dart';
import 'package:mianyang_quiz/data/repositories/subject_repository.dart';
import 'package:mianyang_quiz/data/repositories/user_repository.dart';
import 'package:mianyang_quiz/data/services/auth_service.dart';
import 'package:mianyang_quiz/data/services/exam_draft_service.dart';
import 'package:mianyang_quiz/data/services/material_download_service.dart';
import 'package:mianyang_quiz/data/services/oss_upload_service.dart';
import 'package:mianyang_quiz/data/services/question_pdf_service.dart';
import 'package:mianyang_quiz/data/services/sfx_service.dart';
import 'package:mianyang_quiz/state/auth_store.dart';
import 'package:mianyang_quiz/state/dashboard_store.dart';
import 'package:mianyang_quiz/state/favorite_store.dart';
import 'package:mianyang_quiz/state/practice_draft_store.dart';

class AppDependencies {
  AppDependencies._(this.client)
    : authService = AuthService(client),
      userRepository = UserRepository(client),
      subjectRepository = SubjectRepository(client),
      questionRepository = QuestionRepository(client),
      questionReportRepository = QuestionReportRepository(client),
      passwordRepository = PasswordRepository(client),
      practiceRepository = PracticeRepository(client),
      statsRepository = StatsRepository(client),
      listRepository = ListRepository(client),
      favoriteRepository = FavoriteRepository(client),
      feedbackRepository = FeedbackRepository(client),
      paperRepository = PaperRepository(client),
      materialRepository = MaterialRepository(client),
      appUpdateRepository = AppUpdateRepository(Dio()),
      ossUploadService = OssUploadService(client),
      // 下载用独立的 Dio：与 appUpdateRepository 一样是"拿别人的东西"，
      // 不该跟 OSS 直传共用（那个带签名相关的拦截器与超时设置）
      materialDownloadService = MaterialDownloadService(Dio()),
      sfxService = SfxService(),
      examDraftService = ExamDraftService(),
      questionPdfService = QuestionPdfService();

  /// 由 bootstrap() 在 Supabase.initialize 之后调用。
  factory AppDependencies.create(SupabaseClient client) {
    final deps = AppDependencies._(client);
    deps.authStore = AuthStore(deps.authService, deps.userRepository);
    deps.dashboardStore = DashboardStore(deps.statsRepository);
    deps.favoriteStore = FavoriteStore(deps.favoriteRepository);
    deps.practiceDraftStore = PracticeDraftStore();
    return deps;
  }

  final SupabaseClient client;

  final AuthService authService;
  final UserRepository userRepository;
  final SubjectRepository subjectRepository;
  final QuestionRepository questionRepository;

  /// 题目纠错（学生 → 本题作者）。与 feedbackRepository 是两回事：
  /// 那边的收件人是系统管理员且没有回复闭环，这个有（见仓库文件头）。
  final QuestionReportRepository questionReportRepository;

  /// 找回密码（未登录自助重置）。走 RPC 而不是 Auth SDK —— 理由见仓储文件头。
  final PasswordRepository passwordRepository;
  final PracticeRepository practiceRepository;
  final StatsRepository statsRepository;
  final ListRepository listRepository;
  final FavoriteRepository favoriteRepository;
  final FeedbackRepository feedbackRepository;
  final PaperRepository paperRepository;
  final MaterialRepository materialRepository;
  final AppUpdateRepository appUpdateRepository;
  final OssUploadService ossUploadService;
  final SfxService sfxService;

  /// 考试作答的本机暂存。**不是 Store**：它不通知任何人，只是一处本地读写
  /// （服务端要等交卷才存答案，中途退出只能靠它，见 exam_draft_service.dart）。
  final ExamDraftService examDraftService;
  final QuestionPdfService questionPdfService;
  final MaterialDownloadService materialDownloadService;

  /// 四个跨页 Store。赋值在 create() 里完成（它们彼此之间与仓储有依赖顺序）。
  late final AuthStore authStore;
  late final DashboardStore dashboardStore;
  late final FavoriteStore favoriteStore;
  late final PracticeDraftStore practiceDraftStore;

  /// 启动会话恢复。**不 await**：拉档案要走网络，等它会让首屏白屏；
  /// 路由守卫已经在 isReady 为 false 时挂起，页面自己显示加载态即可。
  void startSession() {
    authStore.bootstrap();
    // 音效开关存本地，启动时恢复一次（失败保持默认开）
    sfxService.load();
  }

  void dispose() {
    authStore.dispose();
    dashboardStore.dispose();
    favoriteStore.dispose();
    practiceDraftStore.dispose();
    sfxService.dispose();
  }
}
