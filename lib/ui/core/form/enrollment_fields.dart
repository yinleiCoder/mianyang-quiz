// 就读信息两件套：入学年份 / 班级（只在学生身份下出现）。
//
// 职责：把这两个字段摆成一段。注册页与档案页共用同一套。不负责：取数与提交——
// 班级列表由页面拉好传进来，选中值由页面持有，提交时页面直接读。
//
// 为什么专业那两项没了（0032 的「专业大类 / 专业」下拉，0063 删掉）：
//   0063 起班级是实体（学校 × 专业节点 × 名称），**学生的专业由班级派生**，
//   服务端从班级算出 major_category / major 写进档案。让学生再手选一次，
//   只会在班级与自选专业之间制造第二个真相源（也就必然出现两者打架的数据）。
//
// 为什么班级改成下拉（原来是自由输入）：
//   手输的班名在线上演成了八种写法（同一个真实班级：24级计算机2班 / 24计算机2班 /
//   24级计算机二班 / 24计2 / 24计二 / 24级计2 / 24机计算机2班 / 24级\r\r计2，见 0063 头注）。
//   名字对不上，班级就永远当不成「以班为单位」的抓手。班级名单由学校管理员维护，
//   表对 anon 也开了只读，注册前就能拉。
//
// 为什么年份仍是下拉：这个范围的年份不多，选比敲快，也免了「2O26」这种手滑。
//
// 拉不到班级不阻断流程：没选学校、该校还没建班、或纯粹网络失败，都只是把下拉禁用
// 加一行说明——选班本来就是可选项（服务端对过期的 class_id 也只是静默丢弃），
// 注册后可回来补选，或由学校管理员批量分配。

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/core/theme/app_metrics.dart';
import 'package:mianyang_quiz/data/models/user/school_class.dart';
import 'package:mianyang_quiz/ui/core/layout/section_header.dart';

class EnrollmentFields extends StatelessWidget {
  const EnrollmentFields({
    super.key,
    required this.enrollYear,
    required this.onEnrollYearChanged,
    required this.classId,
    required this.onClassIdChanged,
    required this.classes,
    this.hasSchool = false,
    this.classesLoading = false,
    this.enabled = true,
  });

  /// 入学年份；null = 暂不填。
  final int? enrollYear;

  final ValueChanged<int?> onEnrollYearChanged;

  /// 所选班级 id；null = 暂不选（未分班）。
  final String? classId;

  final ValueChanged<String?> onClassIdChanged;

  /// 当前这所学校的班级（页面取来后原样传进来；换校时必须跟着换一份）。
  final List<SchoolClass> classes;

  /// 是否已经选了学校。只用来措辞——「还没选学校」与「该校还没建班」是两回事，
  /// 提示写成同一句会让人不知道该去做什么。
  final bool hasSchool;

  /// 班级列表还在加载：下拉先禁用，避免出现"看起来没班可选"的误会。
  final bool classesLoading;

  final bool enabled;

  /// 可选年份，从近到远排——绝大多数用户要选的那一年就在最前面。
  static final List<int> _years = List.generate(101, (i) => 2100 - i);

  /// 下拉里出现的班。
  ///
  /// 停用的班**只留当前选中的那个**，两个原因各占一半：DropdownButtonFormField 要求
  /// 当前值正好对应一个选项（一个都没有就断言失败），而学生被分进停用班时也得看得见
  /// 自己在哪个班。其余的停用班不列——服务端 update_my_study_info 只认启用中的班，
  /// 列出来只会让人白选一次。
  static List<SchoolClass> _options(List<SchoolClass> classes, String? classId) => [
    for (final c in classes)
      if (c.isActive || c.id == classId) c,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final body = theme.textTheme.bodyLarge?.copyWith(fontSize: 15.sp);
    final hintStyle = theme.textTheme.bodySmall?.copyWith(
      color: scheme.onSurfaceVariant,
    );
    final options = _options(classes, classId);
    final ready = enabled && !classesLoading && options.isNotEmpty;
    // 选中的班可能是停用中的（当前值），所以按 id 找而不是只看可选的那些
    SchoolClass? selected;
    for (final c in options) {
      if (c.id == classId) selected = c;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SectionHeader(title: '就读信息', subtitle: '可先跳过，注册后在「我的」里补全'),
        DropdownButtonFormField<int>(
          initialValue: enrollYear,
          isExpanded: true,
          style: body,
          decoration: const InputDecoration(
            labelText: '入学年份',
            prefixIcon: Icon(Icons.event_outlined),
          ),
          items: [
            const DropdownMenuItem<int>(value: null, child: Text('暂不选择')),
            for (final year in _years)
              DropdownMenuItem<int>(value: year, child: Text('$year 年')),
          ],
          onChanged: enabled ? onEnrollYearChanged : null,
        ),
        SizedBox(height: AppMetrics.gapLg.r),
        DropdownButtonFormField<String>(
          initialValue: options.any((c) => c.id == classId) ? classId : null,
          isExpanded: true,
          style: body,
          decoration: const InputDecoration(
            labelText: '班级',
            prefixIcon: Icon(Icons.groups_outlined),
          ),
          items: [
            const DropdownMenuItem<String>(value: null, child: Text('暂不选择')),
            for (final c in options)
              DropdownMenuItem<String>(
                value: c.id,
                // 停用的班留在列表里只为显示当前值，不能再被选中
                enabled: c.isActive,
                child: Text(c.isActive ? c.name : '${c.name}（已停用）'),
              ),
          ],
          onChanged: ready ? onClassIdChanged : null,
        ),
        if (selected != null) ...[
          SizedBox(height: AppMetrics.gapXs.r),
          Text(
            '已选「${selected.name}」：专业大类与专业由班级自动确定，不用再填。',
            style: hintStyle,
          ),
        ],
        if (classesLoading || options.isEmpty) ...[
          SizedBox(height: AppMetrics.gapXs.r),
          Text(
            classesLoading
                ? '正在加载班级列表…'
                : hasSchool
                      ? '该校还没有建立班级。可先跳过，注册后由学校管理员分配。'
                      : '先选择学校，才能选择班级。',
            style: hintStyle,
          ),
        ],
      ],
    );
  }
}

/// 表单文本 → 入库值。去空白；空串归一成 null——服务端按 nullif(trim()) 落库，两者同义。
///
/// **当前全仓没有调用方**：就读信息两个字段都改成了下拉，剩下的自由文本只有姓名，
/// 而姓名由 UserRepository 自己处理。留着是因为它同时也是「旧契约 updateEnrollment
/// （p_class_name 文本路径）该怎么归一空值」的书面口径——那条路服务端仍然支持
/// （0063 没动 update_my_enrollment），将来真有人接回去时不必重新推敲一次。
/// 若确认旧路径彻底废弃，可连同 UserRepository.updateEnrollment 一起删。
String? optionalText(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
