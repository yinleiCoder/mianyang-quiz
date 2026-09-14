// 难度元数据：数据库里是 smallint 1/2/3（1 易 / 2 中 / 3 难）。
//
// 不定义枚举而用常量 + 查表函数：难度的取值域是**有界的整数**，
// 而且筛选参数直接以 int 传给 RPC（p_difficulty smallint）。
// 引入枚举反而要在边界上反复转换，收益为负。

/// 可选难度值，顺序即界面上的展示顺序。
const List<int> kDifficultyValues = [1, 2, 3];

const int kDefaultDifficulty = 2;

const Map<int, String> _labels = {1: '易', 2: '中', 3: '难'};

/// 难度中文名。未知值原样返回字符串（不崩、不猜）。
String difficultyLabel(int? value) {
  if (value == null) return '';
  return _labels[value] ?? '$value';
}

/// 界面上的文字色用例：易=绿、中=橙、难=红，由主题色板派生，不写死颜色。
/// 返回 M3 语义角色名，由调用方从 colorScheme 取实际颜色。
enum DifficultyTone { easy, medium, hard }

DifficultyTone difficultyTone(int? value) => switch (value) {
  1 => DifficultyTone.easy,
  3 => DifficultyTone.hard,
  _ => DifficultyTone.medium,
};
