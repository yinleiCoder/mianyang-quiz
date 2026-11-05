// 「我的 → 学习画像」：取 0128 student_learning_profile，渲染六轴雷达图。
//
// 失败不阻塞资料页：0128 尚未在某个环境执行时，只显示一句“暂不可用 + 重试”，
// 账号、学习计划等其余区块照常可用。
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mianyang_quiz/apis/apis.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/widgets/learning_profile_view.dart';
import 'package:mianyang_quiz/utils/utils.dart';
import 'package:mianyang_quiz/widgets/duo_card.dart';
import 'package:mianyang_quiz/widgets/section_header.dart';
import 'package:provider/provider.dart';

class LearningProfileSection extends StatefulWidget {
  const LearningProfileSection({super.key});

  @override
  State<LearningProfileSection> createState() => _LearningProfileSectionState();
}

class _LearningProfileSectionState extends State<LearningProfileSection> {
  LearningProfile? _profile;
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final profile = await context.read<LearningRepository>().fetchLearningProfile();
      if (!mounted) return;
      setState(() => _profile = profile);
    } on AppException {
      if (!mounted) return;
      setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: '我的学习画像'),
        if (_loading)
          DuoCard(
            child: SizedBox(
              height: 120.r,
              child: const Center(child: CircularProgressIndicator()),
            ),
          )
        else if (_failed || _profile == null)
          DuoCard(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '学习画像暂不可用，稍后再试',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                TextButton(onPressed: _load, child: const Text('重试')),
              ],
            ),
          )
        else
          LearningProfileView(profile: _profile!),
      ],
    );
  }
}
