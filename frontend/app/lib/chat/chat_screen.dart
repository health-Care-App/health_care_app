import 'package:app/chat/chat_bottom.dart';
import 'package:app/chat/chat_screen_body.dart';
import 'package:app/provider/message_provider.dart';
import 'package:app/provider/speak_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../user_info.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => MessageProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => SpeakProvider()),
      ],
      builder: (context, child) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("チャット画面"),
            actions: [
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  final User? user = FirebaseAuth.instance.currentUser;
                  final String email = user?.email ?? "メールアドレスがありません";

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            // ログイン中のメールアドレスを渡す
                            UserInfoScreen(email: email)),
                  );
                },
              ),
            ],
          ),
          body: ChatScreenBody(),

          // display textField
          bottomNavigationBar: ChatBottomAppBar(),
        ),
      ),
    );
  }
}
