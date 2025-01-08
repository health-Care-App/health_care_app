import 'package:app/color.dart';
import 'package:app/google_auth/auth.dart';
import 'package:app/sign_in/color.dart';
import 'package:app/sign_in/sign_in_button.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String signInText = 'サインイン';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Image.asset(
                "assets/images/app_logo.webp",
                width: 400,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
              child: Text(
                signInText,
                style: TextStyle(
                  fontSize: 20,
                  color: textColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            //サインインボタン
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 100),
              child: FutureBuilder(
                future: Authentication.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error initializing Firebase');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return const SignInButton();
                  }
                  return const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.orange,
                    ),
                  );
                },
              ),
            ),
            //voicevoxの利用を明記
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: Text(
                'このアプリは音声合成ソフトウェアVOICEVOXを利用しています。',
                style: TextStyle(
                  fontSize: 13,
                  color: textColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
