// 练习的子模式。组卷页选择、练习页据此改变交互。
//
// 放 state/ 而不是练习 feature 内：组卷页（compose）与练习页（practice）都要用，
// 而跨 feature 引用被架构守卫禁止——这类"共享词汇"就该上提到 state/。

enum PracticeMode {
  /// 即时练习：选完立刻判题，答对可自动进入下一题。
  /// 每题提交一次（服务端逐题判分），进度实时上报。
  instant('即时练习', '选完立刻知道对错，答对自动下一题'),

  /// 批量练习：先答完整卷再交卷。
  /// 答题过程中可自由翻页、改答案，交卷时才逐题提交。
  batch('批量练习', '答完再交卷，中途可回看与修改');

  const PracticeMode(this.label, this.description);

  final String label;
  final String description;

  /// 是否在选中后立即判题。
  bool get gradesImmediately => this == PracticeMode.instant;

  /// 是否允许在未作答时自由跳到别的题。
  bool get allowsFreeNavigation => this == PracticeMode.batch;
}
