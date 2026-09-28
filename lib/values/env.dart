// 运行期配置：全部经 `--dart-define-from-file=config/dev.json` 注入。
//
// 职责：把编译期常量收敛到一处，并提供 isConfigured 供启动时校验。
// 不负责：任何业务默认值（分页大小之类放 app_config.dart）。
//
// 注意：这里只有**公开**信息。OSS 的 AccessKey/Bucket/Endpoint 只存在于网页端服务端，
// 客户端永远拿不到也不需要——上传走网页端的 /api/oss/sign 预签名接口。
abstract final class Env {
  /// Supabase 项目地址，形如 `https://<ref>.supabase.co`
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  /// Supabase 可发布密钥（sb_publishable_…）。对应 SDK 的 publishableKey 参数。
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// OSS 公网访问域名（CNAME），不带协议。媒体 URL 用它拼接。
  static const String ossPublicHost = String.fromEnvironment('OSS_PUBLIC_HOST');

  /// 网页端地址，仅用于 POST /api/oss/sign 取直传签名。
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  /// 分享链接的站点地址（题目详情页所在处），形如 `https://myquiz.cn`。
  ///
  /// **必须与 [apiBaseUrl] 分开配**：开发时 API_BASE_URL 指向本机 dev server
  ///（签名接口在那儿），但分享出去的链接要给**别人**打开——沿用本机地址就会出现
  /// 「分享出去的链接是 http://localhost:3000/…」。
  /// 没配时退回 API_BASE_URL（本地联调"分享→剪贴板→打开"这条链时正合适）。
  static const String shareBaseUrl = String.fromEnvironment(
    'SHARE_BASE_URL',
    defaultValue: apiBaseUrl,
  );

  /// 检查更新用的 GitHub 仓库（owner/repo）。发布流水线把安装包挂在它的 Releases 上，
  /// tag 就是版本号 —— 客户端拿它和 [appVersion] 比。留空则关闭检查更新。
  static const String updateRepo = String.fromEnvironment(
    'UPDATE_REPO',
    defaultValue: 'yinleiCoder/mianyang-quiz',
  );

  /// 客户端版本号，可选。只在意见反馈上报时随行带给管理员，
  /// 便于判断「这个问题出在哪个包」；缺失就是空串（不上报），不影响任何功能。
  static const String appVersion = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '',
  );

  /// 四项配置是否齐备。未配置时启动会停在提示页，而不是抛一堆网络异常。
  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// 缺哪几项（用于给开发者精确的提示文案）。
  static List<String> get missingKeys => [
    if (supabaseUrl.isEmpty) 'SUPABASE_URL',
    if (supabaseAnonKey.isEmpty) 'SUPABASE_ANON_KEY',
    if (ossPublicHost.isEmpty) 'OSS_PUBLIC_HOST',
  ];
}
