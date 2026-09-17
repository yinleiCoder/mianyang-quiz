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

  static const editProfilePath = '/profile/edit';
  static const editProfileName = 'editProfile';

  /// 意见反馈（联系系统管理员）：内容短，独立一页比弹窗更好写校验与错误态。
  static const feedbackPath = '/profile/feedback';
  static const feedbackName = 'feedback';

  // ---------- RecordsPage 的页签 ----------
  // 错题本与收藏**不是独立路由**，而是记录页的三个页签之一，
  // 用查询参数指定初始页签（/records?tab=wrong），避免两套入口指向同一份数据。
  static const String recordsTabQuery = 'tab';
  static const String recordsTabRecords = 'records';
  static const String recordsTabWrong = 'wrong';
  static const String recordsTabFavorites = 'favorites';

  // ---------- 带参路径拼接 ----------
  static String questionDetailOf(String questionId) => '/bank/$questionId';

  static String practiceOf(String sessionId) => '/practice/$sessionId';

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
