// LIKE 通配符转义。
//
// 从 data/repositories/query/question_enricher.dart 上提到这里：题库与复习资料
// 两处都要用同一套规则，而那个文件是题目专用的（AGENTS.md 二：跨 feature 复用必须上提）。
// 本函数是纯字符串处理、零业务，正好落在 core/utils。
//
// 规则与网页端 lib/materials.js / lib/bank-query.js 一致：把 \ % _ 按字面匹配。
// 不转义的话，用户搜 "50%" 会变成"以 50 开头的通配匹配"，搜 "_" 更是匹配任意单字符。

/// 让关键词里的 % _ \ 按字面匹配。
String escapeLikeKeyword(String input) =>
    input.replaceAllMapped(RegExp(r'[\\%_]'), (m) => '\\${m[0]}');
