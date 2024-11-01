import 'package:flutter/material.dart';

class ChatText extends StatefulWidget {
  final List<Map<String, dynamic>> messages;
  const ChatText({super.key, required this.messages});

  @override
  State<ChatText> createState() => _ChatTextState();
}

class _ChatTextState extends State<ChatText> {
  // Widget builderHandler(BuildContext context, AsyncSnapshot<String> snapshot) {
  //   if (snapshot.hasData) {
  //     //データを受け取った時の処理
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.messages.length,
            itemBuilder: (context, index) {
              bool isUserMessage = widget.messages[index]["isUser"];
              return Align(
                alignment: isUserMessage
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color:
                          isUserMessage ? Colors.blue[100] : Colors.green[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(widget.messages[index]["text"])),
              );
            },
          ),
        ),
      ],
    );
  }
}
