import 'package:app/api/export.dart';
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
  MessageProvider? messageProvider;
  //<m1>abc</m1><m1>def</m1> -> ["abc", "def"]みたいに変換する関数
  List<String> parseAnswers(String aiMessage) {
    final List<String> parsedMessages = [];
    final exp = RegExp(r'<m\d+>(.+?)<\/m\d+>');
    final matches = exp.allMatches(aiMessage);
    for (final m in matches) {
      if (m[1] == null) {
        continue;
      }
      parsedMessages.add(m[1]!);
    }
    return parsedMessages;
  }

  //対話履歴を取得する関数
  Future<void> getConversationHistory() async {
    GetMessageResponse resp = await getMessage();
    if (resp.messages == null) {
      return;
    }
    if (resp.messages!.isEmpty) {
      return;
    }
    if (messageProvider == null) {
      throw ("getMessageHistory: messageProvider is null");
    }

    for (Messages messages in resp.messages!) {
      messageProvider!.setConversationHistory(messages.question, true);
      final aiMessages = parseAnswers(messages.answer);
      for (final message in aiMessages) {
        messageProvider!.setConversationHistory(message, false);
      }
    }
  }

  //初回描画時にのみ実行される処理
  @override
  void initState() {
    getConversationHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    messageProvider = context.watch<MessageProvider>();

    //デバイスの画面サイズを取得
    final Size deviceSize = MediaQuery.of(context).size;
    return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messageProvider!.getCoversationHistory.length,
                    itemBuilder: (context, index) {
                      bool isUserMessage = messageProvider!
                          .getCoversationHistory[index]["isUser"];
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
                              child: Text(messageProvider!
                                  .getCoversationHistory[index]["text"]),
                            ),
                          ));
                    },
                  ),
                )
              ],
            );
  }
}
