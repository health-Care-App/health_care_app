import 'package:app/chat/size.dart';
import 'package:app/provider/socket_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ChatSelector extends StatefulWidget {
  const ChatSelector({super.key});
  @override
  State<ChatSelector> createState() => _ChatSelectorState();
}

class _ChatSelectorState extends State<ChatSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(0, 255, 193, 7),
      height: 200,
      width: 200,
      child: Column(
        children: [
          Text("AIモデル"),
          Consumer<SocketStateProvider>(
              builder: (context, socketStateProvider, _) => Wrap(
                    spacing: 25.0,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                socketStateProvider.getChatModel == 0
                                    ? const Color.fromARGB(117, 110, 219, 255)
                                    : Colors.transparent,
                            radius: iconSize,
                            child: IconButton(
                              icon: SvgPicture.asset(
                                "assets/images/openai-logomark.svg",
                                width: iconSize,
                                height: iconSize,
                              ),
                              onPressed: () {
                                socketStateProvider.setChatModel = 0;
                              },
                            ),
                          ),
                          Text(
                            "GPT",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                socketStateProvider.getChatModel == 1
                                    ? const Color.fromARGB(117, 110, 219, 255)
                                    : Colors.transparent,
                            radius: iconSize,
                            child: IconButton(
                              icon: SvgPicture.asset(
                                "assets/images/gemini.svg",
                                width: iconSize,
                                height: iconSize,
                              ),
                              onPressed: () {
                                socketStateProvider.setChatModel = 1;
                              },
                            ),
                          ),
                          Text(
                            "Gemini",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          )
                        ],
                      )
                    ],
                  )),
          Text("キャラクター"),
          Consumer<SocketStateProvider>(
            builder: (context, socketStateProvider, _) => Wrap(
              // spacing: 10.0,
              runSpacing: 10.0,
              children: [
                ChoiceChip(
                  showCheckmark: false,
                  label: Text("ずんだもん"),
                  selected: socketStateProvider.getSynthModel == 0,
                  backgroundColor: Colors.grey[600],
                  selectedColor: Colors.white,
                  onSelected: (_) {
                    socketStateProvider.setSynthModel = 0;
                  },
                ),
                ChoiceChip(
                  showCheckmark: false,
                  label: Text("春日部つむぎ"),
                  selected: socketStateProvider.getSynthModel == 1,
                  backgroundColor: Colors.grey[600],
                  selectedColor: Colors.white,
                  onSelected: (_) {
                    socketStateProvider.setSynthModel = 1;
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
