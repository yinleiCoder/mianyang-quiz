# mianyang_quiz — 开发约定

绵阳市中职共建题库的**刷题客户端**（Android / Windows），与仓库根的 Next.js 网页端共用同一个 Supabase 后端与阿里云 OSS。
网页端负责教师出题与两级审批；本客户端负责学生刷题、背题与学情。

后端契约（表结构、RPC 签名、判分规则）在网页端仓库的 `supabase/migrations/0028`–`0032`。
**那些 SQL 是唯一权威**，本客户端的一切行为都要与之对齐。

---

## 一、五条硬约束（违反即返工）

1. **一律 `import 'package:material_ui/material_ui.dart';`**
   绝对禁止 `package:flutter/material.dart`。
   Flutter 3.47 已把 Material 拆成独立包（SDK 自带迁移 fix：`fix_data/fix_material/fix_material.yaml`）。
   而 `go_router` 18 依赖的正是 `material_ui`，它靠 `findAncestorWidgetOfExactType<MaterialApp>()`
   判断自己是否在 MaterialApp 之下——两套 `MaterialApp` 是**不同的类**，根节点用错来源会让
   转场与 Hero 动画**静默消失**（不报错，只是没了）。

2. **不使用 MVVM。** 不建 `view_models/`、不写 `XxxViewModel`、不配 Presenter 层。
   页面直接读仓储（`apis/`）与跨页状态（`state/` 的 `*Store`）。
   官方 skill `flutter-apply-architecture-best-practices` 的核心指令就是实现 MVVM，
   **与本条冲突，不要安装它**。

3. **组件必须拆。** 单文件 ≤200 行、单文件一个 public class（sealed union 家族除外）。
   这不是自觉问题——`tool/check_architecture.dart` 会强制，提交前跑它。

4. **写操作一律走 RPC。** 客户端对数据库的表**只有 SELECT 权限**（RLS + revoke）。
   任何 INSERT/UPDATE/DELETE 都必须通过 `supabase.rpc(...)` 调 SECURITY DEFINER 函数。

5. **配置不入库。** `config/dev.json`（`--dart-define-from-file` 注入）已在 `.gitignore`；
   模板是 `config/dev.example.json`。新增配置项要同步改 `lib/values/env.dart` 与模板。
   OSS 的 AccessKey/Bucket/Endpoint **只存在于网页端服务端**，客户端永远不内嵌。

---

## 二、分层与依赖方向

八个顶层目录，自下而上（下层不认识上层）：

```
values/   ← 主题、常量、配置、文案：谁都能用，它谁也不依赖
entity/   ↔ 数据模型（freezed）
utils/    ← 纯 Dart：判分镜像、作答编解码、格式化、异常映射
apis/     ← 仓储、服务、网络设施
state/    ← 跨页 Store
widgets/  ← 共享组件（只"喂数据"，不自己取数）
pages/    ← 页面 + 各模块私有组件、私有状态机
router/   ← 路由表与路径常量
```

`entity/` 与 `utils/` 是**互相**依赖的（模型用 `formatters`，判分用 `SubjectNode`）——
这是重构前就存在的结构，不必强行拆开。除此之外依赖方向一律单向。

跨模块复用**必须**上提到 `widgets/` 或 `state/`——`pages/a/` 不准 import `pages/b/`。
这条最容易被违反，也是上个版本练习页涨到 1379 行的原因，由 `tool/check_architecture.dart` 强制。

`dependencies.dart` 是唯一持有 `SupabaseClient` 的地方，由 `bootstrap.dart` 注入、
仓储通过构造函数接收。**不允许仓储里写 `Supabase.instance.client`**，否则测试无法替换。

---

## 二·五、字体与颜色（中文场景的两条硬约束）

### 只用 400 与 700 两种字重

中文字体（微软雅黑、Noto Sans CJK、苹方…）**普遍只提供 Regular(400) 与 Bold(700)**。
写 `w500/w600/w800` 不会报错，但引擎会**合成伪粗体**——而合成结果在不同字号、
不同字形上并不一致。表现是"有的标题很粗、有的该粗却发虚"，肉眼极难归因。

由 `tool/check_architecture.dart` 强制：`FontWeight` 只允许 `w400` / `w700`。

### 「对/错」必须用语义色，不能用 tertiary

M3 的 `ColorScheme` **没有「成功」这个角色**。拿 `tertiary` 顶替是个很隐蔽的坑：
`ColorScheme.fromSeed` 派生的 tertiary 是**色相旋转**的结果，deepPurple 种子派生出的
tertiary 是**粉红色**，与表示错误的 `error`（红）几乎同色——用户根本分不出答对答错。
代码读起来却完全通顺（"没有成功色就用第三色"）。

所以主题里显式定义了 `SemanticColors`（`values/semantic_colors.dart`），
用 `context.semantic.success / successContainer / warning` 取色。
组件一律从主题取色，**不要在组件里写死颜色**——主题是唯一该写死颜色的地方。

---

## 二·六、桶（barrel）导出

八个顶层目录各有一个与目录同名的桶文件（`widgets/widgets.dart`、`entity/entity.dart` …）。
写法跟随 Flutter SDK 自己的桶（`material_ui` 包的 `lib/material_ui.dart` 就是
`library material_ui;` + 一串 `export`），所以是**具名**库声明，不是匿名 `library;`。
`analysis_options.yaml` 为此关掉了 `unnecessary_library_name`，别把它又打开。

```dart
library widgets;

export 'duo_button.dart';
export 'duo_card.dart';
```

**引用规则：**

| 场景 | 写法 |
|---|---|
| 跨目录引用 | 走桶：`import 'package:mianyang_quiz/widgets/widgets.dart';` |
| 同目录内部 | 精确到文件：`import 'package:mianyang_quiz/pages/practice/state/practice_runner.dart';` |
| 目标不在桶的导出范围内 | 精确到文件（生成物、模块私有组件） |

同目录内部不写桶，是为了让"谁依赖谁"在 import 行上看得见——
`analysis_options.yaml` 把 `unused_import` 设为 error，靠的正是这一点。
同理，**桶只能省掉"跨目录"的噪音，不能拿来省同目录的路径**。

两条边界，改桶时别踩：

- **生成物不能 export**。`*.g.dart` / `*.freezed.dart` 是 `part` 文件、不是库，
  写进 `export` 直接编译失败，所以生成桶的脚本要按后缀排除。
- **`pages/pages.dart` 只导出各模块顶层的文件**（页面与流程入口），
  `pages/<模块>/widgets/` 与 `state/` 下的东西**刻意不导出**：既避免跨模块误用，
  也避免不同模块的同名组件撞车（`auth/` 与 `profile/` 各有一个 `SchoolPickerField`）。
  测试要用模块私有组件时，写精确路径即可。

---

## 三、目录职责速查

| 目录 | 放什么 | 判定标准 |
|---|---|---|
| `values/` | 主题、颜色、字阶、中文字案与标签映射、编译期配置 | 与业务无关的**名词**；谁都能用，它谁也不依赖 |
| `entity/` | freezed 数据模型 | 对应一次网络请求/响应 |
| `utils/` | 判分、作答编解码、格式化、异常、URL 合成 | 纯函数，**不 import Flutter**，必须可独立单测 |
| `apis/` | 查询与 RPC 封装、服务、网络设施 | 只做「查询 + 模型转换」，不写业务规则 |
| `state/` | 跨页面 `ChangeNotifier` | **会被 ≥2 个页面写**的状态 |
| `widgets/` | 共享组件 | 被 ≥2 个模块用；参数只能是数据与回调 |
| `pages/<模块>/` | 页面 + 该页私有组件、私有状态机 | 只被本模块用 |
| `router/` | 路由表与路径常量 | 唯一认识全部页面的地方 |

判断一个组件该放哪：**把它复制到第二个页面时，你愿不愿意改它的名字？**
不愿意 → `widgets/`；愿意（"这是练习页的进度条"）→ 留在 `pages/<模块>/` 内。

`widgets/` 的组件里不允许出现 `sessionId`/`runner`/`store` 这类参数——出现即说明它属于某个模块。

模块名与后端概念对齐（`bank` 题库 / `practice` 刷题 / `exam` 考试 / `compose` 组卷 /
`records` 记录 / `materials` 资料 / `analytics` 学情 / `auth` / `profile` / `home` /
`shell` 主壳 / `ai` 答疑），新增模块照此起名。

**`test/` 与 `lib/` 同构**：`test/pages/<模块>/` 放该模块页面与其私有组件/状态机的测试，
其余按被测文件在 lib 里的归属落到 `test/{widgets,values,utils,entity,apis,state}/`。
判断依据是**被测的那个文件在 lib 的哪**，不是测试自己长什么样——
比如 `semantic_color_pairing_test.dart` 渲染的是组件，但它验的是语义色配对，所以进 `test/values/`。
测试文件不被任何东西 import，搬迁零成本，放错就尽早挪。

---

## 四、踩过的坑（都是实测，不是推测）

### 判分镜像
- `grade_answer` / `norm_answer_text` 对客户端角色 **revoke**，调不到，必须本地镜像（`lib/utils/answer_grader.dart`）。
- **本地的判分只用于抢先显示**；`submit_practice_answer` 返回的 `is_correct` 是权威，回来要覆盖。
- **不能直接用 `RegExp(r'\s')` 做归一化。** Dart 走 ECMAScript 规则，与 PostgreSQL 的 `[[:space:]]`
  互不包含：Dart 多匹配 U+FEFF，少匹配 U+001C–U+001F 与 U+0085。
  实测本库命中 29 个码位，已在代码里写成显式集合。重测方法见 `answer_grader.dart` 注释。
- **多选比的是排序后的数组，不是集合**：`['A','A'] ≠ ['A']`。用 Set 实现会比服务端宽松，
  表现为"先闪答对、提交后判错"。
- 改动判分逻辑前，先重跑 `test/utils/answer_grader_test.dart`；那里的期望值全部取自真实数据库函数。

### 背题模式
**背题不能开会话。** `start_practice_session` 会写 `practice_sessions` 一行（练习记录页正是读这张表），
还会**静默作废**用户正在进行中的刷题会话。背题 = 纯 PostgREST 查询 + 本地翻题，全程不调 practice RPC。

### 选项乱序
乱序后用户看到的 "A" 可能是原始 "C"。**提交只认原始 key**。
乱序结果在生成单题运行时**算一次并物化**，不能在 `build()` 里算（否则每次 rebuild 重排、点击位置跳动）。

### 屏幕适配（已经踩过一次真机才暴露的坑）
`flutter_screenutil` 按宽度线性缩放。桌面端必须关掉，否则 1280 宽的窗口按 390 的设计宽度
算出 3.3 倍，`.sp(16)` 变成 52px，**界面直接炸掉**。

**关缩放只能通过 `ScreenUtilInit` 的同名参数，不能只在 bootstrap 里调 `ScreenUtil.enableScale`：**

```dart
ScreenUtilInit(
  enableScaleWH: screenScaleEnabled,    // ← 必须传
  enableScaleText: screenScaleEnabled,  // ← 必须传
  ...
)
```

原因：`ScreenUtilInit` 初始化时会执行
`ScreenUtil.enableScale(enableWH: widget.enableScaleWH, ...)`，
而 `enableScale` 对 null 的处理是 `?? () => true` —— 不传参数就等于**主动把缩放打开**，
把 bootstrap 里设过的值覆盖掉。

这个坑的教训不止于此：当初判断"ScreenUtilInit 没有这两个参数"，是因为
`grep` 的文件名写成了 `screen_util_init.dart`（正确是 `screenutil_init.dart`），
**又加了 `2>/dev/null`**，于是"文件不存在"被静默吞掉，我把空输出读成了"参数不存在"。
**查证依赖时不要吞 stderr**——它会把"我没找到"变成"它不存在"。

所有页面内容还要套 `MaxWidthBox` 居中。**每个页面都要在真机窗口下过一遍**，
widget 测试断言不了"字是不是大得离谱"。

### Android release
`INTERNET` 权限只在模板的 debug/profile manifest 里，已手工补进 `android/app/src/main/AndroidManifest.xml`。
漏掉它的表现是：**release 包所有网络请求失败，而 debug 下完全正常**。

**签名**：`android/app/build.gradle.kts` 在 `android/key.properties` 不存在时会
**静默回退到 debug 签名**。debug 签名的包能装能跑、看不出任何异常，但**签名会随构建机变**——
下一版就盖不上去（Android 要求同包名同签名），用户只能卸载重装。所以流水线在打 tag 时
缺密钥直接失败，构建完还有一步 `apksigner` 回头看产物上的章（见第七节）。

### 数据库侧的坑
- `start_practice_session` 会自动作废旧 active 会话（每人同时至多一套）。进组卷页前先看
  `practice_dashboard().active_session`，非空要问「继续练习 / 重新开始（当前进度将作废）」。
- **抽题按遗忘曲线落闸（0069）：当天练过的题，当天不再发。** 分四层
  （新题 → 到期复习 → 今天之前练过的最久没练的补位 → 今天练过的），
  第四层只在 `p_allow_same_day=true` 时才进得来。池子干了**不报错**，返回
  `status='nothing_due'` + `next_due_at`，客户端据此弹「今天的题都练完了」面板，
  上面那个「仍然加练」就是带开关再调一次。所以
  `PracticeRepository.startSession` 返的是 `StartPracticeOutcome` 两种结局，
  不是快照——**别再写回 `PracticeSessionSnapshot`**。
  另外：`p_allow_same_day` 是新参数，函数签名从 8 参变成 9 参，
  改这个函数时必须 `drop` 旧签名，否则两个重载并存，PostgREST 解析 RPC 直接报歧义。
- **"当天"的日界一律用 `practice_day_start()`（北京时间）**，不要用库里的
  `date_trunc('day', now())` —— 库的时区是 **UTC**，它的"今天"从北京时间早上 8 点起算，
  7 点早自习练的题会被算成昨天。（看板那几个函数还在用 UTC 日界，是同一类问题的另一处。）
- 复合题的 `submit_practice_answer` 返回 `correct_answer` 是 **null**——答案在 `content.sub[].answer`，
  顶层没有。答案展示组件必须逐子题渲染。
- `update_own_profile` 的 `p_avatar_url` 默认 null 且写库时 `nullif(trim())`：
  **只改名不传头像会清空头像**。封装方法必须始终带上当前 `avatar_url`。
- `accuracy` 分母不一致：`finish_practice_session` 用总题数，`practice_dashboard` 用已答数。
- 题库列表查询**必须带外键 hint** `questions!question_versions_question_id_fkey`——
  questions ↔ question_versions 是双外键，不带会 300 崩溃。

### 复习资料（0070）

**与题库媒体是两套东西，别混。** 资料的 OSS 前缀是 `materials/`（`lib/media-spec.js` 的
`PURPOSES.material`），落库在 `review_materials`；`media_objects` 那张表绑在题目版本上
（`version_media` 引用计数 GC），资料不挂版本，硬塞进去语义不通。`register_media`
还硬拒非 `qbank/` 前缀，根本登记不进去。

**删除必须走 `/api/materials/delete`，客户端只传 id。** 不要照抄 `/api/oss/delete`
（头像那条）——它的模型是"key 从浏览器传进来"，而它自己的注释就承认了残余风险。
资料这条是**服务端调 RPC 判归属拿到 key、再删 OSS**，key 全程不出服务端。
顺序是**先删行、后删对象**：反过来一旦 OSS 删成功而行没删掉，学生点开就是坏链；
现在最坏只留个孤儿对象。

**只有 PDF 与图片能在应用内看**，其余（Office / 音视频）一律交给系统程序。
这条口径两端各有一份、必须一致：客户端 `values/material_meta.dart` 的
`opensInline`，网页端 `lib/materials.js` 的 `INLINE_KINDS`。
PDF 用 **pdfrx**（PDFium）：**不要改用 WebView** —— Android 的系统 WebView 没有内置
PDF 阅读器，拿它开 PDF 在手机上只会白屏。

**PDF 阅读器在 Windows 上要开发者模式**：pdfrx 用符号链接装 PDFium 的 native assets，
构建机会直接报错并给出开启指引（本机已开）。

**pdfrx 在构建时要从 GitHub Releases 下 PDFium 预编译包**（`bblanchon/pdfium-binaries`，
每个平台-架构一个 `.tgz`，Android 三个 ABI 各几 MB）。这条路国内经常超时，
报错长这样：

```
PDFium download failed (ClientException ... github.com ...); retrying in 1s.
Target build_hooks failed: Error: Building native assets failed.
```

`-> 过不去时**先把包下好放进缓存**`，构建钩子见文件已存在就跳过下载：

```
.dart_tool/hooks_runner/shared/pdfium_dart/build/chromium_7811/<平台>-<架构>/<库名>
   Windows: win-x64/pdfium.dll        （包内路径 bin/pdfium.dll）
   Android: android-{arm,arm64,x64}/libpdfium.so（包内路径 lib/libpdfium.so，三个 ABI 都要）
   macOS:   mac-<arch>/libpdfium.dylib / Linux: linux-<arch>/libpdfium.so
```

CI（GitHub Actions）能直连 GitHub，不需要这一步。

**「保存到本地」两端不是一个动作**：Windows 写系统下载目录；Android **没有**等价写法
（`getDownloadsDirectory()` 在 Android 抛 UnsupportedError，写应用外部目录 Android 11+
对其他应用不可见，`file_selector` 的 `getSaveLocation()` 官方支持表里 Android 是 ❌），
所以走系统分享面板。见 `apis/material_download_service.dart` 文件头。

**入口在首页工作台，不做底部导航的第 6 个 tab**：底部导航已经 5 个（Material 的上限），
与考试放首页是同一个判断。

**下载次数只在真的「保存到本地」时 +1**，打开查看不计数——老师看的是"这份资料被拿走了几次"，
混进浏览数就没意义了。

**资料的文档档是 2GB，与题干附件不是同一档**：`lib/media-spec.js` 里
`material_document`（资料，2GB）与 `document`（题干附件，200MB）并存，`MATERIAL_TYPES`
把文档类的 mime 重映射到前者。**别把它们合并**——给一道题挂 2GB 附件没有意义。
客户端这边的影响：下载要能扛住 GB 级文件（`material_download_service.dart` 是流式落盘、
且已下过且大小一致就复用，不会整份读进内存）。

### 代码生成
- `build.yaml` 里的 `explicit_to_json: true` **不能删**，否则嵌套对象会被原样塞进 `toJson()`。
- freezed 的 union 判别键写法（已验证可用）：`@Freezed(unionKey: 't')` + `@FreezedUnionValue('text')`。
- JSON 模型用 classic 写法（`abstract class X with _$X` + `factory X.fromJson`），
  不要用主构造器语法——与 json_serializable 的组合没有官方示例。
- 生成物（`*.g.dart` / `*.freezed.dart`）不要手改，也不参与架构检查。

---

## 五、每次改完必须验证

```bash
flutter analyze                        # 零 error
flutter test                           # 全绿（只扫 test/）
dart run tool/check_architecture.dart  # 架构约束（只扫 lib/）
```

三条都过才算完成。**不要**用 `flutter analyze` 通过就当作完成——测试里锁着判分契约。

改动涉及界面时，另外在 Windows 桌面端跑一遍 `flutter run -d windows`，
并用 1280×800 窗口逐页检查（屏幕适配的坑只在这里暴露）。

改动涉及**插件、平台通道、系统字体、真实网络**时，再跑一遍集成测试
（见五·二）——那些东西 widget 测试一概证明不了。

---

## 五·二、三类测试怎么分工、放哪、怎么跑

| 类型 | 目录 | 跑法 | 证明什么 |
|---|---|---|---|
| 单元测试 | `test/{apis,entity,utils,values,state}/` | `flutter test` | 纯函数与编解码对不对 |
| 组件测试 | `test/pages/<模块>/`、`test/widgets/` | `flutter test` | 某个页面/组件渲染与交互对不对 |
| 集成测试 | `integration_test/` | `flutter test integration_test -d windows` | **这个包在这台设备上能不能跑起来** |

三条硬规矩：

1. **`flutter test` 只扫 `test/`**，永远不会碰到 `integration_test/`；
   而两者**不能在同一个 `flutter test` 调用里混跑**，工具会直接报错。分开跑。
2. **`test/` 与 `lib/` 同构**：测试放哪，看**被测文件在 lib 的哪**，
   不看测试自己长什么样。判据与目录表见第三节。
3. **集成测试下的 HTTP 是真的**。`IntegrationTestWidgetsFlutterBinding`
   的 `overrideHttpClient` 是 `false`——widget 测试那套「client 指向假地址、
   让 flutter_test 拦掉请求」的写法在这里会变成真去解析域名。
   所以拿不到后端时，集成测试要么只验不依赖数据的路径，要么把依赖注入成假实现。

### ⚠ Windows 上必须**一个文件一次**地跑（实测，且可复现）

官方文档给的整目录写法 `flutter test integration_test` 在 Windows 桌面端**跑不通**：
第一个文件通过，第二个开始必定失败——

```
Error waiting for a debug connection: The log reader stopped unexpectedly, or never started.
Failed to load "...performance_test.dart": Unable to start the app on the device.
```

2026-09-28 复现过两次，两次都是"第 1 个过、第 2 与第 3 个起不来"，
且第二次没有重新构建（不是构建占着 exe 不放），是**第二个 app 实例起不来/附加不上**。
三个文件**单独跑都全绿**，所以不是测试本身的问题。

```bash
# 对的：逐个文件
for f in integration_test/*_test.dart; do
  flutter test "$f" -d windows || exit 1
done

# 错的：整目录（Windows 上第二个必挂）
flutter test integration_test -d windows
```

CI 如果要在 Windows 上跑集成测试，也得按这个循环写。

### 真实账号的端到端测试

`integration_test/live_backend_test.dart`（**只读**）与 `practice_flow_test.dart`（**写库**）
打的是**真实后端**，凭据从 `config/test.local.json` 注入（已被 `.gitignore` 忽略，
模板见 `config/test.example.json`）。**凭据绝不进仓库**，没配就 skip，不会红。

```bash
flutter test integration_test/live_backend_test.dart -d windows \
  --dart-define-from-file=config/dev.json \
  --dart-define-from-file=config/test.local.json
```

写路径那条默认**不跑**（`"TEST_WRITE": true` 才跑）——它会建会话、写作答，
按 0069 还会消耗掉该账号当天的题池，并且**静默作废该账号进行中的会话**。

写这两条时踩到的坑，全是真机才暴露的。**先看这条最值钱的**：

> 超时信息里会自动带上**屏幕上当前的所有文字**（`screenText`）。
> 「是卡在转圈、还是落了错误态、还是文案跟预期不一样」一眼可辨。
> 这条机制抓出的问题比下面所有坑加起来还多——写 UI 集成测试先把它做出来。

**生命周期**

1. **别在用例里 `addTearDown(deps.dispose())`**。`MianyangQuizApp.dispose()` 自己就会
   释放依赖（见 `app.dart`），再释放一次会在 teardown 里抛
   「A AuthStore was used after being disposed.」——**报在 teardown**，
   看上去像用例本体挂了，极难归因。谁创建谁释放。
2. **写库的用例要把收尾放进 `addTearDown`**，别写在用例末尾。中途一失败，
   末尾那行就永远不会执行，于是每失败一次就往库里留一个"进行中的会话"——
   下一次进来弹「上次的练习还没做完」，走另一个分支，越跑越乱。

**等待**

3. **不能 `pumpAndSettle`**。加载态是无限动画，它会一直等到超时（默认 10 分钟）。
   用 `waitFor`：一边 `pump` 一边让**真实时间**流过（网络是真的，假时钟等不到）。
4. **不能等页面靠后的内容**。`ListView` 是懒构建的，视口外的子项根本没被创建。
   首页要等就等**第一项**「你好，xxx」（既在视口内，又只在数据回来后存在）。
5. **`launchAndLogin` 只等到主壳，不等于首页数据到了**。紧接着去点首页上的按钮
   会报 "could not find any matching widgets"——得先等学情加载完。

**找元素**

6. **组卷页的 AppBar 标题也叫「开始练习」**（`compose_page.dart:65`），
   而按钮叫「开始练习（最多 N 题）」。用 `textContaining('开始练习')` 会先匹配到标题，
   点上去毫无反应。**finder 要带左括号**，并限定在 `ComposePage` 子树内
   （首页那颗「开始一次练习」还挂在树里，IndexedStack 不销毁已访问的分支）。
7. 组卷页底部那颗按钮**在首屏之外时根本没被创建**，`find` 找不到、`ensureVisible`
   也没用（那个要求先有 element）。只能真的往下 `drag` 到它出现（见 `_scrollToStartButton`）。
8. **弹窗有入场动画**。`waitForAny` 一看到文字就返回，那时按钮还没落位，
   直接 `tap` 会点空。先 `pump(600ms)` 再点，而且点 `DuoButton` 本身而不是里面的 `Text`。

**流程本身的分支**（写死一种必红）

9. 点了「开始练习」有**三种**结局：进练习页 / 弹「上次的练习还没做完」/ 弹「今天的题都练完了」。
10. **走「继续上次的练习」时，当前题可能已经是判过的**（服务端把判定一并恢复回来），
    那这题一进来就带着反馈条，根本没有「检查」可点。
11. **即时练习是「选完立刻出对错」**（组卷页自己的原话）——选择题一点选项就提交了，
    「检查」在那一刻就消失了。**「检查」只留给填空/主观这类需要显式提交的题型。**
    所以选完之后要两种都接住：已判 → 直接等反馈条；未判 → 再点「检查」。

### 取性能数据（帧耗时基线）

`binding.watchPerformance(...)` 采到的 `reportData` **只有 `flutter drive` 会取走**，
`flutter test` 只回传通过/失败——所以量性能必须走 drive：

```bash
flutter drive \
  --driver=test_driver/perf_driver.dart \
  --target=integration_test/performance_test.dart \
  --profile
```

产出 `build/<reportKey>_summary.json`：average / 90th / 99th / worst 的帧构建
与光栅耗时、超预算帧数。**看 99th 与 worst**——平均值好看而 worst 很差，
说明有偶发的重布局，那才是用户感觉到的卡。`--profile` 不能省，
debug 下的数字官方明说不代表用户体感。

### 性能这一块，**不要**做这几件事（都是在浪费时间）

官方文档（Flutter 3.47）已经把话说死了，逐条记下来免得下次又想加：

- **Impeller 不用管**。Android（API 29+）与 Windows 从 3.47 起都**默认开启**，
  没有 `--enable-impeller` 这种开关（只有 opt-out，且文档说将来会移除）。
- **不要加 SkSL / shader 预热**。那套 `--bundle-sksl-path` / `FlutterShaderWarmUp`
  的文档**已经 404 下线**，Impeller 在引擎构建期就把 shader 编好了。
- **不要满屏撒 `RepaintBoundary`**。官方原话是「只在需要时」——
  光栅缓存本身构建很贵还吃显存。本仓目前 0 处，是正确的状态。
- **不要给 Widget 重写 `operator ==`**。看着像能省重建，实际是 O(N²)。
- **不要反射性地用短命 isolate**。`Isolate.run` 每次都要重新孵化 + 拷贝对象；
  重复性的活儿应该用**常驻** isolate。判断标准是「这一步是否超过帧间隔」，
  而且要**先量再决定**——本仓 PDF 生成实测约 190ms（首次）/ 65ms（缓存后），
  是一次性动作、不在滚动路径上，所以**没有**下放 isolate，这是量过之后的结论。

已确认**不需要**动的（都核对过）：`Opacity` / `ShaderMask` / `ColorFilter` /
`BackdropFilter` / `ImageFilter` / `Clip.antiAliasWithSaveLayer` 全库 0 处；
列表该懒加载的都懒加载了；首页用 `context.select` 而不是 `watch`。

---

## 六、运行

```bash
cp config/dev.example.json config/dev.json   # 填入真实配置
flutter run -d windows --dart-define-from-file=config/dev.json
```

配置项：`SUPABASE_URL` / `SUPABASE_ANON_KEY`（取值见网页端 `.env.local`，key 是 `sb_publishable_…` 格式）
/ `OSS_PUBLIC_HOST` / `API_BASE_URL` / `SHARE_BASE_URL`。

---

## 七、发布（Windows）

发布配置与开发配置只差站点地址（都要指向线上），另存一份带 `.local` 的文件即可
（`.gitignore` 只忽略 `config/dev.json` 与 `config/*.local.json`）：

```bash
cp config/dev.example.json config/prod.local.json   # 把 API_BASE_URL / SHARE_BASE_URL 改成 https://myquiz.cn
```

混淆构建（`--obfuscate` 与 `--split-debug-info` **必须成对给**，只给前者会报错）：

```bash
flutter build windows --release \
  --obfuscate \
  --split-debug-info=symbols/windows \
  --extra-gen-snapshot-options=--save-obfuscation-map=symbols/windows/obfuscation-map.json \
  --dart-define-from-file=config/prod.local.json
```

**产物与分发**：整包在 `build\windows\x64\runner\Release\`，**必须整个目录一起发**——
exe 只是入口，同目录下的全部 `.dll`（`flutter_windows.dll` + 各插件）与 `data\` 缺一不可。
目标机器还需要 MSVC 运行时（`msvcp140.dll` / `vcruntime140.dll` / `vcruntime140_1.dll`）：
Release 目录里没有就装 Microsoft Visual C++ Redistributable，或把这三个 dll 拷进同目录。
分发形态三选一：zip 整包（最省事）、MSIX（`msix` pub 包）、传统安装器（Inno Setup / WiX）。

**调试符号别丢**：`symbols/windows/` 下的 `app.windows-x64.symbols` 与 `obfuscation-map.json`
是反解混淆堆栈的唯一凭据（`.gitignore` 已忽略，需另行归档，每个发布版本一份）。
实测本项目的 Windows 构建给的就是 `.symbols`，`flutter symbolize -i <trace> -d <symbols>` 直接认
（官方文档说 Windows x64 出 PDB、那种要用 WinDbg——按实际拿到的文件类型选工具）。

**混淆的边界**（官方文档明说）：它只把符号名改成不可读的名字，**不加密资源、也挡不住逆向**，
依赖类名/函数名的代码（如 `runtimeType.toString()`）会失效，枚举名不混淆。
所以密码、密钥一律不许进客户端——本仓的 OSS/AI 密钥都在服务端（见第一条硬约束）。

### 发布流水线与检查更新

打一个 tag 就出包（**客户端仓库**里的 `.github/workflows/release.yml` —— 网页端仓库只把本目录记成
一个 gitlink，工作流放那边构建不了）：

```bash
git tag v1.0.1 && git push origin v1.0.1
```

跑完在 GitHub Releases 上得到几个资产，**名字固定不带版本号**（这样
`/releases/latest/download/<名字>` 永远指向最新版，产品页与客户端都能写死链接）：

- `mianyang_quiz-android.apk` —— Android 直接装（**必须已配正式签名**，见下）
- `mianyang_quiz-windows-x64.zip` —— 整个目录解压后运行

### Android 按 ABI 拆包（2026-09-28 起）

CI 用的是 `flutter build apk --split-per-abi`，出三份而不是一个通用包。
不拆的话一个 84MB 的包里塞着 arm64-v8a / armeabi-v7a / x86_64 **三套原生库**
（Flutter engine、PDFium、各插件），其中两份对任何一台机器都是死重量。

**固定名与 ABI 的映射是刻意的，改之前先想清楚：**

| 资产名 | ABI | 给谁 |
|---|---|---|
| `mianyang_quiz-android.apk` | **arm64-v8a** | **真机**——下载页的固定链接指向它 |
| `mianyang_quiz-android-armv7.apk` | armeabi-v7a | 32 位老设备 |
| `mianyang_quiz-android-x86_64.apk` | x86_64 | 模拟器 |

固定名一旦指错 ABI，用户拿到的是**装不上的包**——报错就一句「应用未安装」，
不告诉任何人「你该下另一个文件」。所以 release job 里对三份资产都有
`[ -s ... ]` 的存在性断言，少一份直接失败，不会发出一个「老设备点进去 404」的版本。

**换 ABI 覆盖安装会失败**：Android 不允许换 ABI 覆盖安装，从通用包转成分包、
或从 armv7 换到 arm64，都要先卸载（和换签名是同一类问题，见下面那段警告）。

### Android 正式签名（一次性配好）

**没配 `ANDROID_KEYSTORE_BASE64` 时，打 tag 会直接失败**（这是刻意的：debug 签名的包
签名会变，老用户下一版就装不上，而这种包外表看不出任何异常）。

```powershell
# 1) 生成密钥库（只做一次）。口令与别名自己定，务必存进密码管理器。
keytool -genkeypair -v -keystore mianyang-quiz-release.jks `
  -keyalg RSA -keysize 2048 -validity 10950 -alias mianyang `
  -dname "CN=Mianyang Quiz, OU=Dev, O=Mianyang, L=Mianyang, ST=Sichuan, C=CN"

# 2) 转成 base64（-Encoding ascii 单行输出；**不要带换行**，否则 CI 解码出来是坏文件）
[Convert]::ToBase64String([IO.File]::ReadAllBytes("mianyang-quiz-release.jks")) |
  Set-Content -Encoding ascii mianyang-quiz-release.jks.b64
```

把 `.jks` 与 `.b64` **离线备份两份**（换机器、重装都会用到；`*.jks` 已被 `.gitignore` 忽略）。
然后在 GitHub 仓库 Settings → Secrets and variables → Actions 里加四个 secret：

| secret | 取值 |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | 第 2 步那个 `.b64` 文件的全部内容 |
| `ANDROID_KEYSTORE_PASSWORD` | 第 1 步的 `storePassword` |
| `ANDROID_KEY_ALIAS` | `mianyang` |
| `ANDROID_KEY_PASSWORD` | 第 1 步的 `keyPassword` |

流水线在配置签名后会先 `keytool -list` 验一遍密钥库与别名（base64 传坏了、别名写错了
都在这一步就停），构建完再用 `apksigner verify --print-certs` **回头看产物**——
只要证书里出现 `Android Debug` 就判失败。

> **已经装过 debug 签名版本的用户，换正式签名后必须先卸载再装。** Android 不允许
> 换签名覆盖安装。发布说明里要写清楚，否则那批用户会卡在「应用未安装」。

### Windows 构建机要装 NuGet

`flutter_inappwebview` 的 Windows 端在**构建期**用 NuGet 拉三个包
（WIL / WebView2 SDK / nlohmann.json），插件 CMake 走 `find_program(NUGET nuget)`：

```powershell
winget install Microsoft.NuGet        # 或 choco install nuget.commandline
```

漏了它的报错是 `NUGET-NOTFOUND`。工作流里已显式补了一步。另外构建需要能访问
nuget.org（拉包），以及 `CL=/utf-8`（中文 Windows 上 C++ 源码会触发 C4819，见第四节）。

**还有一个编译开关必须加，否则构建必挂**（与语言环境无关，CI 也一样）：

```powershell
$env:CL = "/utf-8 /D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS"
```

`flutter_inappwebview` 的 Windows 端固定拉 **WIL 1.0.231216.1**（2023-12），它还在
`include <experimental/coroutine>`；而 **VS 2022 17.14（MSVC 14.51）起那个头文件直接当错误报**：

```
error C2338: static assertion failed: 'error STL1011: The /await compiler option,
<experimental/coroutine>, ... are deprecated by Microsoft and will be REMOVED SOON.
```

微软给的抑制宏就是上面那个 `_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS`。
插件在 pub cache 里、不能直接改，所以只能从这里注入。**注意这只是个有期限的续命**——
那个头文件"将被移除"，将来得等插件升 WIL 或改用 C++20 `<coroutine>`。

### Android：flutter_inappwebview 必须用 6.2 的 beta（AGP 9 不兼容稳定版）

稳定版 `flutter_inappwebview_android` **1.1.3** 自己的 `build.gradle` 第 44/48 行用了
`getDefaultProguardFile('proguard-android.txt')`，而 **AGP 9.0 起这个写法直接报错**
（它带 `-dontoptimize`，会挡住 R8 优化）：

```
A problem occurred evaluating project ':flutter_inappwebview_android'.
> `getDefaultProguardFile('proguard-android.txt')` is no longer supported ...
```

报错发生在**求值插件自己的 build.gradle 时**，插件在 pub cache 里改不动。

**已经试过、无效的路（别再走一遍）**：在 `android/gradle.properties` 里设
`android.r8.proguardAndroidTxt.disallowed=false`（以及发布说明里那个串了行的
`android.r8.globalOptionsInConsumerRules.disallowed=false`）。两个都设上、也确实推到了
CI，**报错一字不变**——这个逃生口在 AGP 9.1 上已经不起作用。

**正解是升到 `flutter_inappwebview: ^6.2.0-beta.3`**：作者自己的前向修复，
改用 `proguard-android-optimize.txt`，并且 `compileSdk` 跟随 Flutter 而不钉死 34。
两个平台都已验证通过（Android `assembleRelease` 出包 84.4MB、Windows release 构建通过）。
（那个 84.4MB 是**拆 ABI 之前**的通用包体积；现已改成 `--split-per-abi`，见第七节。）

**别回退到 6.1.5** —— 它 23 个月没更新且编译不过，"留在稳定版"在这里不是更安全的选择。
等 6.2.0 转正（`^6.2.0-beta.3` 会自动升上去）再确认一次即可。

**这一条与混淆无关**：`--obfuscate` 改的是 Dart 符号名，而报错来自插件 Java 侧的
R8 规则文件，是构建链上不同的两步。关掉混淆解决不了它。

### 本地在 Windows 上构建 Android：Kotlin 增量缓存写不进去

```
Execution failed for task ':audioplayers_android:compileReleaseKotlin'.
> Could not close incremental caches in ...\build\<模块>\kotlin\compileReleaseKotlin\
  cacheable\caches-jvm\jvm\kotlin: class-fq-name-to-source.tab, ...
```

**Windows 特有**（Kotlin 2.4 的 Build Tools API 写 .tab 表时撞上文件锁，多半是杀软实时扫描）。
清缓存、杀 Gradle 与 Kotlin 守护进程都试过，重建后照样复现。
解法是在 **用户级** `~/.gradle/gradle.properties` 里加：

```properties
kotlin.incremental=false
```

**不要写进仓库**——CI 的 Android job 跑在 ubuntu-latest，没这个问题，
写进去只会让 CI 的 Kotlin 编译变成全量、白白变慢。

符号文件（`app.*.symbols` + `obfuscation-map.json`）只作为 Actions artifact 上传，**不进 Release**：
它们能反解混淆，公开挂出去等于白混淆。

**检查更新**（`lib/pages/shell/widgets/update_checker.dart`）读的就是上面那个 Release 的
`tag_name`，与本机 `Env.appVersion` 比大小（比较逻辑在 `lib/utils/app_version.dart`，纯函数可单测）。
所以 `APP_VERSION` 由流水线按 tag 注入 —— 两边同源才不会误报。调试构建（`kDebugMode`）与
`APP_VERSION` 带 `-` 的包不检查；同一个版本「稍后再说」过就不再弹。

### 应用图标

品牌的唯一源是 `assets/mianyang.svg`；喂给构建的是它渲染出来的 `assets/app_icon.png`
（1024×1024、透明底、四周留 10% 边距——贴边的图形在 16px 的任务栏上会糊成一团）。
换图标 = 换这两张图，然后：

```bash
dart run flutter_launcher_icons    # 重新生成 windows 的 .ico 与 android 五档 mipmap
```

生成物（`windows\runner\resources\app_icon.ico`、`android\app\src\main\res\mipmap-*\ic_launcher.png`）
**不要手改**，它们下次生成时会被覆盖。
SVG → PNG 这一步是**离线**做的（与网页端 favicon 同例，不往仓库塞生成脚本）：
headless Chrome 打开一个把 `<img>` 撑满的 html 截图即可，
`--default-background-color=00000000` 保住透明底、`--window-size=1024,1024` 定尺寸。

---

## 八、深度链接与分享链接

题目分享链接形如 `https://myquiz.cn/bank/<uuid>`（拼法与识别见 `values/share_links.dart`，
站点域名取 `SHARE_BASE_URL`）。让它在 App 里打开有**两条路，且两条并存**：

| 机制 | 覆盖平台 | 触发方式 | 状态 |
|---|---|---|---|
| **剪贴板识别** | Android **+ Windows** | 复制链接 → 切回 App → 弹窗问「要打开看看吗」 | **已实现**（`pages/shell/widgets/clipboard_link_listener.dart`） |
| **Android App Links** | 仅 Android | 在浏览器/聊天里**直接点**链接 | App 侧已配，**还差网页端一个文件** |

### 剪贴板那条（为什么它是主力）

只在**回到前台**时读一次剪贴板（`AppLifecycleState.resumed`），不做轮询——
轮询既费电，又会在用户还在别的 app 里时就抢注意力。
同一条内容只弹一次，但**重新复制会再弹**（重新复制往往就是想再打开一次）。
隐私边界：只读、只在本地比对，不外传不落库；"上次看过什么"存在 shared_preferences 里。

**它是 Windows 上唯一的机制**：官方文档明说深度链接只覆盖 iOS / Android / Web，
桌面端一个字都没提。所以别把剪贴板这条路当成"App Links 的临时替代"删掉——
删了 Windows 用户就彻底没法从链接进题。

### Android App Links（`android/app/src/main/AndroidManifest.xml`）

`<activity>` 里那段 `<intent-filter android:autoVerify="true">`。两个刻意的取舍：

- **只认 `/bank/` 前缀**（官方示例不带 `pathPrefix`，等于接管整个域名）。
  myquiz.cn 上还有网页端自己的页面，整站接管会把那些链接也抢进 App，
  而 App 里根本没有对应路由，点开就是空白页。
- **只声明 https**：分享链接拼出来的就是 https，没必要把 http 那条老路放进来。

Flutter 3.27 起深度链接**默认开启**，不需要 `flutter_deeplinking_enabled` 这个 meta-data
（本仓 3.47）。**go_router 也不用接线**：路由表里 `/bank/:questionId` 已经存在，
框架把进来的 URI 交给 `MaterialApp.router`，go_router 自己就匹配上了。

### ⚠ 还差什么：网页端的 assetlinks.json

Android 会用 `autoVerify` 去 `https://myquiz.cn/.well-known/assetlinks.json` 核对签名指纹，
**核对通过才会自动打开 App**。没有那个文件 = 验证失败 = 链接照旧走浏览器
（不会出错，但也享受不到）。

那个文件归**网页端仓库**管，内容长这样：

```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.quiz.mianyang_quiz",
    "sha256_cert_fingerprints": ["<见下>"]
  }
}]
```

必须放在 `public/.well-known/assetlinks.json`（Next.js 的 public 直接映射到站点根，
**且 `.well-known` 要能直接访问、不能被重定向**）。

**指纹从哪来**：不用翻 keystore——发布流水线跑完会打印它：

```
===== 正式签名证书 SHA-256（粘进 assetlinks.json 的 sha256_cert_fingerprints）=====
Signer #1 certificate SHA-256 digest: AB:CD:...
```

证书指纹是公开信息（它本来就挂在公网上给人核对），打进日志不泄密。
本地调试包用的是另一把 debug keystore，指纹不同；要本地验的话
用 `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android`
再取一条，数组里可以放多个指纹。

### 怎么测

**adb 那条命令测不出网页端配没配对**——官方原话：就算 assetlinks.json 不存在，
这条命令也照样能把 App 拉起来。它只验"App 这边认不认这个链接"：

```bash
flutter run    # 先跑一次，确保 App 已安装
adb shell 'am start -a android.intent.action.VIEW \
    -c android.intent.category.BROWSABLE \
    -d "https://myquiz.cn/bank/<uuid>"' \
    com.quiz.mianyang_quiz
```

要验**端到端**（网页端 + 签名指纹都对），只能拿真链接点：
从浏览器地址栏、或从聊天里发一条给自己点开。改过 manifest 之后**必须重装**，
intent-filter 是装机时登记的。

DevTools 的 **Deep Links** 页（验证深度链接）能扫 manifest 与配置给出问题提示，
但它**不检查网页端那个文件**。

---

## 九、错误处理与崩溃上报

### 两层，别混

| 哪一类 | 走什么 | 用户看到 | 上报？ |
|---|---|---|---|
| **预期内的失败**（网络断、会话过期、服务端拒绝） | `AppException` → `error_mapper` → `AsyncView` | 一句中文提示 + 重试 | **不上报** |
| **没人接住的**（build 里抛的、异步漏 catch 的） | `lib/error_handling.dart` 的三个钩子 | 那块内容变成一句「没能显示出来」 | 上报 |

第二类**不该**去上报第一类。网络抖动是常态，报上去只会把真正没见过的问题淹掉——
上报的价值全在"没见过的那种"。

### 三个钩子，装在哪、什么顺序

全在 `lib/error_handling.dart`，由 `main.dart` 在 `runApp` **之前**调用：

1. `FlutterError.onError` —— 框架在 build / layout / paint 里捕获的
2. `PlatformDispatcher.instance.onError` —— 当前 zone 里没人处理的异步错误
3. `ErrorWidget.builder` —— 某棵子树构建失败时**画什么**

**顺序是硬要求**：`installErrorHandling()` 必须排在 `CrashReporter.init()` **前面**。
Sentry 的那两个 integration 是**链式**的（先捕获，再调用原来那个 handler），
它装的时候会把我们的函数存下来。顺序反了它就存不到，钩子被顶掉。

**钩子里绝不能再调 Sentry**，否则同一条错误上报两次——Sentry 自己已经捕获过了。

### 几条从官方文档里挖出来的硬事实

- **`runZonedGuarded` 已经从文档里彻底消失**（0 处出现，英文原站也一样），
  没有弃用通知，直接被 `PlatformDispatcher.instance.onError` 取代。
  别再去包那个 zone。
- `PlatformDispatcher.instance.onError` **返回 `true` 才是"我处理了"**。
  返回 `false` 会让引擎走它的兜底路径，在 release 里可能直接终止进程——
  用户看到"闪退"，而我们连一行日志都留不下。
- **`ErrorWidget.builder` 必须做尽可能少的事**。官方 API 文档原话：它被调用时
  "系统通常处于不稳定状态……框架本身（尤其是 BuildOwner）可能已经混乱，
  很可能再抛异常"，建议返回一个 `LeafRenderObjectWidget`。
  **指南页里那个 `Scaffold(body: Center(...))` 的示例与这条相矛盾**，以 API 文档为准。
  本仓的兜底只用 widgets 层最基础的东西，且在测试里**故意不给任何祖先**
  （没有 MaterialApp / Theme / Directionality / MediaQuery）验证它照样画得出来。
- **那一堆常见的渲染报错（RenderFlex 溢出、unbounded height、setState during build）
  都是 `assert` 包着的，正式包里根本不存在。** 别为它们写去重/降噪逻辑
  （它们在 release 里到不了钩子），也别拿它们去验上报是否生效——
  debug 下有、release 下没有，看起来就像"上报坏了"。
  本仓那 5 条历史遗留失败正属于这一类，**修，不要"接住"**。
- 文档对**混淆只字未提**。本仓是 `--obfuscate --split-debug-info` 构建的，
  不上传符号，Sentry 里的堆栈就是一堆 `a.b.c` —— 见下面那条 CI 步骤。

### 隐私：学生数据不出境

`lib/apis/crash_reporter.dart` 里显式关掉了这些（SDK 默认大多是关的，**但 `enablePrintBreadcrumbs` 默认是开的**）：

| 选项 | 为什么关 |
|---|---|
| `attachScreenshot` | 截图里有题干正文与学生的真实姓名 |
| `attachViewHierarchy` | 视图树里同样有 |
| `enablePrintBreadcrumbs` | **默认开**，会把这个项目所有 `debugPrint`（启动失败详情、题目 id）收成面包屑 |
| `sendDefaultPii` | 关掉身份信息 |

显式写出来而不"靠默认值"，是为了防止有人顺手打开看看效果——这是未成年学生的数据。

**没配 `SENTRY_DSN` 就整个是空操作**：不初始化 SDK、不建 HTTP 客户端、什么都不发。
开发机与 CI 都不配它。

### 网络：本项目实测到 sentry.io **是通的**（但别当成永久事实）

曾经担心的事没有发生。2026-09-28 在本机实测（`o496762.ingest.us.sentry.io`）：

| 检查 | 结果 |
|---|---|
| DNS | 正常解析 |
| TLS 握手 | **0.3s** |
| 投一个真实 event | **HTTP 200**，Sentry 返回了它分配的 event id |

所以上报在这台机器上是可用的。定位仍然是**尽力而为**：SDK 的传输层自己吞异常，
上游再兜一层，发不出去就发不出去，**绝不影响任何功能**。

留个心眼：本仓已经因为"境外域名不通且调用没超时"踩过一次——PDF 中文字体原先从
`fonts.gstatic.com` 拉，点「打印」既不报错也不出对话框，师生的感受就是"按钮没反应"
（2026-09-17）。**客户端所在网络与开发机不是一回事**，学校机房可能是另一番景象。
要真依赖它，先在目标网络上实测。

### 上线前还差一步（DSN 已经有了）

1. **`SENTRY_DSN`** —— 项目已建好，值在维护者的密码管理器里；
   **本地开发放进 `config/dev.json`（已被 gitignore），CI 放进仓库 Secrets**。
   仓库里任何被跟踪的文件都不该出现它（已核对）。
2. **`SENTRY_AUTH_TOKEN`** —— 还要去 Sentry 生成一个，加到仓库 Secrets，
   用于让流水线把符号传到 Sentry。不配会跳过（不报错），
   但 Sentry 里的堆栈会是混淆后的名字。

两者都是"不配照常发版"——不该因为上报没配好就发不出包。

**验一遍接线**（改完 Sentry 相关代码后值得跑一次）：

```bash
flutter test <任意测试> --dart-define=SENTRY_DSN=<dsn>
# 在测试里断言 CrashReporter.enabled == true
```

`flutter analyze` 与 `flutter test`（不带 DSN）**测不出**接线对不对——
不带 DSN 时它按设计就是关的，全绿什么也不说明。

### 怎么测

```bash
flutter test test/utils/error_handling_test.dart
```

覆盖：三个钩子装上了、钩子自己不会抛、异步钩子返回 `true`、
正式包的兜底在没有主题/方向/MediaQuery 的环境下能画出来且不泄露异常内容。

**注意 `FlutterError.onError` 是全局静态**，测试里必须 save/restore，
否则会污染后面所有测试（本仓的测试已经这么做了）。

### ⚠⚠ `sentry_flutter` 必须用 10.x（9.x 与 8.x 各废掉一个平台）

`pubspec.yaml` 里是 `sentry_flutter: 10.0.0-rc.1`。**不要回退到 9.x 或 8.x。**

这是按官方文档选的：`sentry` 包自己的 README 就写着「For Flutter consider
sentry_flutter instead」，而 `sentry_flutter` 多给原生崩溃捕获（Android 的
Java/Kotlin/C/C++）、release health、离线缓存、以及自动挂 Flutter 错误钩子。
纯 Dart 的 `sentry` 我们在 2026-09-29 试过一轮，能用但**丢掉原生捕获**，不值。

前面两个稳定版各自编不出一个平台：

| 版本 | Windows | Android | 原因 |
|---|---|---|---|
| 9.30.1 | ✗ | ✓ | 精确锁 `jni: 0.14.2`，那个版本的 `jni.h` 用 MSVC 不认的 `__attribute__` |
| 8.14.2 | ✓ | ✗ | AGP 7.4.2 / compileSdk 34 / `languageVersion "1.6"`，与 Kotlin 2.4 + AGP 9.1 全对不上 |
| **10.0.0-rc.1** | ✓ | ✓ | jni 放开成 `>=1.0.0 <1.1.0`、compileSdk 36、删掉 languageVersion |

**9.x 的坑特别隐蔽**：本项目 `path_provider_android` 本来就把 `jni` 拉到 **1.0.3**
（已修 MSVC），**是 sentry_flutter 9.x 把它降级回坏版本的**。所以别只看
「谁依赖 jni」，要看**谁把它钉在旧版本**。

**抬 jni 版本修不通**（试过）：`jni` 1.0.3 补了 `__declspec(dllexport)` 能过 C 编译，
但 **1.0 同时破坏性改了 Dart API**，sentry_flutter 9.x 的
`lib/src/native/java/*.dart` 是按 0.14.2 写的，于是 `JList.array`、`nullableType`、
`JObjType` 全找不到。0.15.x 又仍然只有 `__attribute__`——**两头堵死**。

**10.0.0-rc.1 是 RC**：等 10.0.0 转正后把约束换成 `^10.0.0` 即可。
升完之后 **`flutter build apk --release` 与 `flutter build windows` 各跑一次**
——`flutter analyze` 与 `flutter test` 这些问题**一个都测不出来**。

### minSdk 被抬到 26，是 sentry_flutter 逼的

`android/app/build.gradle.kts` 里是 `minSdk = maxOf(flutter.minSdkVersion, 26)`。
Flutter 默认 24，而 sentry_flutter 10.x 的 AAR 声明了 minSdk 26，
manifest 合并直接失败：

```
uses-sdk:minSdkVersion 24 cannot be smaller than version 26 declared in library [:sentry_flutter]
```

它给的另一条出路 `tools:overrideLibrary` **不要走**——官方注释自己写着
"may lead to runtime failures"，那是强行合并，库确实可能调了 24 上没有的 API。
**代价：不再支持 Android 7.x 及以下**（API 26 = Android 8.0，2017 年）。

### ⚠️ 别在 `android/` 下新建 `build.gradle`（Groovy）

**踩过一次，而且症状极具误导性。**

`android/build.gradle.kts` 里有一段把构建产物重定向到仓库根 `build/` 的逻辑
（`rootProject.layout.buildDirectory.value(newBuildDir)`）。
**Groovy 与 Kotlin DSL 的根构建脚本同时存在时，Gradle 用 `.gradle`，把 `.kts`
整个遮蔽掉**——重定向随之失效，产物全落到 `android/app/build/`，于是：

```
Gradle build failed to produce an .apk file. It's likely that this file was
generated under <项目>\build, but the tool couldn't find it.
```

**构建其实是成功的**，只是产物在错的地方，报错完全指不到真正的原因。
`.gitignore` 里加了一条 `/android/app/build/` 做兜底（正常情况下它根本不该出现；
一旦出现，就是有人又建了 `build.gradle`）。

顺带一个同源的教训：我当初判断"这个文件是空的"，用的是
`cat android/build.gradle 2>/dev/null`——**`2>/dev/null` 把"文件不存在"吞成了空输出**，
我把"没找到"读成了"是空的"（第四节里已经记过这条，这次又踩了一遍）。
**查文件在不在，用 `ls` 或 `git ls-files`，不要用被吞了 stderr 的 `cat`。**

---

## 十、首页的遗忘曲线（2026-09-29 才接上）

### 后端早就在算，客户端一直没接

`practice_dashboard` 的 `forgetting_curve` 字段是**迁移 0067** 加的，做法是
`pg_get_functiondef` + 定点替换（那个迁移刻意没重抄整个函数体）。
它把每一次作答按「距上次练同一道题的间隔天数」分桶，统计该桶答对率 ——
**这条下降的线就是学生自己的保持率**。

**客户端直到 2026-09-29 才把它读出来**（`entity/forgetting_curve.dart` +
`pages/home/widgets/forgetting_curve_card.dart`）。在那之前它一直白白下发着。
**加首页数据前先翻一眼 `practice_dashboard` 的返回**，别重复造。

理论曲线（艾宾浩斯）**不进数据库** —— 0067 写明「它是常量，画在图里即可」，
实现在 `utils/forgetting_curve.dart`，纯函数、可单测。

### 门槛是拿线上数据标定的，不是拍脑袋

每个点要求 **≥3 次作答**（`ForgettingBucket.isReliable`），
而**桶数只要 ≥2**。这个组合是查出来的：

| 门槛 | 能看到图的学生 |
|---|---|
| 每桶≥3次 且 ≥3桶 | 12 / 116（**10%**） |
| 每桶≥3次 且 **≥2桶** | **36 / 116（31%）** ← 采用 |
| 每桶≥2次 且 ≥2桶 | 46 / 116（40%） |

**线上 7 / 14 / 30 天那三档整库都没有数据** —— 0069 的「当天不重复」刚上不久，
学生还没练到那些间隔。所以现在画出来多半只有前几档，这是**数据成熟度**问题，
会随练习量自己变好，不要去"修"它。

同理，只有 2 个可信桶时会额外显示一句「形状还看不出来」——
两个点连成的直线不是曲线，不说清楚学生会当成"我的遗忘曲线就长这样"。

### 图注不是客套话

理论线用的是艾宾浩斯**无意义音节**的经典数据（1 天只剩 33%），而这里练的是有内容的
专业课题目，**实测线几乎必然在上方**。不写清楚，学生只会得出"我比艾宾浩斯强"这个
没有信息量的结论。要看的是**形状**：哪一档掉得特别狠，那一档的复习间隔就该缩短。

对应地，服务端调度用的是**离散阶梯**（0059：连对次数 → 1/2/4/7/15/30 天），
不是连续曲线 —— 所以这张图也能反过来校验那个阶梯对学生是不是太激进。
