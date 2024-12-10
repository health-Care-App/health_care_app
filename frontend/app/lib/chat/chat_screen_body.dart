import 'package:app/chat/chat_bottom.dart';
import 'package:app/chat/chat_character.dart';
import 'package:app/chat/chat_text.dart';
import 'package:app/provider/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const textAreaPCOffset = 180.0;
const textAreaMobileOffset = 330.0;
const mobileWidth = 450; //これより大きい幅の場合をPC端末とする

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

    return Stack(children: [
      //display character image
      ChatCharacter(),

      //メッセージを送った時のプログレスサークル
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

      Positioned(
        top: deviceSize.width > mobileWidth
            ? textAreaPCOffset
            : textAreaMobileOffset,
        child: Column(
          children: [
            SizedBox(
                //会話ボックスの位置調整
                height: deviceSize.height -
                    (deviceSize.width > mobileWidth
                        ? textAreaPCOffset
                        : textAreaMobileOffset) -
                    textFieldHeight -
                    50, //50分はappBar?
                width: deviceSize.width,
                child: Expanded(child: ChatText())),
          ],
        ),
      ),
      Positioned(
          top: deviceSize.height - textFieldHeight - 50, //50分はappBar?
          child: ChatBottomAppBar())
    ]);
  }
}
