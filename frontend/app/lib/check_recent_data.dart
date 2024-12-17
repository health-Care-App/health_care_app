import 'package:intl/intl.dart';
import 'api/sleep_time/get/fetch.dart';

Future<bool> isRecentDataToday() async {
  try {
    final response = await getSleepTime();

    // データが存在しない場合は false を返す
    if (response.sleepTimes == null || response.sleepTimes!.isEmpty) {
      print("データが見つかりません。");
      return false;
    }

    // 最新のデータを取得（降順で最も新しいデータを選択）
    final latestSleepTime = response.sleepTimes!
        .reduce((a, b) => a.dateTime.isAfter(b.dateTime) ? a : b);

    // 今日の日付を取得
    final now = DateTime.now();

    // 最新のデータの日付と現在の日付を比較
    final latestDate =
        DateFormat('yyyy-MM-dd').format(latestSleepTime.dateTime.toLocal());
    final currentDate = DateFormat('yyyy-MM-dd').format(now);

    print("最新データの日付: $latestDate, 現在の日付: $currentDate");

    return latestDate == currentDate;
  } catch (e) {
    print("エラーが発生しました: $e");
    return false;
  }
}
