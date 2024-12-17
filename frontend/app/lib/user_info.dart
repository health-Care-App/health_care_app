import 'package:app/login.dart';
import 'package:app/survey.dart';
import 'package:app/google_auth/auth.dart';
import 'package:app/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/api/sleep_time/get/fetch.dart';
import 'package:app/api/health/get/fetch.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  List<FlSpot> sleepSpots = [];
  List<FlSpot> healthSpots = [];
  List<String> dates = [];

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
          sleepSpots = recentSleepTimes
              .asMap()
              .entries
              .map((e) => FlSpot(
                    e.key.toDouble(),
                    e.value.sleepTime.toDouble(),
                  ))
              .toList();
          dates = recentSleepTimes
              .map((e) => DateFormat('MM/dd').format(e.dateTime))
              .toList();
        });
      } else {
        setState(() {
          sleepSpots = [];
          dates = [];
        });
      }
    } catch (e) {
      print("睡眠データの取得中にエラーが発生しました: $e");
      setState(() {
        sleepSpots = [];
        dates = [];
      });
    }
  }

  Future<void> _fetchLatestHealth() async {
    try {
      final response = await getHealth();
      if (response.healths != null && response.healths!.isNotEmpty) {
        final recentHealths = response.healths!.take(7).toList();
        setState(() {
          healthSpots = recentHealths
              .asMap()
              .entries
              .map((e) => FlSpot(
                    e.key.toDouble(),
                    e.value.health.toDouble(),
                  ))
              .toList();
        });
      } else {
        setState(() {
          healthSpots = [];
        });
      }
    } catch (e) {
      print("体調データの取得中にエラーが発生しました: $e");
      setState(() {
        healthSpots = [];
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    Authentication.signOut(context: context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()), // LoginSampleに遷移
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
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 6,
                        getTitlesWidget: (value, _) {
                          if (value == 0 || value == 6 || value == 12) {
                            return Text(value.toInt().toString());
                          }
                          return Text('');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, _) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < dates.length) {
                            return Text(
                              dates[value.toInt()],
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
                      spots: sleepSpots,
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
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, _) {
                          if (value == 1 || value == 3 || value == 10) {
                            return Text(value.toInt().toString());
                          }
                          return Text('');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, _) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < dates.length) {
                            return Text(
                              dates[value.toInt()],
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
                      spots: healthSpots,
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
