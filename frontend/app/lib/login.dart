import 'package:app/google_auth/auth.dart';
import 'package:app/google_auth/sign_in_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String infoText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(infoText),
              ),
              const SizedBox(height: 16), // ログインボタンと登録リンクの間隔を広げる
              // 新規登録リンク
              FutureBuilder(
                future: Authentication.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error initializing Firebase');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return const GoogleSignInButton();
                  }
                  return const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.orange,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // String _getErrorMessage(FirebaseAuthException e) {
  //   switch (e.code) {
  //     case 'invalid-email':
  //       return 'メールアドレスの形式が正しくありません。';
  //     case 'user-disabled':
  //       return 'このユーザーアカウントは無効化されています。';
  //     case 'user-not-found':
  //       return 'ユーザーが見つかりません。';
  //     case 'wrong-password':
  //       return 'パスワードが間違っています。';
  //     case 'invalid-credential':
  //       return 'メールアドレスもしくはパスワードが間違っています。';
  //     case 'too-many-requests':
  //       return 'リクエストが多すぎます。しばらくしてから再試行してください。';
  //     default:
  //       return 'エラーが発生しました: ${e.code}';
  //   }
  // }
}
