// 跑法：flutter test test/core/report_meta_test.dart
//
// **wire 取值是跨三处的契约**，这里把它钉死：
//   · supabase/migrations/0066_question_reports.sql 的 check 约束
//   · 网页端 lib/question-reports.js 的 REPORT_CATEGORIES
//   · 本端 lib/core/constants/report_meta.dart
// 写歪一个字的后果是**静默失败**：服务端 22023 直接拒，而客户端只知道"提交失败"。
// 所以下面逐字断言，而不是拿枚举自己和自己比。
import 'package:flutter_test/flutter_test.dart';
import 'package:mianyang_quiz/core/constants/report_meta.dart';

void main() {
  group('ReportCategory 的 wire 必须与 SQL check 约束逐字一致', () {
    test('四个取值逐字对', () {
      expect(
        ReportCategory.values.map((c) => c.wire).toList(),
        ['stem', 'answer', 'explanation', 'other'],
      );
    });

    test('中文标签与网页端一致', () {
      expect(ReportCategory.stem.label, '题干有误');
      expect(ReportCategory.answer.label, '答案有误');
      expect(ReportCategory.explanation.label, '解析有误');
      expect(ReportCategory.other.label, '其他问题');
    });
  });

  group('ReportStatus', () {
    test('wire 取值逐字对', () {
      expect(ReportStatus.values.map((s) => s.wire).toList(), ['open', 'resolved']);
    });

    test('已知取值正常映射', () {
      expect(ReportStatus.fromWire('open'), ReportStatus.open);
      expect(ReportStatus.fromWire('resolved'), ReportStatus.resolved);
    });

    // 服务端将来加了状态（比如 dismissed）时，旧客户端**不能崩** ——
    // 退回"待处理"是最好的降级：至少学生知道自己的反馈还在。
    test('未知取值退回待处理而不是抛异常', () {
      expect(ReportStatus.fromWire('dismissed'), ReportStatus.open);
      expect(ReportStatus.fromWire(null), ReportStatus.open);
    });
  });

  group('reportCategoryLabel', () {
    test('已知取值给中文', () {
      expect(reportCategoryLabel('stem'), '题干有误');
      expect(reportCategoryLabel('explanation'), '解析有误');
    });

    // 未知取值退回"其他问题"的标签，而不是把 wire 原样印给学生看
    test('未知取值退回其他问题', () {
      expect(reportCategoryLabel('whatever'), '其他问题');
      expect(reportCategoryLabel(null), '其他问题');
    });
  });

  group('长度限制必须与服务端 0066 的 check 约束一致', () {
    // 服务端是 btrim 后 2–500。客户端先用同一组数字拦一道，
    // 免得用户写完了才被服务端拒。
    test('下限 2、上限 500', () {
      expect(reportMinLength, 2);
      expect(reportMaxLength, 500);
    });
  });
}
