import 'package:app/chat/color.dart';
import 'package:app/provider/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatText extends StatefulWidget {
  const ChatText({super.key});

  @override
  State<ChatText> createState() => _ChatTextState();
}

class _ChatTextState extends State<ChatText> {
  @override
  Widget build(BuildContext context) {
    //デバイスの画面サイズを取得
    final Size deviceSize = MediaQuery.of(context).size;
    return Consumer<MessageProvider>(
        builder: (context, messageProvider, _) => Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messageProvider.messages.length,
                    itemBuilder: (context, index) {
                      bool isUserMessage =
                          messageProvider.messages[index]["isUser"];
                      return Align(
                          alignment: isUserMessage
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              //画面横幅の0.7倍までをメッセージの最大幅とする
                              maxWidth: deviceSize.width * 0.7,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: isUserMessage
                                    ? userMessageColor
                                    : whiteTransparentColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child:
                                  Text(messageProvider.messages[index]["text"]),
                            ),
                          ));
                    },
                  ),
                ),
              ],
            ));
  }
}
