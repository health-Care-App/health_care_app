import 'package:app/survey/survey_complete.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/api/sleep_time/post/fetch.dart';
import 'package:app/api/health/post/fetch.dart';
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

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SurveyCompleteScreen()),
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
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/survey.png', // 画像ファイルのパス
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
                  color: baseColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, top: 40.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getCurrentDate(),
                        style: const TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '本日の記録',
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 150),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '睡眠時間',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: surveyTextColor),
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
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '体調\n(悪い 1-10 良い)',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: surveyTextColor),
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 64.0),
                    child: ElevatedButton(
                      onPressed: isLoading ? null : submitSurvey,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        minimumSize: const Size(200, 50),
                        backgroundColor: pinkColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              '送信する',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
