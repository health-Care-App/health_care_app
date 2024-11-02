import 'package:app/chat/audio_queue.dart';
import 'package:app/chat/chat_bottom.dart';
import 'package:app/api/export.dart';
import 'package:app/chat/chat_character.dart';
import 'package:app/chat/chat_text.dart';
import 'package:app/provider/message_provider.dart';
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
  final socket = ChatWebsocket();
  final audioQueue = AudioQueue();
  int speakerId = 1;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => MessageProvider(),
        child: MaterialApp(
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
                body: Stack(
                  children: [
                    //display character image
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: OverflowBox(
                            maxWidth: 1000,
                            maxHeight: 1000,
                            child: ClipRect(
                                child: ChatCharacter(speakerId: speakerId)))),

                    // display message chat
                    ChatText()
                  ],
                ),
                // display textField
                bottomNavigationBar: ChatBottomAppBar())));
  }
}
