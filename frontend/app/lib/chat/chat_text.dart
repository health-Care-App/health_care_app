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
    //  final MessageProvider messageProvider = context.watch<MessageProvider>();

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
                        child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: isUserMessage
                                  ? const Color.fromARGB(185, 187, 222, 251)
                                  : const Color.fromARGB(185, 200, 230, 201),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:
                                Text(messageProvider.messages[index]["text"])),
                      );
                    },
                  ),
                ),
              ],
            ));
  }
}
