import 'package:app/chat/size.dart';
import 'package:app/provider/socket_state_provider.dart';
import 'package:app/provider/speak_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ChatBarSelector extends StatefulWidget {
  const ChatBarSelector({super.key});
  @override
  State<ChatBarSelector> createState() => _ChatBarSelectorState();
}

class _ChatBarSelectorState extends State<ChatBarSelector> {
  @override
  Widget build(BuildContext context) {
    SpeakProvider speakProvider = context.watch<SpeakProvider>();
    return Consumer<SocketStateProvider>(
      builder: (context, socketStateProvider, _) => Row(
        children: [
          //aiモデル選択プルダウン
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: DropdownButton(
              value: socketStateProvider.getChatModel,
              focusColor: const Color.fromARGB(0, 0, 0, 0),
              items: [
                DropdownMenuItem(
                  value: 0,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        child: SvgPicture.asset(
                          "assets/images/openai-logomark.svg",
                          width: dropDownIconSize,
                          height: dropDownIconSize,
                        ),
                      ),
                      Text('ChatGPT'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        child: SvgPicture.asset(
                          "assets/images/gemini.svg",
                          width: dropDownIconSize,
                          height: dropDownIconSize,
                        ),
                      ),
                      Text('Gemini'),
                    ],
                  ),
                )
              ],
              onChanged: (int? value) {
                socketStateProvider.setChatModel = value!;
              },
            ),
          ),

          //キャラクター選択プルダウン
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: DropdownButton(
              value: socketStateProvider.getSynthModel,
              focusColor: const Color.fromARGB(0, 0, 0, 0),
              items: [
                DropdownMenuItem(
                  value: 0,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        child: SvgPicture.asset(
                          "assets/images/openai-logomark.svg",
                          width: dropDownIconSize,
                          height: dropDownIconSize,
                        ),
                      ),
                      Text('ずんだもん'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        child: SvgPicture.asset(
                          "assets/images/gemini.svg",
                          width: dropDownIconSize,
                          height: dropDownIconSize,
                        ),
                      ),
                      Text('春日部つむぎ'),
                    ],
                  ),
                ),
              ],
              onChanged: (int? value) {
                socketStateProvider.setSynthModel = value!;
                //表示する画像を変更
                if (value == 0) {
                  speakProvider.setSpeakerId = 1; //ずんだもんデフォルトIDを指定
                } else if (value == 1) {
                  speakProvider.setSpeakerId = 8; //春日部つむぎデフォルトIDを指定
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
