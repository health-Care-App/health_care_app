import 'package:app/google_auth/auth.dart';
import 'package:app/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/api/sleep_time/get/fetch.dart';
import 'package:app/api/health/get/fetch.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:app/color.dart';

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
      MaterialPageRoute(builder: (context) => SignInScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const double maxWidth = 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: maxWidth),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "睡眠時間の推移",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            height: 200,
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: graphColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.start,
                                maxY: 12,
                                titlesData: FlTitlesData(
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 6,
                                      getTitlesWidget: (value, _) {
                                        if (value == 0 ||
                                            value == 6 ||
                                            value == 12) {
                                          return Text(
                                            value.toInt().toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: const Color.fromARGB(
                                                    255, 48, 47, 47)),
                                          );
                                        }
                                        return Text('');
                                      },
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, _) {
                                        if (value.toInt() >= 0 &&
                                            value.toInt() < dates.length) {
                                          return Text(
                                            dates[value.toInt()],
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: const Color.fromARGB(
                                                    255, 48, 47, 47)),
                                          );
                                        }
                                        return Text('');
                                      },
                                    ),
                                  ),
                                ),
                                gridData: FlGridData(show: false),
                                borderData: FlBorderData(
                                  show: true,
                                  border: const Border.symmetric(
                                    horizontal: BorderSide(
                                        color:
                                            Color.fromARGB(255, 213, 215, 215),
                                        width: 1),
                                  ),
                                ),
                                barGroups: sleepSpots
                                    .asMap()
                                    .entries
                                    .map((e) => BarChartGroupData(
                                          x: e.key,
                                          barRods: [
                                            BarChartRodData(
                                              toY: e.value.y,
                                              color: Colors.blue,
                                              width: 24,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ],
                                        ))
                                    .toList(),
                                groupsSpace: 24,
                              ),
                            ),
                          ),
                          SizedBox(height: 80),
                          Text(
                            "体調の推移",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            height: 200,
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: graphColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.start,
                                maxY: 10,
                                minY: 0,
                                titlesData: FlTitlesData(
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 1,
                                      getTitlesWidget: (value, _) {
                                        if (value == 0 ||
                                            value == 5 ||
                                            value == 10) {
                                          return Text(
                                            value.toInt().toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: const Color.fromARGB(
                                                    255, 48, 47, 47)),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, _) {
                                        if (value.toInt() >= 0 &&
                                            value.toInt() < dates.length) {
                                          return Text(
                                            dates[value.toInt()],
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: const Color.fromARGB(
                                                    255, 48, 47, 47)),
                                          );
                                        }
                                        return Text('');
                                      },
                                    ),
                                  ),
                                ),
                                gridData: FlGridData(show: false),
                                borderData: FlBorderData(
                                  show: true,
                                  border: const Border.symmetric(
                                    horizontal: BorderSide(
                                        color:
                                            Color.fromARGB(255, 213, 215, 215),
                                        width: 1),
                                  ),
                                ),
                                barGroups: healthSpots
                                    .asMap()
                                    .entries
                                    .map((e) => BarChartGroupData(
                                          x: e.key,
                                          barRods: [
                                            BarChartRodData(
                                              toY: e.value.y,
                                              color: Colors.green,
                                              width: 24,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ],
                                        ))
                                    .toList(),
                                groupsSpace: 24,
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          Center(
                            child: ElevatedButton(
                              onPressed: () => _logout(context),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                minimumSize: const Size(200, 50),
                                backgroundColor: pinkColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "ログアウト",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
