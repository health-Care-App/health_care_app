import 'package:app/chat/chat_bottom.dart';
import 'package:app/chat/chat_screen_body.dart';
import 'package:app/provider/message_provider.dart';
import 'package:app/provider/speak_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../user_info.dart';

const double userIconSize = 35;
const double usrIconMarginSize = 10;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

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
              //ユーザーアイコン
              Container(
                  height: userIconSize,
                  width: userIconSize,
                  margin: EdgeInsets.all(usrIconMarginSize),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserInfoScreen()),
                        );
                      },
                      //ユーザーアイコン取得失敗時にperson icon表示
                      child: user != null
                          ? ClipOval(child: Image.network(user!.photoURL!))
                          : ClipOval(child: Icon(Icons.person))))
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
