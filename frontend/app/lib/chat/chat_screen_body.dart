import 'package:app/chat/character_progress.dart';
import 'package:app/chat/chat_bottom.dart';
import 'package:app/chat/chat_character.dart';
import 'package:app/chat/chat_text.dart';
import 'package:app/chat/size.dart';
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
    //デバイスの画面サイズを取得
    final Size deviceSize = MediaQuery.of(context).size;
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;

    return Stack(children: [
      //display character image
      ChatCharacter(),

      //メッセージを送った時のプログレスサークル
      Consumer<MessageProvider>(
        builder: (context, messageProvider, _) =>
            messageProvider.isWaitFirstMessage
                ? CharacterProgress(text: "考え中...")
                : SizedBox(), //空要素
      ),

      Positioned(
        top: deviceSize.width > mobileWidth
            ? textAreaPCOffset
            : textAreaMobileOffset,
        child: SizedBox(
          //会話ボックスの位置調整
          height: deviceSize.height -
              (deviceSize.width > mobileWidth
                  ? textAreaPCOffset
                  : textAreaMobileOffset) -
              textFieldHeight -
              appBarHeight,
          width: deviceSize.width,
          child: ChatText(),
        ),
      ),

      Positioned(
        top: deviceSize.height - textFieldHeight - appBarHeight - bottomSpace,
        child: ChatBottom(),
      )
    ]);
  }
}
