import 'package:flutter/material.dart';
import 'chat/chat_screen.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});
  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  String selectedSleepTime = '7'; // 初期値を設定
  String selectedCondition = '5'; // 初期値を設定

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
              onPressed: () {
                // 完了後、ホーム画面に遷移
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
