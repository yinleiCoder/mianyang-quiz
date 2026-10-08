# 绵阳市中职共建题库 · 客户端

[myquiz.cn](https://myquiz.cn)

![绵阳市中职共建题库刷题软件](./docs/网站.png)

学生用的刷题客户端（Flutter，Windows / Android）。服务端在仓库根目录的 Next.js 应用里。

## 运行

```powershell
flutter pub get
cp config/dev.example.json config/dev.json          # 第一次：填上真实配置（配置不入库）
$env:CL = "/utf-8 /D_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS"
flutter run -d windows --dart-define-from-file=config/dev.json
```

Android 把 `-d windows` 换成设备号（`flutter devices` 看有哪些）：

```powershell
flutter run -d <设备号> --dart-define-from-file=config/dev.json
```

**两处容易踩的**：

- **`$env:CL` 那一行不能省，且必须从 PowerShell 设。** 中文 Windows 上插件的 C++ 源码是 UTF-8，
  MSVC 默认按 936 代码页解释会报 C4819，而插件的工程把警告当错误；`/D_SILENCE_...` 那个宏也必须给，
  否则 `flutter_inappwebview` 依赖的 WIL 头文件直接编译失败。
  （在 Git Bash 里写 `CL=/utf-8` 会被 MSYS 做路径转换，变成一个"打不开源文件"的假错误。）
- **配置不入库**：`config/dev.json` 与 `config/*.local.json` 都在 `.gitignore` 里。
  忘了配也不会白屏——App 会起一个提示页，列出缺哪几项（`lib/bootstrap.dart`）。

配置项：`SUPABASE_URL` / `SUPABASE_ANON_KEY`（`sb_publishable_…` 格式，取值与网页端 `.env.local` 一致）
/ `OSS_PUBLIC_HOST` / `API_BASE_URL` / `SHARE_BASE_URL`。

跑测试、发布 Windows 包（含混淆与分发）、以及三类测试的分工，见 `AGENTS.md` 第五、六、七节。
