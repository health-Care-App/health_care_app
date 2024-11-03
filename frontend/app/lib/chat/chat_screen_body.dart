import 'package:app/chat/chat_character.dart';
import 'package:app/chat/chat_text.dart';
import 'package:app/provider/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreenBody extends StatefulWidget {
  const ChatScreenBody({super.key});

  @override
  State<ChatScreenBody> createState() => _ChatScreenBodyState();
}

class _ChatScreenBodyState extends State<ChatScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      //display character image
      ChatCharacter(),
      Consumer<MessageProvider>(
        builder: (context, messageProvider, _) =>
            messageProvider.isWaitFirstMessage
                ? SizedBox(
                    width: 700,
                    child: Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                        )))
                : SizedBox(), //空要素
      ),

      // display message chat
      ChatText()
    ]);
  }
}
