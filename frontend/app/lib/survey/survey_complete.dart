import 'package:flutter/material.dart';
import 'package:app/chat/chat_screen.dart';
import 'package:app/color.dart';

class SurveyCompleteScreen extends StatelessWidget {
  const SurveyCompleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 各要素を均等に配置
          children: [
            Text(
              'おつかれさまでした！',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: surveyTextColor,
              ),
            ),
            Image.asset(
              'assets/images/survey_check.png', // チェックマークアイコンのパス
              width: 200, // アイコンの幅を200に設定
              height: 200, // アイコンの高さを200に設定
              fit: BoxFit.contain, // アイコンの比率を維持
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 16), // ボタンのパディングを設定
                minimumSize: const Size(200, 50), // ボタンの最小サイズ
                backgroundColor: Colors.blue, // ボタンの背景色
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // ボタンの角丸を設定
                ),
              ),
              child: const Text(
                'チャット画面へ',
                style: TextStyle(
                  fontSize: 18, // フォントサイズを指定
                  fontWeight: FontWeight.bold, // 太字
                  color: Colors.white, // テキストの色
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
