import 'package:app/chat/chat_screen.dart';
import 'package:app/custom_snackbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class Authentication {
  // Firebase initialization
  static Future<FirebaseApp?> initializeFirebase(
      {required BuildContext context}) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;

    //サインイン済みの場合、サインイン画面をスキップしてチャット画面に移動
    if (user != null) {
      //描画されていない場合は処理を中断。これがないと警告が出る
      if (!context.mounted) return null;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ChatScreen(),
        ),
      );
    }
    return firebaseApp;
  }

  // GoogleSignIn
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleSignInAccount;
    try {
      //認証 & 認可
      googleSignInAccount = await googleSignIn.signInSilently();

      //nullの場合、サインインに失敗している可能性があるのでエラーを起こす
      if (googleSignInAccount == null) throw Exception();
    } catch (_) {
      //描画されていない場合は処理を中断。これがないと警告が出る
      if (!context.mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          text:
              'サインインに失敗しました。サードパーティーのサインインをブロックしている可能性があります。',
          textColor: Colors.redAccent,
          backgroundColor: Colors.white,
        ),
      );
    }

    if (googleSignInAccount != null) {
      // Googleの認証情報を取得
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      // Firebase用の資格情報を作成
      AuthCredential credential;
      credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // Firebaseに認証情報を登録
      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          //描画されていない場合は処理を中断。これがないと警告が出る
          if (!context.mounted) return null;
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              text: 'The account already exists with a different credential.',
              textColor: Colors.redAccent,
              backgroundColor: Colors.black,
            ),
          );
        } else if (e.code == 'invalid-credential') {
          //描画されていない場合は処理を中断。これがないと警告が出る
          if (!context.mounted) return null;
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
              text: 'Error occurred while accessing credentials. Try again.',
              textColor: Colors.redAccent,
              backgroundColor: Colors.black,
            ),
          );
        }
      } catch (e) {
        //描画されていない場合は処理を中断。これがないと警告が出る
        if (!context.mounted) return null;
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            text: 'Error occurred using Google Sign-In. Try again.',
            textColor: Colors.redAccent,
            backgroundColor: Colors.black,
          ),
        );
      }
    }
    return user;
  }

  // GoogleSignOut
  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      //描画されていない場合は処理を中断。これがないと警告が出る
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          text: 'Error signing out. Try again.',
          textColor: Colors.redAccent,
          backgroundColor: Colors.black,
        ),
      );
    }
  }

  static getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }
}
