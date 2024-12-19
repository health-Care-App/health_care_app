import 'package:app/chat/chat_screen.dart';
import 'package:app/google_auth/auth.dart';
import 'package:app/sign_in/color.dart';
import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () async {
          final user = await Authentication.signInWithGoogle(context: context);

          if (user != null) {
            //描画されていない場合は処理を中断
            //これがないと青い警告が出る
            if (!context.mounted) return;
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return ChatScreen();
                },

                //画面遷移時のアニメーション
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  // final Offset begin = Offset(1.0, 0.0); // 右から左
                  final Offset begin = Offset(-1.0, 0.0); // 左から右
                  final Offset end = Offset.zero;
                  final Animatable<Offset> tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: Curves.easeInOut));
                  final Animation<Offset> offsetAnimation =
                      animation.drive(tween);
                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              //Googleアイコン
              Image(
                image: AssetImage("assets/images/google_logo.webp"),
                height: 20.0,
              ),
              //ボタン文字
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Googleでサインイン',
                  style: TextStyle(
                    fontSize: 20,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
