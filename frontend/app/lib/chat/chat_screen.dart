import 'package:app/chat/chat_bar_selector.dart';
import 'package:app/chat/chat_screen_body.dart';
import 'package:app/chat/size.dart';
import 'package:app/color.dart';
import 'package:app/provider/message_provider.dart';
import 'package:app/provider/socket_state_provider.dart';
import 'package:app/provider/speak_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../user_info.dart';
import '../survey.dart';
import 'package:app/check_recent_data.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _checkRecentData();
  }

  Future<void> _checkRecentData() async {
    final isToday = await isRecentDataToday();
    if (!isToday) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SurveyScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (BuildContext context) => MessageProvider()),
          ChangeNotifierProvider(
              create: (BuildContext context) => SpeakProvider()),
          ChangeNotifierProvider(
              create: (BuildContext context) => SocketStateProvider()),
        ],
        builder: (context, child) => MaterialApp(
              home: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  toolbarHeight: appBarHeight,
                  elevation: 0,
                  backgroundColor: baseColor,
                  leadingWidth: 500,
                  leading: ChatBarSelector(),
                  actions: [
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
                            child: user != null
                                ? ClipOval(
                                    child: Image.network(user!.photoURL!))
                                : ClipOval(child: Icon(Icons.person))))
                  ],
                ),
                body: ChatScreenBody(),
              ),
            ));
  }
}
