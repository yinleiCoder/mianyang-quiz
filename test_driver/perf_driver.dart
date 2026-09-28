// `flutter drive` 的驱动端：把集成测试里 watchPerformance 采到的帧耗时落盘。
//
// **为什么必须有这个文件**：`flutter test integration_test/...` 只回传通过/失败，
// binding 里攒下的 `reportData` **没有任何出口**——数字采了也留不下来。
// 只有 `flutter drive --driver=test_driver/perf_driver.dart ...` 会把
// `reportData` 交给这里的 responseDataCallback。所以取性能数据只能走 drive。
//
// 跑法（--profile 不能省，debug 的数字不代表用户体感）：
//   flutter drive \
//     --driver=test_driver/perf_driver.dart \
//     --target=integration_test/performance_test.dart \
//     --profile
//
// 产出（都在 build/ 下，`testOutputsDirectory` 由工具给出）：
//   build/bank_scroll_summary.json     滚动 200 条题库列表的帧统计
//   build/list_first_frame_summary.json 列表首屏从无到有的帧统计
//   build/perf_raw.json                上面两者的原始合并，排查时用
//
// 指标口径见 FrameTimingSummarizer：average / 90th / 99th / worst 的
// frame_build_time 与 frame_rasterizer_time、missed_frame_*_budget_count。
// **看 99th 与 worst**，平均值好看而 worst 很差 = 有偶发重布局，那才是用户感觉到的卡。

import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver(
  responseDataCallback: (data) async {
    if (data == null) return;

    // 先整体落一份：分文件那步只挑 Map，将来加了非 Map 的 reportKey 不至于丢
    await writeResponseData(data, testOutputFilename: 'perf_raw');

    for (final entry in data.entries) {
      final value = entry.value;
      if (value is! Map<String, dynamic>) continue;
      await writeResponseData(
        value,
        testOutputFilename: '${entry.key}_summary',
      );
    }
  },
);
