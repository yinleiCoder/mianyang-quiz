// 把发布产物推一份到阿里云 OSS（client/ 前缀），供网页端 /download 直接下载。
//
// **为什么要有这一步**：GitHub Releases 在国内基本取不到字节。2026-10-12 在绵阳实测：
// 直连 release 资产 20 秒 0 字节（HEAD 能过、正文取不到），同一时刻自家成都 OSS 7.2MB/s。
// 安装包挂在 GitHub 上、学生下不动，再好的客户端也装不上——所以每次发布都往 OSS 推一份，
// 网页端优先给 OSS 链接，GitHub 只留作"能上外网的人"的备用线路。
//
// 用法（发布流水线由 .github/workflows/release.yml 调用，也可以本机手动跑）：
//   OSS_ACCESS_KEY_ID=… OSS_ACCESS_KEY_SECRET=… \
//     node tool/upload_to_oss.mjs --dir build/oss-upload --tag v2.7.5
//
// 资产名**不带版本号**（与 GitHub 那边逐字一致）——网页端写死的就是这几个名字，
// 两边同一套命名，谁也不用记两套。版本号只写进 client/latest.json。
//
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
  console.error('用法：node tool/upload_to_oss.mjs --dir <发布产物目录> --tag vX.Y.Z');
  process.exit(1);
}

const { OSS_ACCESS_KEY_ID: id, OSS_ACCESS_KEY_SECRET: secret } = process.env;
if (!id || !secret) {
  console.error('缺少 OSS_ACCESS_KEY_ID / OSS_ACCESS_KEY_SECRET 环境变量');
  process.exit(1);
}

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

const manifest = { tag, publishedAt: new Date().toISOString(), assets: [] };

// **阿里云不允许 .apk 从默认域名（*.aliyuncs.com）对外分发**（2026-10-12 实测：
// 其它扩展名一律 200，只有 .apk 回 400 ApkDownloadForbidden，正文让我们"用 CNAME"）。
// 服务端代拉也一样被拦（探测就是 node fetch 发的），所以"用 Next 中转"这条也不通。
// 这里**跳过 .apk 并如实标 mirrored:false**：网页端据此把 Android 按钮留回 GitHub。
// 哪天真给桶绑了自定义域名，加 --allow-apk 重跑即可。
const allowApk = process.argv.includes('--allow-apk');

for (const file of files) {
  const bytes = readFileSync(file.path);
  const key = `${PREFIX}${file.name}`;
  const ext = file.name.slice(file.name.lastIndexOf('.')).toLowerCase();
  const contentType = MIME[ext] ?? 'application/octet-stream';
  // 文件名固定，内容却每次发布都换 —— 必须让中间缓存回源校验，否则会发出去一个旧包
  const cacheControl = 'no-cache';

  const sha256 = createHash('sha256').update(bytes).digest('hex');

  if (ext === '.apk' && !allowApk) {
    console.log(`— ${file.name}  跳过（阿里云不允许 .apk 走默认域名，见本文件 --allow-apk 的注释）`);
    manifest.assets.push({ name: file.name, size: bytes.length, sha256, mirrored: false });
    continue;
  }

  console.log(`↑ ${file.name}  ${(bytes.length / 1048576).toFixed(1)}MB  sha256=${sha256.slice(0, 12)}…`);
  await putObject(key, bytes, contentType, cacheControl);

  const landed = await headLength(key);
  if (landed !== bytes.length) {
    throw new Error(`${file.name} 上传后长度对不上：本地 ${bytes.length} / OSS ${landed}`);
  }
  manifest.assets.push({ name: file.name, size: bytes.length, sha256, mirrored: true });
}

// 网页端读这份清单：既当"这个版本有哪些资产"（与 GitHub API 的资产列表同一用途），
// 又当"哪些资产已经在 OSS 上"（mirrored）—— 后者决定按钮走 OSS 还是 GitHub。
// 60 秒缓存：够挡住刷新风暴，又不会让新版本迟迟不出现（页面自己还有 5 分钟的重验证）。
await putObject(
  `${PREFIX}latest.json`,
  Buffer.from(JSON.stringify(manifest, null, 2), 'utf8'),
  MIME['.json'],
  'public, max-age=60'
);

console.log(`\n完成：${manifest.assets.length} 个资产 + latest.json 已上传到 ${BUCKET}/${PREFIX}`);
console.log(`版本 ${tag}；网页端 https://myquiz.cn/download 会在 5 分钟内跟上。`);
