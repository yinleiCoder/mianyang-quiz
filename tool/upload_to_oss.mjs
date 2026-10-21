// 把发布产物推一份到阿里云 OSS（client/ 前缀），网页端 /download 与客户端检查更新
// 都只读这一份清单。
//
// **为什么要有这一步**：GitHub Releases 在国内基本取不到字节。2026-10-12 在绵阳实测：
// 直连 release 资产 20 秒 0 字节（HEAD 能过、正文取不到），同一时刻自家成都 OSS 7.2MB/s。
// 安装包挂在 GitHub 上、学生下不动，再好的客户端也装不上——所以每次发布都把全部产物
// （Windows 安装包/zip + Android 三个 ABI 的 apk）推到 OSS，网页端与客户端只认 OSS。
//
// 用法（发布流水线由 .github/workflows/release.yml 调用，也可以本机手动跑）：
//   OSS_ACCESS_KEY_ID=… OSS_ACCESS_KEY_SECRET=… \
//     node tool/upload_to_oss.mjs --dir build/oss-upload --tag v2.7.5 \
//     --public-base https://download.myquiz.cn/client
//
// **--public-base 可选**：阿里云禁止 .apk 从默认域名（*.aliyuncs.com）对外分发
// （实测回 400 ApkDownloadForbidden，正文让我们用 CNAME）。不传时仍会照常上传，
// 但 APK 的清单 url 写成 null；网页端与客户端会据此改走 gh-proxy
// （网页 NEXT_PUBLIC_GH_PROXY / 客户端 Env.ghProxy，默认 https://gh-proxy.com/）。
// 若将来给桶绑了自定义域名，用 --public-base 指向它即可让清单里的 url 优先走 OSS。
//
// 资产名**不带版本号**——网页端与客户端写死的就是这几个名字，版本号只写进
// client/latest.json（tag）与每个资产 url 的 ?v= 查询串（绕开 CDN 旧缓存）。
// 签名是 OSS V1（Authorization 头，HMAC-SHA1）。CanonicalizedResource 是
// "/<bucket>/<key>" 而请求路径只能是 "/<key>" —— 这两个字符串不一样，弄混就是
// SignatureDoesNotMatch（本仓在 lib/oss-sign.mjs 里已经踩过一次，这里照着那份写）。
import { createHash, createHmac } from 'node:crypto';
import { readFileSync, readdirSync, statSync } from 'node:fs';
import { basename, join } from 'node:path';

const BUCKET = process.env.OSS_BUCKET ?? 'mianyang-question-bank';
const ENDPOINT = process.env.OSS_ENDPOINT ?? 'oss-cn-chengdu.aliyuncs.com';
const PREFIX = 'client/';

const MIME = {
  '.apk': 'application/vnd.android.package-archive',
  '.exe': 'application/vnd.microsoft.portable-executable',
  '.zip': 'application/zip',
  '.json': 'application/json',
};

function arg(name, fallback = null) {
  const i = process.argv.indexOf(`--${name}`);
  return i >= 0 && process.argv[i + 1] ? process.argv[i + 1] : fallback;
}

const dir = arg('dir');
const tag = arg('tag');
if (!dir || !tag) {
  console.error('用法：node tool/upload_to_oss.mjs --dir <发布产物目录> --tag vX.Y.Z [--public-base https://<自定义域名>/client]');
  process.exit(1);
}

const { OSS_ACCESS_KEY_ID: id, OSS_ACCESS_KEY_SECRET: secret } = process.env;
if (!id || !secret) {
  console.error('缺少 OSS_ACCESS_KEY_ID / OSS_ACCESS_KEY_SECRET 环境变量');
  process.exit(1);
}

/** 规范化公共地址：去掉末尾斜杠；非法地址直接报错，别把坏 url 写进清单。 */
function normalizeBase(raw) {
  const u = new URL(raw);
  if (u.protocol !== 'https:') throw new Error('--public-base 必须是 https 地址');
  return `https://${u.host}${u.pathname.replace(/\/+$/, '')}`;
}

const defaultBase = `https://${BUCKET}.${ENDPOINT}/${PREFIX.replace(/\/$/, '')}`;
const publicBase = normalizeBase(arg('public-base', defaultBase));
const publicHost = new URL(publicBase).host;
// 阿里云默认域名不能分发 .apk；这个判断只影响清单里的 url，不影响上传本身。
const isDefaultAliyun = /\.aliyuncs\.com$/i.test(publicHost);

/** 一次 PUT。key 是相对 key（不含前导斜杠）。 */
async function putObject(key, body, contentType, cacheControl) {
  const date = new Date().toUTCString();
  // 参与签名的 Content-Type 必须与真正发出去的那个逐字一致
  const stringToSign = ['PUT', '', contentType, date, `/${BUCKET}/${key}`].join('\n');
  const signature = createHmac('sha1', secret).update(stringToSign).digest('base64');

  const res = await fetch(`https://${BUCKET}.${ENDPOINT}/${key}`, {
    method: 'PUT',
    body,
    headers: {
      Date: date,
      'Content-Type': contentType,
      'Cache-Control': cacheControl,
      Authorization: `OSS ${id}:${signature}`,
    },
  });
  if (!res.ok) {
    throw new Error(`PUT ${key} 失败：HTTP ${res.status} ${(await res.text()).slice(0, 200)}`);
  }
}

/** 上传后回读一次长度：上传"看起来成功"但字节没落地的情况不该由用户发现。 */
async function headLength(key) {
  const res = await fetch(`https://${BUCKET}.${ENDPOINT}/${key}`, { method: 'HEAD' });
  if (!res.ok) throw new Error(`HEAD ${key} 失败：HTTP ${res.status}`);
  return Number(res.headers.get('content-length') ?? -1);
}

// 目录里可能有别的东西：`.part`（下载/解压到一半的临时文件）、清单本身、隐藏文件。
// **认不出的一律跳过**——把半截文件当资产推上去，用户下回来的是打不开的包。
const files = readdirSync(dir)
  .filter((f) => !f.startsWith('.') && !f.endsWith('.part') && !f.endsWith('.json'))
  .map((f) => ({ name: basename(f), path: join(dir, f) }))
  .filter((f) => statSync(f.path).isFile());
if (files.length === 0) {
  console.error(`${dir} 里没有可取的文件`);
  process.exit(1);
}

const hasApk = files.some((f) => f.name.toLowerCase().endsWith('.apk'));
if (hasApk && isDefaultAliyun) {
  console.warn(
    '⚠ 当前 --public-base 是阿里云默认域名：APK 仍会上传，但阿里云禁止从该域名下载 .apk；' +
      '清单里会把它写成 url:null，网页/客户端会改走 gh-proxy。',
  );
}

const manifest = { tag, publishedAt: new Date().toISOString(), assets: [] };

for (const file of files) {
  const bytes = readFileSync(file.path);
  const key = `${PREFIX}${file.name}`;
  const ext = file.name.slice(file.name.lastIndexOf('.')).toLowerCase();
  const contentType = MIME[ext] ?? 'application/octet-stream';
  // 文件名固定，内容却每次发布都换 —— 必须让中间缓存回源校验，否则会发出去一个旧包
  const cacheControl = 'no-cache';

  const sha256 = createHash('sha256').update(bytes).digest('hex');
  const isApk = ext === '.apk';
  // APK + 默认域名：不写 url（页面会显示"暂不可用"），但照常上传，绑好域名后重跑即可
  const blocked = isApk && isDefaultAliyun;
  const url = blocked ? null : `${publicBase}/${encodeURIComponent(file.name)}?v=${encodeURIComponent(tag)}`;

  console.log(`↑ ${file.name}  ${(bytes.length / 1048576).toFixed(1)}MB  sha256=${sha256.slice(0, 12)}…`);
  await putObject(key, bytes, contentType, cacheControl);

  try {
    const landed = await headLength(key);
    if (landed !== bytes.length) {
      throw new Error(`${file.name} 上传后长度对不上：本地 ${bytes.length} / OSS ${landed}`);
    }
  } catch (err) {
    // 默认域名对 APK 的 HEAD 也可能回 400；上传本身已经成功，别让一个校验把发布挂掉。
    if (!isApk) throw err;
    console.warn(`  （APK 跳过长度回读：${err.message}）`);
  }

  manifest.assets.push({ name: file.name, size: bytes.length, sha256, url });
}

// 网页端与客户端读这份清单：版本号、资产列表与**每个资产的直链**都在这里。
// 60 秒缓存：够挡住刷新风暴，又不会让新版本迟迟不出现（页面自己还有 1 分钟的重验证）。
await putObject(
  `${PREFIX}latest.json`,
  Buffer.from(JSON.stringify(manifest, null, 2), 'utf8'),
  MIME['.json'],
  'public, max-age=60'
);

console.log(`\n完成：${manifest.assets.length} 个资产 + latest.json 已上传到 ${BUCKET}/${PREFIX}`);
console.log(`版本 ${tag}；公共地址 ${publicBase}`);
if (hasApk && isDefaultAliyun) {
  console.log('⚠ APK 的下载 url 为 null：网页/客户端会改走 gh-proxy；若以后绑了自定义域名，用 --public-base 重跑即可。');
}
