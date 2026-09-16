// 宽窄屏分界：两处布局要按同一个数切换（应用外壳的导航、练习页的答题卡），
// 所以从 AppShell 上提到 ui/core —— feature 之间不能互相 import（AGENTS.md 分层）。
//
// 取 900 而不是常见的 768：宽屏侧栏本身占 232px，768 宽的窗口扣掉侧栏后
// 内容区只剩 536px，三列统计卡这类布局会开始挤。

const double kWideBreakpoint = 900;
