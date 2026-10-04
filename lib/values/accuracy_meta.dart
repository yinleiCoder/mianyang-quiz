// 错误率与「易错题」的判定线。**与网页端 supabase 仓库的 lib/accuracy.js 同源** ——
// 改一处必须改另一处，否则同一个学生看到的两端会各标各的。
//
// 两套口径，判据同一条线，只是分母不同：
//   · 全站口径：question_accuracy 的 (attempts, correct) —— 题库、练习复盘用它；
//   · 卷内口径：paper_question_stats 的 (graded, correct_rate) —— 考试/讲评用它，
//     样本量取「判过分的人数」。
//
// ⚠️ 与 values/filter_meta 无关；也**不要**拿它去判知识点掌握度（那是 kWeakNodeAccuracy）。

/// 错误率高于此值按「易错题」高亮。
const double kHighErrorRate = 0.6;

/// 易错题的最小样本量：错误率再高，2 个人做过、1 个人错了也叫「50%」，
/// 标成易错只会把真正该讲的题挤下去（2026-09-30 定的口径，与班级页
/// 「最该讲的题」、学情告警同源）。
const int kMinAttemptsHighError = 5;

/// 易错判定。errorRate 传 null（没有作答数据）时恒为 false ——
/// 「0 次作答」不等于「错误率 0%」，也不等于易错（与网页端同一条规矩）。
bool isHighError({required num? errorRate, required num sample}) {
  final rate = errorRate;
  if (rate == null) return false;
  return sample >= kMinAttemptsHighError && rate >= kHighErrorRate;
}

/// 全站口径：attempts = 作答次数，correct = 答对次数。
bool isEasilyWrong({required int attempts, required int correct}) =>
    attempts > 0 && isHighError(errorRate: 1 - correct / attempts, sample: attempts);

/// 全站错答**人次**（= 作答次数 − 答对次数）。
///
/// 注意它既不是「错过这道题的人数」，也不是「我」的错误次数 ——
/// 个人的那个是 WrongQuestion.wrongCount（错题本 RPC 给的），两者别混用。
int wrongAttempts({required int attempts, required int correct}) {
  final wrong = attempts - correct;
  return wrong < 0 ? 0 : wrong;
}

/// 掌握度（知识点 / 个人）的关注线。**故意与 kHighErrorRate 不同**：
/// 单个知识点往往跨很多题、混着易题和难题，天然要比单题宽松。
/// 网页端 lib/analytics.js 的 accuracyBarColor 是同一层意思（分档 0.5 / 0.75）。
const double kWeakNodeAccuracy = 0.6;
