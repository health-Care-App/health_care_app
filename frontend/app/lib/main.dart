import 'package:app/sign_in/sign_in_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //開発環境の場合emulatorを使う
  if (kDebugMode) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.1', 8000);
      await FirebaseAuth.instance.useAuthEmulator('127.0.0.1', 9099);
    } catch (e) {
      rethrow;
    }
  }

  runApp(
    ProviderScope(
      //背景をグラデーションするため、アプリをcontainerでラップ
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // グラデーションの色を設定
              Color(0xffCDB4DB),
              Color(0xffBDE0FE),
              Colors.white,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter AppRun Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInScreen(),
    );
  }
}
