import 'export.dart';

// apiでデータを取得するときに、最も古いデータの日付時間が指定されなかった場合
// 現在時間から一週間を最も古いデータの日付時間をデフォルトとする
DateTime getDefaultOldTime() {
  final now = DateTime.now();
  return now.subtract(const Duration(days: defaultDayTerm));
}
