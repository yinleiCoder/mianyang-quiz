// 手机号 ↔「合成邮箱」的换算与校验。
//
// ⚠️ **本文件必须与网页端 `lib/phone.js` 逐条对齐。**
// 两边的换算规则只要有一点不同（域名拼错、国家码处理差一步），
// **同一个手机号会在网页和 App 落到两个不同账号上** —— 线上排查这种问题极费劲，
// 用户看到的是"我明明注册过却说没注册"。
// 网页端那份有 38 条测试钉着（仓库根 `scripts/test-phone.mjs`），
// 本文件下面的 `test/phone_test.dart` 是同一套用例的 Dart 版。**改一边必须改另一边。**
//
// 背景：学生记得住手机号，但很多人没有邮箱也记不住邮箱，所以手机号当账号名用。
//
// 为什么是"合成邮箱"而不是 Supabase 原生的 phone 认证：启用 Phone provider 必须
// 先配短信服务商（Twilio 等），而发往国内 +86 的短信要么到不了、要么需要企业资质与
// 签名模板审批。本项目没有短信服务商。详见 supabase/migrations/0064_phone_login.sql。
//
// 于是：学生输入 `13800138000`，实际存成 `13800138000@phone.myquiz.cn`。
//
// **一个账号只有一个标识符**：auth.users 的 email 字段只有一个，所以老用户
// （真实邮箱）无法"同时"再用手机号登录 —— 这是本方案的固有取舍，不是 bug。

/// 合成邮箱的域名。
/// **改动它会作废所有已注册的手机号账号**（它们是用旧域名存进 auth.users.email 的）。
const String phoneEmailDomain = 'phone.myquiz.cn';

/// 中国大陆手机号：1 开头，第二位 3–9，共 11 位。
final RegExp _cnMobile = RegExp(r'^1[3-9]\d{9}$');

/// 规范化成 11 位纯数字。合法返回号码，不合法返回 null。
///
/// 容忍常见写法：`138 0013 8000`、`138-0013-8000`、`+8613800138000`、`8613800138000`。
/// 返回 null 而不是抛错，是为了让调用方能给出"手机号格式不对"这种面向用户的提示。
String? normalizePhone(String? input) {
  if (input == null) return null;
  // 先去掉书写分隔符，再处理国家码
  var s = input.replaceAll(RegExp(r'[\s\-()]'), '');
  if (s.startsWith('+')) s = s.substring(1);
  // 只在"去掉 86 后正好是 11 位"时才当国家码剥掉，
  // 否则 8613800138000 这类和已带 86 的号码会被误伤
  if (s.startsWith('86') && s.length > 11) s = s.substring(2);
  return _cnMobile.hasMatch(s) ? s : null;
}

/// 11 位手机号 → 合成邮箱。传入非规范写法会先规范化；不合法返回 null。
String? phoneToEmail(String? phone) {
  final p = normalizePhone(phone);
  return p == null ? null : '$p@$phoneEmailDomain';
}

/// 合成邮箱 → 11 位手机号；不是合成邮箱（或不合法）则返回 null。
String? emailToPhone(String? email) {
  if (email == null) return null;
  final suffix = '@${phoneEmailDomain.toLowerCase()}';
  final lower = email.toLowerCase();
  if (!lower.endsWith(suffix)) return null;
  final local = email.substring(0, email.length - suffix.length);
  return _cnMobile.hasMatch(local) ? local : null;
}

/// 登录框的分流判据：**不含 `@` 就按手机号处理**。
///
/// 刻意不写成 `normalizePhone(input) != null`：那样的话用户把手机号少打一位，
/// 就会被当成邮箱去查，报出来的是"密码不正确"—— 驴唇不对马嘴。
/// 这里只判断"用户想走哪条路"，格式对不对交给 [normalizePhone] 单独报错。
bool looksLikePhone(String? input) => input != null && !input.contains('@');

/// 把登录框/注册框里的输入统一换算成要交给 Supabase 的 email。
///
/// 返回的 `phone` 非空表示这是个手机号账号（供落库到 profiles.phone）。
/// 输入既不像邮箱也不是合法手机号时两个字段都是 null。
({String? email, String? phone}) toAuthIdentifier(String? input) {
  final raw = (input ?? '').trim();
  if (raw.isEmpty) return (email: null, phone: null);

  if (looksLikePhone(raw)) {
    final phone = normalizePhone(raw);
    return phone == null
        ? (email: null, phone: null)
        : (email: phoneToEmail(phone), phone: phone);
  }
  return (email: raw.toLowerCase(), phone: null);
}

/// 展示用：`13800138000` → `138 0013 8000`。非手机号原样返回。
String formatPhone(String? input) {
  final p = normalizePhone(input);
  if (p == null) return input ?? '';
  return '${p.substring(0, 3)} ${p.substring(3, 7)} ${p.substring(7)}';
}

/// 邮箱的**展示值**：合成邮箱一律折叠成空串。
///
/// `13800138000@phone.myquiz.cn` 是实现细节，**不是用户拥有的邮箱**。
/// 直接印出来，用户会以为自己有个怪邮箱，还可能往那儿发信、或者以为账号出了问题。
/// 手机号用户没有邮箱，展示层就该显示「未绑定」。
String displayEmail(String? email) {
  if (email == null) return '';
  return emailToPhone(email) != null ? '' : email;
}

/// 账号的**单行**标识（紧凑列表用）：有手机号显示手机号，否则显示邮箱。
///
/// 注意它只显示一个 —— 个人资料页要**分开展示**手机号与邮箱两行，
/// 别拿这个函数去渲染资料页。
String displayIdentifier({String? phone, String? email}) {
  if (phone != null && phone.isNotEmpty) return formatPhone(phone);
  // 光有合成邮箱时（理论上不该出现：有合成邮箱就该有 profiles.phone），
  // 至少把它还原成手机号，别把假地址露出去
  final asPhone = emailToPhone(email);
  if (asPhone != null) return formatPhone(asPhone);
  return email ?? '';
}
