import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/api/sleep_time/post/fetch.dart';
import 'package:app/api/health/post/fetch.dart';
import 'package:app/chat/chat_screen.dart';
import 'package:app/color.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({Key? key}) : super(key: key);

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  String selectedSleepTime = '7'; // 睡眠時間の初期値
  String selectedCondition = '5'; // 体調の初期値
  bool isLoading = false; // ローディング状態

  Future<void> submitSurvey() async {
    setState(() {
      isLoading = true;
    });

    try {
      final sleepTime = int.parse(selectedSleepTime);
      final health = int.parse(selectedCondition);

      final sleepResponse = await postSleepTime(sleepTime);
      if (sleepResponse.message != "ok") {
        throw Exception("睡眠時間データ送信に失敗しました");
      }

      final healthResponse = await postHealth(health);
      if (healthResponse.message != "ok") {
        throw Exception("体調データ送信に失敗しました");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("データ送信に成功しました")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChatScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("エラーが発生しました: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String getCurrentDate() {
    final now = DateTime.now();
    return DateFormat('MM/dd').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3, // 画面の縦幅の3割
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getCurrentDate(),
                    style: const TextStyle(
                      fontSize: 36,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '本日の記録',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity, // 背景を画面幅いっぱいに広げる
              color: baseColor, // 背景色を水色に設定
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '睡眠時間',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButton<String>(
                            value: selectedSleepTime,
                            isExpanded: true,
                            underline: SizedBox.shrink(),
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            items: List.generate(12, (index) {
                              final value = (index + 1).toString();
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  '$value 時間',
                                  style: TextStyle(fontSize: 16),
                                ),
                              );
                            }),
                            onChanged: (value) {
                              setState(() {
                                selectedSleepTime = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '体調 (1-10)',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: DropdownButton<String>(
                            value: selectedCondition,
                            isExpanded: true,
                            underline: SizedBox.shrink(),
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            items: List.generate(10, (index) {
                              final value = (index + 1).toString();
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 16),
                                ),
                              );
                            }),
                            onChanged: (value) {
                              setState(() {
                                selectedCondition = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
