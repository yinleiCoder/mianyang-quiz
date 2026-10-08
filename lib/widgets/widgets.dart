// widgets 桶文件：本目录对外唯一的引用入口。
//
// 约定（见 AGENTS.md 二·六）：**跨目录引用一律走桶**，
// 即 `import 'package:mianyang_quiz/widgets/widgets.dart';`；
// 同目录内部仍写精确路径，这样"谁依赖谁"在 import 行上看得见。

library widgets;

export 'accuracy_chip.dart';
export 'analysis_view.dart';
export 'answer_sheet_data.dart';
export 'answer_sheet_grid.dart';
export 'answer_summary_view.dart';
export 'async_view.dart';
export 'block_list_view.dart';
export 'block_media_view.dart';
export 'brand_mark.dart';
export 'breakpoints.dart';
export 'choice_input_view.dart';
export 'composite_input_view.dart';
export 'daily_trend_chart.dart';
export 'difficulty_chip.dart';
export 'duo_button.dart';
export 'duo_card.dart';
export 'duo_chip.dart';
export 'duo_icon_badge.dart';
export 'duo_progress_bar.dart';
export 'duo_stat_tile.dart';
export 'empty_state.dart';
export 'enrollment_fields.dart';
export 'error_state.dart';
export 'essay_input_view.dart';
export 'external_media_row.dart';
export 'fade_slide_in.dart';
export 'favorite_toggle.dart';
export 'fill_blank_input_view.dart';
export 'floating_art.dart';
export 'filter_chip_group.dart';
export 'image_block_view.dart';
export 'list_footer.dart';
export 'loading_state.dart';
export 'max_width_box.dart';
export 'media_fallback.dart';
export 'option_tile.dart';
export 'paged_list.dart';
export 'pull_to_refresh.dart';
export 'question_view.dart';
export 'section_header.dart';
export 'short_answer_input_view.dart';
export 'short_answer_mode.dart';
export 'stem_view.dart';
export 'sub_question_card.dart';
export 'subject_picker_row.dart';
export 'subject_tree_branch.dart';
export 'subject_tree_sheet.dart';
export 'true_false_input_view.dart';
export 'user_avatar.dart';
