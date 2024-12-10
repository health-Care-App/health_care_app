import 'package:app/login.dart';
import 'package:app/survey.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/api/sleep_time/get/fetch.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  String? latestSleepTimeMessage = "データを取得中...";

  @override
  void initState() {
    super.initState();
    _fetchLatestSleepTime();
  }

  Future<void> _fetchLatestSleepTime() async {
    try {
      final response = await getSleepTime();
      if (response.sleepTimes != null && response.sleepTimes!.isNotEmpty) {
        final latestSleepTime = response.sleepTimes!.first.sleepTime;
        setState(() {
          latestSleepTimeMessage = "直近の睡眠時間: $latestSleepTime 時間";
        });
      } else {
        setState(() {
          latestSleepTimeMessage = "睡眠データがありません";
        });
      }
    } catch (e) {
      setState(() {
        latestSleepTimeMessage = "データの取得中にエラーが発生しました: $e";
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
            Text("睡眠時間の推移", style: TextStyle(fontSize: 18)),
            Container(
              color: Colors.grey[200],
              height: 200,
              width: double.infinity,
              child: Center(child: Text(latestSleepTimeMessage!)),
            ),
            SizedBox(height: 20),
            Text("体調の推移", style: TextStyle(fontSize: 18)),
            Container(
              color: Colors.grey[200],
              height: 200,
              width: double.infinity,
              child: Center(child: Text("体調の推移グラフ")),
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
                        MaterialPageRoute(builder: (context) => SurveyScreen()),
                      );
                    },
                    child: Text("睡眠と体調アンケートに進む"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // ログアウトボタンとの間にスペースを追加
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SurveyScreen()), // SurveyScreenに遷移
                  );
                },
                child: Text("アンケートへ進む"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
