// 学校选择器：底部弹出的单选列表。
//
// 职责：从传进来的学校列表里选一所，或明确选择「暂不绑定学校」。
// 不负责：拉取学校列表（页面拉好传进来）、提交（页面在保存时统一写库）。
//
// 返回值约定（[pickSchool] 的回调）：用户取消 → 不回调；选中某校 → 该校 id；
// 选「暂不绑定」→ null。用空串表示"清空"是刻意的——null 已经被"取消"占用了，
// 两者混在一起会让页面分不清「没选」和「选了不绑定」。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/core/theme/app_text_styles.dart';
import 'package:mianyang_quiz/data/models/user/school.dart';

/// 打开学校选择器。用户做了选择才回调 [onPicked]。
Future<void> pickSchool(
  BuildContext context, {
  required List<School> schools,
  required String? selectedId,
  required ValueChanged<String?> onPicked,
}) async {
  final result = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (context) =>
        _SchoolSheet(schools: schools, selectedId: selectedId),
  );
  if (result == null) return; // 用户取消：保留原值
  onPicked(result.isEmpty ? null : result);
}

class _SchoolSheet extends StatelessWidget {
  const _SchoolSheet({required this.schools, required this.selectedId});

  final List<School> schools;
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppMetrics.gapXl.r,
              0,
              AppMetrics.gapXl.r,
              AppMetrics.gapMd.r,
            ),
            child: Text('选择学校', style: AppTextStyles.sectionTitle(context)),
          ),
          // Flexible + shrinkWrap：学校数量不多时按内容高度收，多了才滚动。
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                _SchoolOption(
                  label: '暂不绑定学校',
                  selected: selectedId == null,
                  onTap: () => Navigator.of(context).pop(''),
                ),
                for (final school in schools)
                  _SchoolOption(
                    label: school.name,
                    selected: school.id == selectedId,
                    onTap: () => Navigator.of(context).pop(school.id),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 单选的一行：选中项右侧给一个勾，而不是只用背景色（背景色在暗色下不够分明）。
class _SchoolOption extends StatelessWidget {
  const _SchoolOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListTile(
      title: Text(
        label,
        style: AppTextStyles.body(context).copyWith(
          color: selected ? scheme.primary : scheme.onSurface,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
      trailing: selected
          ? Icon(Icons.check_rounded, size: 20.r, color: scheme.primary)
          : null,
      onTap: onTap,
    );
  }
}
