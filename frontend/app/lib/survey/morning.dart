import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/color.dart';
import 'package:app/survey/survey.dart';

class MorningScreen extends StatelessWidget {
  const MorningScreen({Key? key}) : super(key: key);

  String getCurrentDate() {
    final now = DateTime.now();
    const List<String> japaneseWeekdays = ['日', '月', '火', '水', '木', '金', '土'];
    final dayOfWeek = japaneseWeekdays[now.weekday % 7]; // 日本語の曜日を取得
    return DateFormat('MM/dd').format(now) + ' ($dayOfWeek)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 上部の白背景部分に画像を追加
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'assets/images/survey_zundamonn.png', // 画像ファイルのパス
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  color: baseColor, // 背景色を水色に設定
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, top: 40.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 太陽アイコン
                      Image.asset(
                        'assets/images/survey_sun.png', // 太陽の画像ファイルのパス
                        width: 50, // 幅を指定
                        height: 50, // 高さを指定
                      ),
                      const SizedBox(height: 32), // 太陽とテキストの間に余白を追加
                      Text(
                        'おはようございます！',
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        getCurrentDate(), // 日付を表示
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '早速本日の計測を進めましょう！',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter, // ボタンを画面の下中央に配置
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 64.0), // 下部余白を追加
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SurveyScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        minimumSize: const Size(200, 50), // ボタンの最小サイズを指定
                        backgroundColor: pinkColor, // 背景色をpinkColorに変更
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '記録画面へ',
                        style: TextStyle(
                          fontSize: 20, // フォントサイズを拡大
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // テキストの色を白に設定
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
