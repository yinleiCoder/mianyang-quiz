// 路由路径与名称常量。
//
// 约定：页面内一律引用这里的常量，禁止硬编码路径字符串——
// 硬编码的路径改不动，而且编译期不会告诉你哪里漏改了。
//
// 命名规则：`<name>Path` / `<name>Name` 成对出现；
// 带参数的路径额外提供 `xxxOf(id)` 拼接方法，避免调用点自己拼字符串。

abstract final class AppRoutes {
  // ---------- 公开页（未登录可访问）----------
  static const loginPath = '/login';
  static const loginName = 'login';

  static const registerPath = '/register';
  static const registerName = 'register';

  static const emailVerifyPath = '/verify-email';
  static const emailVerifyName = 'emailVerify';

  /// 忘记密码（自助重置）。必须是公开页：要走这条的人**恰恰是登不上的那批人**。
  static const forgotPasswordPath = '/forgot-password';
  static const forgotPasswordName = 'forgotPassword';

  // ---------- 登录后的主壳（底部导航内）----------
  static const homePath = '/';
  static const homeName = 'home';

  static const bankPath = '/bank';
  static const bankName = 'bank';

  static const recordsPath = '/records';
  static const aiPath = '/ai';
  static const recordsName = 'records';
  static const aiName = 'ai';

  static const profilePath = '/profile';
  static const profileName = 'profile';

  // ---------- 全屏页（在壳之外，不显示底部导航）----------
  static const questionDetailPath = '/bank/:questionId';
  static const questionDetailName = 'questionDetail';

  static const composePath = '/compose';
  static const composeName = 'compose';

  static const practicePath = '/practice/:sessionId';
  static const practiceName = 'practice';

  static const recitePath = '/recite';
  static const reciteName = 'recite';

  static const practiceResultPath = '/practice/:sessionId/result';
  static const practiceResultName = 'practiceResult';

  /// 复盘某次已结束的练习（与结果页不同：结果页是刚交卷的结算，
  /// 复盘页是事后回看每一题的作答与标准答案）。
  static const sessionReviewPath = '/practice/:sessionId/review';
  static const sessionReviewName = 'sessionReview';

  // ---------- 考试 ----------
  // 入口在首页工作台（不动底部导航）：考试是"被安排的事"，
  // 不像刷题那样随时发生，占一个常驻 tab 反而会把刷题挤下去。

  static const examsPath = '/exams';
  static const examsName = 'exams';

  // ---------- 复习资料 ----------
  // 入口同样在首页工作台，不做第 6 个底部 tab：Material 的底部导航上限是 5 个
  //（首页/题库/AI/记录/我的已经占满），再挤一个每个都变窄。与上面考试那条同一个判断。

  static const materialsPath = '/materials';
  static const materialsName = 'materials';

  /// 资料查看页：PDF 用内嵌阅读器，图片全屏看，其余（Office/音视频）在这里给出
  /// 「用其他程序打开 / 保存到本地 / 分享」三个动作——统一落在一页，列表只需一个入口。
  static const materialViewPath = '/materials/:materialId';
  static const materialViewName = 'materialView';

  static const examAttemptPath = '/exams/attempt/:attemptId';
  static const examAttemptName = 'examAttempt';

  static const examResultPath = '/exams/attempt/:attemptId/result';
  static const examResultName = 'examResult';

  static const editProfilePath = '/profile/edit';
  static const editProfileName = 'editProfile';

  /// 意见反馈（联系系统管理员）：内容短，独立一页比弹窗更好写校验与错误态。
  static const feedbackPath = '/profile/feedback';
  static const feedbackName = 'feedback';

  /// 修改密码（已登录、记得住旧密码的人走这条）。**不能进公开页名单** ——
  /// 它要求已登录，进了名单反而会被守卫「已登录访问公开页」的规则弹回首页。
  static const changePasswordPath = '/profile/password';
  static const changePasswordName = 'changePassword';

  // ---------- RecordsPage 的页签 ----------
  // 错题本与收藏**不是独立路由**，而是记录页的三个页签之一，
  // 用查询参数指定初始页签（/records?tab=wrong），避免两套入口指向同一份数据。
  static const String recordsTabQuery = 'tab';
  static const String recordsTabRecords = 'records';
  static const String recordsTabWrong = 'wrong';
  static const String recordsTabFavorites = 'favorites';

  // ---------- 考试页的页签 ----------
  // 「试卷库」与「我的考试」是同一个页面的两个页签，用查询参数指定初始页签，
  // 与 /records?tab=wrong 同一套做法。
  static const String examsTabQuery = 'tab';
  static const String examsTabLibrary = 'library';
  static const String examsTabMine = 'mine';

  // ---------- 带参路径拼接 ----------
  static String questionDetailOf(String questionId) => '/bank/$questionId';

  static String examAttemptOf(String attemptId) => '/exams/attempt/$attemptId';

  static String examResultOf(String attemptId) =>
      '/exams/attempt/$attemptId/result';

  static String examsOf(String tab) => '$examsPath?$examsTabQuery=$tab';

  static String practiceOf(String sessionId) => '/practice/$sessionId';

  static String materialViewOf(String materialId) => '/materials/$materialId';

  static String practiceResultOf(String sessionId) => '/practice/$sessionId/result';

  static String sessionReviewOf(String sessionId) => '/practice/$sessionId/review';

  static String recordsOf(String tab) => '$recordsPath?$recordsTabQuery=$tab';

  /// 底部导航展示顺序（与 app_shell 的 tab 顺序一致）。
  static const List<String> shellPaths = [
    homePath,
    bankPath,
    aiPath,
    recordsPath,
    profilePath,
  ];
}
