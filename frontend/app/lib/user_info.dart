import 'package:app/login.dart';
import 'package:app/survey.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/api/sleep_time/get/fetch.dart';
import 'package:app/api/health/get/fetch.dart';
import 'package:fl_chart/fl_chart.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  List<int> sleepData = List.filled(7, 0);
  List<int> healthData = List.filled(7, 1);

  @override
  void initState() {
    super.initState();
    _fetchLatestData();
  }

  Future<void> _fetchLatestData() async {
    await Future.wait([_fetchLatestSleepTime(), _fetchLatestHealth()]);
  }

  Future<void> _fetchLatestSleepTime() async {
    try {
      final response = await getSleepTime();
      if (response.sleepTimes != null && response.sleepTimes!.isNotEmpty) {
        final recentSleepTimes = response.sleepTimes!.take(7).toList();
        setState(() {
          sleepData = List<int>.filled(7, 0);
          for (int i = 0; i < recentSleepTimes.length; i++) {
            sleepData[6 - i] = recentSleepTimes[i].sleepTime;
          }
        });
      } else {
        setState(() {
          sleepData = List<int>.filled(7, 0);
        });
      }
    } catch (e) {
      print("睡眠データの取得中にエラーが発生しました: $e");
      setState(() {
        sleepData = List<int>.filled(7, 0);
      });
    }
  }

  Future<void> _fetchLatestHealth() async {
    try {
      final response = await getHealth();
      if (response.healths != null && response.healths!.isNotEmpty) {
        final recentHealths = response.healths!.take(7).toList();
        setState(() {
          healthData = List<int>.filled(7, 1);
          for (int i = 0; i < recentHealths.length; i++) {
            healthData[6 - i] = recentHealths[i].health;
          }
        });
      } else {
        setState(() {
          healthData = List<int>.filled(7, 1);
        });
      }
    } catch (e) {
      print("体調データの取得中にエラーが発生しました: $e");
      setState(() {
        healthData = List<int>.filled(7, 1);
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    String? email = user?.email ?? "メールアドレスがありません";

    return Scaffold(
      appBar: AppBar(
        title: Text("ユーザー情報"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$email", style: TextStyle(fontSize: 22)),
            SizedBox(height: 20),

            // 睡眠時間グラフ
            Text("睡眠時間の推移", style: TextStyle(fontSize: 18)),
            Container(
              height: 200,
              padding: EdgeInsets.all(16.0),
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 12,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 2),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, _) {
                          if (value.toInt() >= 0 && value.toInt() < 7) {
                            return Text(
                              'Day ${(value.toInt() + 1)}',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            );
                          }
                          return Text('');
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: false,
                      spots: List.generate(
                        7,
                        (index) => FlSpot(
                          index.toDouble(),
                          sleepData[index].toDouble(),
                        ),
                      ),
                      barWidth: 4,
                      isStrokeCapRound: true,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // 体調スコアグラフ
            Text("体調の推移", style: TextStyle(fontSize: 18)),
            Container(
              height: 200,
              padding: EdgeInsets.all(16.0),
              child: LineChart(
                LineChartData(
                  minY: 1,
                  maxY: 10,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 2),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, _) {
                          if (value.toInt() >= 0 && value.toInt() < 7) {
                            return Text(
                              'Day ${(value.toInt() + 1)}',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            );
                          }
                          return Text('');
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: false,
                      spots: List.generate(
                        7,
                        (index) => FlSpot(
                          index.toDouble(),
                          healthData[index].toDouble(),
                        ),
                      ),
                      barWidth: 4,
                      isStrokeCapRound: true,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _logout(context),
                    child: Text("ログアウト"),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SurveyScreen(),
                        ),
                      );
                    },
                    child: Text("睡眠と体調アンケートに進む"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
