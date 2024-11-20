import 'package:flutter/material.dart';
import 'package:app/api/sleep_time/post/fetch.dart'; // postSleepTime
import 'package:app/api/health/post/fetch.dart'; // postHealth
import 'chat/chat_screen.dart'; // チャット画面

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({Key? key}) : super(key: key);

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  String selectedSleepTime = '7'; // 睡眠時間の初期値
  String selectedCondition = '5'; // 体調の初期値
  bool isLoading = false; // ローディング状態

  // アンケートデータ送信
  Future<void> submitSurvey() async {
    setState(() {
      isLoading = true;
    });

    try {
      final sleepTime = int.parse(selectedSleepTime); // 睡眠時間
      final health = int.parse(selectedCondition); // 体調

      // 睡眠時間API呼び出し
      final sleepResponse = await postSleepTime(sleepTime);
      if (sleepResponse.message != "ok") {
        throw Exception("睡眠時間データ送信に失敗しました");
      }

      // 体調API呼び出し
      final healthResponse = await postHealth(health);
      if (healthResponse.message != "ok") {
        throw Exception("体調データ送信に失敗しました");
      }

      // 成功メッセージ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("データ送信に成功しました")),
      );

      // チャット画面に遷移
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChatScreen()),
      );
    } catch (e) {
      // エラーメッセージ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("エラーが発生しました: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
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
            // 睡眠時間ドロップダウン
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('睡眠時間:'),
                DropdownButton<String>(
                  value: selectedSleepTime,
                  items: List.generate(12, (index) {
                    final value = (index + 1).toString();
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
            // 体調ドロップダウン
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('体調 (1-10):'),
                DropdownButton<String>(
                  value: selectedCondition,
                  items: List.generate(10, (index) {
                    final value = (index + 1).toString();
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
              onPressed: isLoading ? null : submitSurvey,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('送信'),
            ),
          ],
        ),
      ),
    );
  }
}
