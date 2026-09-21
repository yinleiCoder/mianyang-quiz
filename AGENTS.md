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
   页面直接读仓储（`data/repositories/`）与跨页状态（`state/` 的 `*Store`）。
   官方 skill `flutter-apply-architecture-best-practices` 的核心指令就是实现 MVVM，
   **与本条冲突，不要安装它**。

3. **组件必须拆。** 单文件 ≤200 行、单文件一个 public class（sealed union 家族除外）。
   这不是自觉问题——`tool/check_architecture.dart` 会强制，提交前跑它。

4. **写操作一律走 RPC。** 客户端对数据库的表**只有 SELECT 权限**（RLS + revoke）。
   任何 INSERT/UPDATE/DELETE 都必须通过 `supabase.rpc(...)` 调 SECURITY DEFINER 函数。

5. **配置不入库。** `config/dev.json`（`--dart-define-from-file` 注入）已在 `.gitignore`；
   模板是 `config/dev.example.json`。新增配置项要同步改 `lib/core/config/env.dart` 与模板。
   OSS 的 AccessKey/Bucket/Endpoint **只存在于网页端服务端**，客户端永远不内嵌。

---

## 二、分层与依赖方向

```
ui/features/**  →  ui/core/**  state/**  data/repositories/**  core/**  data/models/**
state/**        →  data/repositories/**  data/models/**  core/error
data/repos/**   →  data/services/**  data/models/**  core/network  core/error
domain/**       →  只依赖 Dart 核心库（**不 import Flutter**，必须可独立单测）
core/**         →  零业务，不 import 任何上层
```

跨 feature 复用**必须**上提到 `ui/core/` 或 `state/`——`ui/features/a/` 不准 import `ui/features/b/`。
这条最容易被违反，也是上个版本练习页涨到 1379 行的原因。

`core/network/supabase_client.dart` 是唯一持有 `SupabaseClient` 的地方，由 `bootstrap.dart` 注入、
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

所以主题里显式定义了 `SemanticColors`（`core/theme/semantic_colors.dart`），
用 `context.semantic.success / successContainer / warning` 取色。
组件一律从主题取色，**不要在组件里写死颜色**——主题是唯一该写死颜色的地方。

---

## 三、目录职责速查

| 目录 | 放什么 | 判定标准 |
|---|---|---|
| `core/` | 配置、主题、路由、网络、纯工具 | 与业务无关，换个 App 也能用 |
| `domain/` | 判分、作答编解码、标签映射 | 纯函数，不 import Flutter |
| `data/models/` | freezed 数据模型 | 对应一次网络请求/响应 |
| `data/repositories/` | 查询与 RPC 封装 | 只做「查询 + 模型转换」，不写业务规则 |
| `state/` | 跨页面 `ChangeNotifier` | **会被 ≥2 个页面写**的状态 |
| `ui/core/` | 共享组件 | 被 ≥2 个 feature 用；参数只能是数据与回调 |
| `ui/features/<f>/` | 页面 + 该页私有组件、私有状态机 | 只被本 feature 用 |

判断一个组件该放哪：**把它复制到第二个页面时，你愿不愿意改它的名字？**
不愿意 → `ui/core`；愿意（"这是练习页的进度条"）→ 留在 feature 内。

`ui/core` 的组件里不允许出现 `sessionId`/`runner`/`store` 这类参数——出现即说明它属于某个 feature。

---

## 四、踩过的坑（都是实测，不是推测）

### 判分镜像
- `grade_answer` / `norm_answer_text` 对客户端角色 **revoke**，调不到，必须本地镜像（`lib/domain/answer_grader.dart`）。
- **本地的判分只用于抢先显示**；`submit_practice_answer` 返回的 `is_correct` 是权威，回来要覆盖。
- **不能直接用 `RegExp(r'\s')` 做归一化。** Dart 走 ECMAScript 规则，与 PostgreSQL 的 `[[:space:]]`
  互不包含：Dart 多匹配 U+FEFF，少匹配 U+001C–U+001F 与 U+0085。
  实测本库命中 29 个码位，已在代码里写成显式集合。重测方法见 `answer_grader.dart` 注释。
- **多选比的是排序后的数组，不是集合**：`['A','A'] ≠ ['A']`。用 Set 实现会比服务端宽松，
  表现为"先闪答对、提交后判错"。
- 改动判分逻辑前，先重跑 `test/domain/answer_grader_test.dart`；那里的期望值全部取自真实数据库函数。

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
这条口径两端各有一份、必须一致：客户端 `core/constants/material_meta.dart` 的
`opensInline`，网页端 `lib/materials.js` 的 `INLINE_KINDS`。
PDF 用 **pdfrx**（PDFium）：**不要改用 WebView** —— Android 的系统 WebView 没有内置
PDF 阅读器，拿它开 PDF 在手机上只会白屏。

**PDF 阅读器在 Windows 上要开发者模式**：pdfrx 用符号链接装 PDFium 的 native assets，
构建机会直接报错并给出开启指引（本机已开）。

**「保存到本地」两端不是一个动作**：Windows 写系统下载目录；Android **没有**等价写法
（`getDownloadsDirectory()` 在 Android 抛 UnsupportedError，写应用外部目录 Android 11+
对其他应用不可见，`file_selector` 的 `getSaveLocation()` 官方支持表里 Android 是 ❌），
所以走系统分享面板。见 `data/services/material_download_service.dart` 文件头。

**入口在首页工作台，不做底部导航的第 6 个 tab**：底部导航已经 5 个（Material 的上限），
与考试放首页是同一个判断。

**下载次数只在真的「保存到本地」时 +1**，打开查看不计数——老师看的是"这份资料被拿走了几次"，
混进浏览数就没意义了。

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
flutter test                           # 全绿
dart run tool/check_architecture.dart  # 架构约束
```

三条都过才算完成。**不要**用 `flutter analyze` 通过就当作完成——测试里锁着判分契约。

改动涉及界面时，另外在 Windows 桌面端跑一遍 `flutter run -d windows`，
并用 1280×800 窗口逐页检查（屏幕适配的坑只在这里暴露）。

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

跑完在 GitHub Releases 上得到两个资产，**名字固定不带版本号**（这样
`/releases/latest/download/<名字>` 永远指向最新版，产品页与客户端都能写死链接）：

- `mianyang_quiz-android.apk` —— Android 直接装（**必须已配正式签名**，见下）
- `mianyang_quiz-windows-x64.zip` —— 整个目录解压后运行

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

符号文件（`app.*.symbols` + `obfuscation-map.json`）只作为 Actions artifact 上传，**不进 Release**：
它们能反解混淆，公开挂出去等于白混淆。

**检查更新**（`lib/ui/features/shell/widgets/update_checker.dart`）读的就是上面那个 Release 的
`tag_name`，与本机 `Env.appVersion` 比大小（比较逻辑在 `lib/domain/app_version.dart`，纯函数可单测）。
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
