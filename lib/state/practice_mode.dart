// 练习的子模式。组卷页选择、练习页据此改变交互。
//
// 放 state/ 而不是练习 feature 内：组卷页（compose）与练习页（practice）都要用，
// 而跨 feature 引用被架构守卫禁止——这类"共享词汇"就该上提到 state/。

enum PracticeMode {
  /// 即时练习：选完立刻判题，**并就地给出标准答案与解析**（学生反馈要的就是这个）。
  /// 每题提交一次（服务端逐题判分），进度实时上报。
  ///
  /// **答对后默认 1 秒自动进下一题，可在开始练习页关掉**（PracticePrefsStore）；
  /// 答错停在原地等学生点「继续」。实现见 pages/practice/state/auto_advance.dart。
  /// （2026-10-12 曾改回一律手动，2026-10-24 恢复答对自动跳，2026-11-06 起可关。）
  instant('即时练习', '选完立刻出对错、标准答案与解析', 'instant'),

  /// 批量练习：先答完整卷再交卷。
  /// 答题过程中可自由翻页、改答案，交卷时才逐题提交。
  batch('批量练习', '答完再交卷，中途可回看与修改', 'batch'),

  /// 即时顺序练习（教师讲练）：按**题库列表的顺序**一题接一题地过（published_at 倒序，
  /// 见 0090 的 start_sequential_practice），不随机、不按遗忘曲线、也不跳过"今天已经练过的"。
  ///
  /// **不计入学习统计**：这一轮**不写 practice_answers**——错题本 / 正确率 / 遗忘曲线 /
  /// 今日已练 / 热力图全部派生自那张表，不写就等于自动不进任何统计。判定仍然即时
  /// （与 instant 同一条反馈链、同一套解析展示），只是结论用本地判分镜像，不回传服务端。
  /// 练习记录里会留一条，记录页按 scored 标「课堂讲练·不计分」。
  sequential('即时顺序练习', '按题库顺序连着过题、即时报对错；教师讲练用，不计入统计', 'sequential');

  const PracticeMode(this.label, this.description, this.wire);

  final String label;
  final String description;

  /// 存到服务端的线格式（practice_sessions.mode，见 0144）。
  /// 续练必须按它重开：批量练习不能被当成即时练习逐题提交，
  /// 顺序讲练更不能（0090 一个答案都不许提交）。
  final String wire;

  /// 是否在选中后立即判题。两种"即时"模式都算——顺序练习只是挑题与排序不同，
  /// 判题时机与反馈链跟即时练习完全一致。
  bool get gradesImmediately => this != PracticeMode.batch;

  /// 是否允许在未作答时自由跳到别的题。
  bool get allowsFreeNavigation => this == PracticeMode.batch;

  /// 这一轮是否计入学习统计（写 practice_answers）。
  ///
  /// false 时客户端**一次答案都不提交**：服务端那张表是整个学习统计的唯一来源，
  /// 不写就是干净（见 0090 的注释）。判定改由 utils/answer_grader.dart 的本地镜像给。
  bool get countsTowardStats => this != PracticeMode.sequential;
}

/// 线格式 → 枚举。认不出来返回 null（旧服务端没有 mode 字段时就是这样，
/// 调用方再按 scored / 路由兜底）。**不要**默认成 instant：
/// 那把一场批量练习续成即时练习，会把草稿当成已判定的作答逐题提交。
PracticeMode? practiceModeFromWire(String? wire) {
  for (final mode in PracticeMode.values) {
    if (mode.wire == wire) return mode;
  }
  return null;
}
