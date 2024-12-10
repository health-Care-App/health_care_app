import 'package:flutter/material.dart';
import 'package:app/api/sleep_time/post/fetch.dart';
import 'package:app/api/health/post/fetch.dart';
import 'chat/chat_screen.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});
  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  String selectedSleepTime = '7'; // 初期値を設定
  String selectedCondition = '5'; // 初期値を設定

  Future<void> _submitSurvey() async {
    try {
      int sleepTime = int.parse(selectedSleepTime);
      int healthCondition = int.parse(selectedCondition);

      // データベースにPOST
      await postSleepTime(sleepTime);
      await postHealth(healthCondition);

      // 成功したらホーム画面に遷移
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen()),
      );
    } catch (e) {
      // エラー処理
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("送信中にエラーが発生しました: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("睡眠と体調アンケート")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 睡眠時間のドロップダウン
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('睡眠時間:'),
                DropdownButton<String>(
                  value: selectedSleepTime,
                  items: List.generate(12, (index) {
                    final value = (index + 1).toString(); // 1から12の範囲
                    return DropdownMenuItem(
                      value: value,
                      child: Text('$value 時間'),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      selectedSleepTime = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // 体調のドロップダウン
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('体調 (1-10):'),
                DropdownButton<String>(
                  value: selectedCondition,
                  items: List.generate(10, (index) {
                    final value = (index + 1).toString(); // 1から10の範囲
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      selectedCondition = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              child: const Text('完了'),
              onPressed: _submitSurvey,
            ),
          ],
        ),
      ),
    );
  }
}
