// QuestionFilter 是题库列表与组卷共用的值对象，它对**两种**后端说话：
//   · 组卷 → toRpcParams() → start_practice_session / start_sequential_practice
//   · 题库列表 → question_repository 直接读 difficulties 拼 PostgREST 查询
// 这里只钉住前者（后者由 bank 的页面测试覆盖），因为参数名与"空集合传什么"
// 是服务端的契约，写错了表现是"条件看着生效了、题却少了一批"，很难从界面上看出来。

import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/entity/entity.dart';
import 'package:mianyang_quiz/values/values.dart';

void main() {
  group('QuestionFilter.toRpcParams', () {
    test('未选条件一律传 null，让 RPC 用"不限"的默认语义', () {
      final params = const QuestionFilter().toRpcParams();

      expect(params['p_node_id'], isNull);
      expect(params['p_qtypes'], isNull);
      expect(params['p_difficulties'], isNull);
      expect(params['p_tag_id'], isNull);
      expect(params['p_keyword'], isNull);
    });

    test('难度多选传整型数组；空集合必须传 null 而不是空数组', () {
      expect(
        const QuestionFilter(difficulties: {1, 3}).toRpcParams()['p_difficulties'],
        containsAll(<int>[1, 3]),
      );

      // 服务端是 `v.difficulty = any(p_difficulties)`：空数组恒为假，会一道题都取不到
      final empty = const QuestionFilter(difficulties: {}).toRpcParams();
      expect(empty['p_difficulties'], isNull);
      expect(empty.containsKey('p_difficulties'), isTrue);
    });

    test('题型传线格式字符串，不传枚举名', () {
      final params = const QuestionFilter(
        qtypes: {QuestionType.singleChoice},
      ).toRpcParams();

      expect(params['p_qtypes'], [QuestionType.singleChoice.wire]);
    });

    test('关键词两端去空白，纯空白等于没填', () {
      expect(
        const QuestionFilter(keyword: '  excel  ').toRpcParams()['p_keyword'],
        'excel',
      );
      expect(
        const QuestionFilter(keyword: '   ').toRpcParams()['p_keyword'],
        isNull,
      );
    });

    test('hasAny 认得难度多选', () {
      expect(const QuestionFilter().hasAny, isFalse);
      expect(const QuestionFilter(difficulties: {2}).hasAny, isTrue);
    });
  });
}
