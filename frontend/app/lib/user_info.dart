import 'package:app/google_auth/auth.dart';
import 'package:app/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInfoScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  UserInfoScreen({super.key});

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
            Text("睡眠時間の推移", style: TextStyle(fontSize: 18)),
            Container(
              color: Colors.grey[200],
              height: 200,
              width: double.infinity,
              child: Center(child: Text("睡眠時間の推移グラフ")),
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
              child: ElevatedButton(
                onPressed: () => _logout(context),
                child: Text("ログアウト"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
