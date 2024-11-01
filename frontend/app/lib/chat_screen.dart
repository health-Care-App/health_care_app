import 'dart:convert';
import 'dart:typed_data';

import 'package:app/chat_bottom.dart';
import 'package:app/api/export.dart';
import 'package:app/chat_character.dart';
import 'package:app/chat_text.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_info.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _controller = TextEditingController();
  final player = AudioPlayer();
  final socket = ChatWebsocket();
  var isWsStart = false;
  var spakerId = 1;

  void _callbackAfterSended(
      String base64Data, String text, int speakerId) async {
    //set message
    messages.add({"text": text, "isUser": false});

    //audio data decode
    Uint8List decodedAudio = base64Decode(base64Data);

    //play audio
    await player.setSourceBytes(decodedAudio);
    await player.resume();
  }

  void sendMessageHandler() async {
    if (isWsStart == false) {
      await socket.wsStart(_callbackAfterSended);
    }

    if (_controller.text.isNotEmpty) {
      socket.wsSend(_controller.text, 0, 0, true);
      await Future.delayed(Duration(seconds: 20));
      setState(() {
        messages.add({"text": _controller.text, "isUser": true});
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text("チャット画面"),
              actions: [
                IconButton(
                  icon: Icon(Icons.info),
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
                        maxWidth: 700,
                        maxHeight: 1000,
                        child: ClipRect(
                            child: ChatCharacter(speakerId: spakerId)))),

                // display message chat
                ChatText(messages: messages)
              ],
            ),
            bottomNavigationBar:
                ChatBottomAppBar(sendMessageHandler: sendMessageHandler)));
  }
}
