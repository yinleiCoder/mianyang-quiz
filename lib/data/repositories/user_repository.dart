// 本人档案：读取、改名/换校/换头像、就读信息、申请教师身份。
//
// 读取走 PostgREST（profiles/schools 对 authenticated 有 select_any_auth 策略），
// 写入一律走 RPC（客户端没有 DML 权限，见 AGENTS.md 第四条）。
//
// 学校列表也放这里：它只在「填档案」的两处用到（注册选校、档案改校），
// 跟着档案走比单开一个仓储更省跳转。班级列表（0063）同理——它也是「先学校后班级」
// 这一段流程里选一次的东西，不另开仓储。

import 'package:mianyang_quiz/core/error/error_mapper.dart';
import 'package:mianyang_quiz/data/models/user/profile.dart';
import 'package:mianyang_quiz/data/models/user/school.dart';
import 'package:mianyang_quiz/data/models/user/school_class.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  const UserRepository(this._client);

  final SupabaseClient _client;

  /// 档案里界面要用到的列。**显式列名而不是 `*`**：新加的列不会悄悄进模型，
  /// 前端拿到的字段永远是这里列出来的那些。
  ///
  /// ⚠️ **给 Profile 加字段时必须同时加到这里**，否则模型里那个字段恒为默认值 ——
  /// 不报错、不崩，只是界面上永远显示成"没有"。`phone` 就这么漏过一次：
  /// 模型加了、迁移加了、界面也读了，唯独这里没加，于是手机号账号一律显示「未绑定手机号」。
  static const _profileColumns =
      'user_id, name, email, phone, school_id, is_admin, avatar_url, identity, '
      'enroll_year, major_category, major, class_name, class_id, major_node_id';

  /// 本人档案。未登录（或档案还没被注册触发器建出来）时返回 null。
  /// 调用方拿到后应自己缓存——档案在一次会话里几乎不变，
  /// 而且 updateProfile 需要拿它当「当前值」（见下）。
  Future<Profile?> fetchProfile() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return null;
      final row = await _client
          .from('profiles')
          .select(_profileColumns)
          .eq('user_id', userId)
          .maybeSingle();
      if (row == null) return null;
      return Profile.fromJson(row);
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 按 id 批量取档案（题库列表与详情的「作者 / 审核人」署名用）。
  ///
  /// 与网页端 lib/people.js 同一口径，但这里**不查角色**：署名只显示姓名与头像，
  /// 组长/专家的身份由 `bank_reviewers` 的 stage 直接给出，不必再查两张表。
  /// 查不到的 id 不会出现在结果里（账号已注销 → 调用方按"已注销"占位渲染）。
  Future<Map<String, Profile>> fetchProfiles(List<String> userIds) async {
    final ids = userIds.toSet().toList();
    if (ids.isEmpty) return const {};
    try {
      final rows = await _client
          .from('profiles')
          .select(_profileColumns)
          .inFilter('user_id', ids);
      return {
        for (final row in rows) row['user_id'] as String: Profile.fromJson(row),
      };
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 学校列表。[onlyActive] 为 true 时只取启用中的（注册、改校的选择器用）；
  /// 展示历史题目来源的校名时才传 false。
  Future<List<School>> fetchSchools({bool onlyActive = true}) async {
    try {
      var query = _client.from('schools').select('id, name, is_active');
      if (onlyActive) query = query.eq('is_active', true);
      final rows = await query.order('name');
      return rows.map(School.fromJson).toList();
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 班级列表（0063）。给了 [schoolId] 就只列该校的班——注册与改就读信息都是
  /// 「先学校后班级」，只有一个学校的名单才配得上下拉框。
  ///
  /// **刻意不过滤 is_active**：停用的班不能再被选进去（服务端 update_my_study_info
  /// 也只认启用中的班），但已经被分到停用班里的学生还得看见自己那个班——
  /// 过滤掉会让下拉框的当前值不在选项里，那个是断言级别的错误。
  /// 排不排、能不能选，交给调用方按 SchoolClass.isActive 决定。
  Future<List<SchoolClass>> fetchClasses({String? schoolId}) async {
    try {
      var query = _client
          .from('classes')
          .select('id, school_id, major_node_id, name, is_active');
      if (schoolId != null) query = query.eq('school_id', schoolId);
      final rows = await query.order('name');
      return rows.map(SchoolClass.fromJson).toList();
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 改姓名 / 换校 / 换头像。
  ///
  /// **[avatarUrl] 必须显式传「当前头像地址」**：RPC 的 p_avatar_url 默认 null 且写库
  /// 走 `nullif(trim())`，漏传等于把头像清空（改个名字头像就没了）。
  /// 所以这里把三个参数都设成必填，逼调用方把当前档案里的值带回来：
  ///   updateProfile(name: '张三', schoolId: p.schoolId, avatarUrl: p.avatarUrl)
  /// 传 null 表示**主动清除**那一项（清头像 / 解绑学校），不要用它表达「不改」。
  ///
  /// 服务端另有约束：目标学校必须存在且启用；有生效的教研组长任命时禁止换校；
  /// 解绑学校前须先撤销学校管理员身份。
  Future<void> updateProfile({
    required String name,
    required String? schoolId,
    required String? avatarUrl,
  }) async {
    try {
      await _client.rpc<void>(
        'update_own_profile',
        params: {
          'p_name': name,
          'p_school_id': schoolId,
          'p_avatar_url': avatarUrl,
        },
      );
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 维护就读信息（学生）。**同样是全量覆盖**：没传的字段会被清空
  /// （服务端对每个字段都做 `nullif(trim(coalesce(...,'')))`），
  /// 表单要带上全部四个当前值，只想改一项也要把其余项原样传回来。
  /// 服务端校验：入学年份 2000~2100；专业大类/专业 ≤40 字，班级 ≤20 字。
  Future<void> updateEnrollment({
    int? enrollYear,
    String? majorCategory,
    String? major,
    String? className,
  }) async {
    try {
      await _client.rpc<void>(
        'update_my_enrollment',
        params: {
          'p_enroll_year': enrollYear,
          'p_major_category': majorCategory,
          'p_major': major,
          'p_class_name': className,
        },
      );
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 就读信息（学生），0063 起的写法：入学年份 + 班级。
  ///
  /// 为什么另起一个而不是改 [updateEnrollment]：专业大类/专业不再由学生自己填，
  /// 改由所选班级派生（服务端算好写进那三列文本镜像），端上只管提交班级 id。
  /// 旧的 update_my_enrollment 仍在服务端保留给未升级的客户端，所以两个都在。
  ///
  /// [classId] 传 null = **主动清班**（不是"不改"）：换校后必须显式清，
  /// 否则留下的旧班级会被服务端拒（「该班级不属于你所在的学校，或已停用」）。
  ///
  /// 服务端另有一道前置断言：本人**已绑定学校**。没绑校时连"只改入学年份"都会被拒
  /// （「请先绑定所属学校后再选择班级」），所以调用方得先判断该不该发这次请求。
  Future<void> updateStudyInfo({int? enrollYear, String? classId}) async {
    try {
      await _client.rpc<void>(
        'update_my_study_info',
        params: {'p_enroll_year': enrollYear, 'p_class_id': classId},
      );
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 申请教师身份（学生 → teacher_pending，等学校管理员审核）。
  /// 服务端要求已绑定学校（否则报「请先绑定所属学校后再申请教师身份」）；
  /// 已是教师或已在审核中会直接报错——调用方应先看 Profile.identityValue 再显示入口。
  /// 成功后要重新拉一次档案，identityValue 会变成 teacherPending。
  Future<void> requestTeacherIdentity() async {
    try {
      await _client.rpc<void>('request_teacher_identity');
    } catch (error) {
      throw mapError(error);
    }
  }

  /// 是否具备教师权限（与数据库 is_teacher() 同义：identity=teacher 或 is_admin）。
  /// 注意与 [Profile.isTeacher] 是**同一判定的两个入口**：本方法以服务端为准，
  /// 适合做敏感操作前的校验；界面分支用本地档案即可，别为每次渲染多发一次请求。
  Future<bool> isTeacher() async {
    try {
      return await _client.rpc<bool>('is_teacher');
    } catch (error) {
      throw mapError(error);
    }
  }
}
