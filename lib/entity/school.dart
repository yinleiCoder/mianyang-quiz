// 学校（schools 表）。注册时选学校、题库按校显示题源都用到。
//
// 注册页只取 is_active 的学校；题库列表里显示"题源：xx学校"时不做启用过滤
// （历史题目的学校可能已停用，但题还在线，仍需正确显示名字）。

import 'package:freezed_annotation/freezed_annotation.dart';

part 'school.freezed.dart';
part 'school.g.dart';

@freezed
abstract class School with _$School {
  const factory School({
    required String id,
    required String name,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _School;

  factory School.fromJson(Map<String, dynamic> json) => _$SchoolFromJson(json);
}
