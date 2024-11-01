import 'package:flutter/material.dart';

class ChatBottomAppBar extends StatefulWidget {
  final void Function() sendMessageHandler;
  const ChatBottomAppBar({
    super.key,
    required this.sendMessageHandler,
  });

  @override
  State<ChatBottomAppBar> createState() => _ChatBottomAppBarState();
}

class _ChatBottomAppBarState extends State<ChatBottomAppBar> {
  final TextEditingController _controller = TextEditingController();
  bool isTextSet = false;

  void _textFieldChangeHandler(String text) {
    if (text.isNotEmpty) {
      setState(() => isTextSet = true);
    } else {
      setState(() => isTextSet = false);
    }
    return;
  }

  void _startVoiceRecognitionHandler() {
    return;
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        color: Colors.blueAccent,
        child: Row(children: [
          Flexible(
            child: TextField(
              controller: _controller,

              //input text color
              style: TextStyle(color: Colors.white),

              //corsur color
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: "メッセージを入力",

                //hint text color
                hintStyle: TextStyle(color: Colors.white),

                //border style
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
              onChanged: _textFieldChangeHandler,
            ),
          ),
          isTextSet
              ? IconButton(
                  tooltip: '送信',
                  icon: const Icon(Icons.send_rounded),
                  onPressed: widget.sendMessageHandler,
                  color: Colors.white,
                )
              : IconButton(
                  tooltip: 'マイク',
                  icon: const Icon(Icons.mic),
                  onPressed: _startVoiceRecognitionHandler,
                  color: Colors.white,
                ),
        ]));
  }
}
