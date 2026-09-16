// 题目的署名：作者 + 两级审核通过人（与网页端题库页/详情页同一口径）。
//
// 为什么审核人要单独走 RPC：approvals 的 select 策略只放行任务处理人/决策人/管理员/作者（0009），
// 跨校学生/教师浏览全市题库时**看不到审批行**，直接 join 不出"谁审的"。
// 0024 的 `bank_reviewers(uuid[])` 是 SECURITY DEFINER 窄读：只吐 stage + 决策人，
// 不含意见与时间线；姓名头像由调用方按 profiles 公开列自行装配（就是下面这一步）。
//
// 与网页端的差别只有一处：网页在列表页一次给整页装配，这里只服务详情页的单个版本。

import 'package:mianyang_quiz/data/models/user/profile.dart';
import 'package:mianyang_quiz/data/repositories/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 一个人的署名：角色说明 + 档案（档案为 null = 账号已注销，UI 渲染"已注销"占位）。
typedef QuestionCredit = ({String caption, Profile? person});

class QuestionCreditLoader {
  const QuestionCreditLoader(this._client);

  final SupabaseClient _client;

  /// [createdBy] 是**版本**的作者（version.created_by）；账号注销后该列为 null，
  /// 此时连"已注销"都不显示——没有可挂靠的人。
  Future<List<QuestionCredit>> load({
    required String versionId,
    required String? createdBy,
  }) async {
    final reviewerRows = await _client.rpc(
      'bank_reviewers',
      params: {
        'p_version_ids': [versionId],
      },
    );
    final reviewers = (reviewerRows as List)
        .map((row) => Map<String, dynamic>.from(row as Map))
        .where((row) => row['decided_by'] != null)
        .toList();

    final people = await UserRepository(_client).fetchProfiles([
      ?createdBy,
      for (final row in reviewers) row['decided_by'] as String,
    ]);

    return [
      // 作者排在最前，与网页端一致；查不到档案就是"作者 已注销"
      if (createdBy != null) (caption: '作者', person: people[createdBy]),
      // 组长环节在前、专家环节在后（同一条题的两个环节，顺序固定才不会跳）
      for (final stage in const ['group', 'city'])
        for (final row in reviewers.where((r) => r['stage'] == stage))
          if (people[row['decided_by']] != null)
            (
              caption: stage == 'group' ? '组长' : '专家',
              person: people[row['decided_by']],
            ),
    ];
  }
}
