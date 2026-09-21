// 复习资料的下载与「保存到本地」。
//
// **为什么两端不是一个动作**（不是偷懒，是平台差异没有统一解）：
//   · Windows：直接写进系统「下载」文件夹（getDownloadsDirectory），并告诉用户路径。
//   · Android：**没有**等价的写法。getDownloadsDirectory() 在 Android 上直接抛
//     UnsupportedError；写应用外部目录（Android/data/<包名>/files）在 Android 11+
//     对其他应用不可见，学生根本找不到；而 file_selector 的 getSaveLocation()
//     按官方支持表**不支持 Android**。
//     所以 Android 走系统分享面板——它是免存储权限、且学生最熟悉的那条路
//     （面板里有「保存到文件」，也有微信/QQ）。这与 share_question_sheet 里
//     「桌面端没有分享面板」那条注释是同一类取舍，只是方向相反。
//
// 文件先落到应用私有目录再交出去：那是唯一两个平台都保证可写、且不需要申请权限的位置。

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:mianyang_quiz/data/models/material/material_brief.dart';

/// 保存的落点。UI 据此决定提示文案。
enum SaveTarget {
  /// Windows：已经写进系统下载目录，[SaveOutcome.path] 是完整路径。
  downloadsFolder,

  /// Android：已交给系统分享面板，由学生自己选存到哪。
  shareSheet,
}

typedef SaveOutcome = ({SaveTarget target, String? path});

class MaterialDownloadService {
  MaterialDownloadService(this._dio);

  final Dio _dio;

  /// 应用私有目录下的资料缓存。**文件名带资料 id**：标题可能重复，
  /// 而 id 唯一，不会出现"两份同名资料互相覆盖"。
  Future<Directory> _cacheDir() async {
    final base = await getApplicationSupportDirectory();
    final dir = Directory('${base.path}${Platform.pathSeparator}materials');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<File> _cachedFile(MaterialBrief material) async {
    final dir = await _cacheDir();
    // 扩展名以 objectKey 为准（suggestedFileName 已经带上了）
    return File('${dir.path}${Platform.pathSeparator}${material.id}-${material.suggestedFileName}');
  }

  /// 下载到应用私有目录。**已经下过且大小一致就直接复用**——资料动辄几十 MB，
  /// 每次点都重下一遍在学校机房的网络下是灾难。
  Future<File> fetch(MaterialBrief material, {void Function(int, int)? onProgress}) async {
    final file = await _cachedFile(material);
    if (await file.exists()) {
      final length = await file.length();
      // size 为 0 说明服务端没记大小（历史数据），此时不敢复用，重下
      if (material.size > 0 && length == material.size) return file;
    }

    await _dio.download(
      material.fileUrl,
      file.path,
      onReceiveProgress: onProgress,
      options: Options(receiveTimeout: const Duration(minutes: 5)),
    );
    return file;
  }

  /// 保存到学生能找到的地方。见文件头：两端落点不同。
  Future<SaveOutcome> saveToDevice(MaterialBrief material) async {
    final file = await fetch(material);

    if (defaultTargetPlatform == TargetPlatform.windows) {
      final downloads = await getDownloadsDirectory();
      if (downloads == null) {
        // 极少数情况（OneDrive 重定向、组策略禁用）拿不到下载目录，退回私有目录
        return (target: SaveTarget.downloadsFolder, path: file.path);
      }
      final target = File(
        '${downloads.path}${Platform.pathSeparator}${material.suggestedFileName}',
      );
      await file.copy(target.path);
      return (target: SaveTarget.downloadsFolder, path: target.path);
    }

    // Android（及其它移动端）：交给系统分享面板，学生自己选"保存到文件"
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: material.mime)],
        text: material.title,
      ),
    );
    return (target: SaveTarget.shareSheet, path: file.path);
  }

  /// 分享资料。
  ///
  /// **分享的是文件本体，不是网页链接**：网页端没有资料详情页，而 OSS 地址本身
  /// 公网可读（没有鉴权），所以直接把地址给出去对方就能下——已经下过的话连文件一起带上，
  /// 对方连流量都省了。
  ///
  /// Windows 上 share_plus 没有可用的系统分享面板，会抛；调用方负责退回到
  /// "复制链接"（与 share_question_sheet 同款取舍）。
  Future<void> shareLink(MaterialBrief material) async {
    final text = '${material.title}（来自绵阳市中职共建题库 · 复习资料）\n${material.fileUrl}';
    final file = await _cachedFile(material);

    if (defaultTargetPlatform == TargetPlatform.windows || !await file.exists()) {
      await SharePlus.instance.share(ShareParams(text: text));
      return;
    }
    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path, mimeType: material.mime)], text: text),
    );
  }
}
