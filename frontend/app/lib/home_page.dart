import 'package:flutter/material.dart';
import 'dart:async';  // タイマー用

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // メッセージを保持するリスト
  List<Map<String, dynamic>> messages = [];

  // 入力されたメッセージを管理するコントローラー
  final TextEditingController _controller = TextEditingController();

  // メッセージを送信する処理
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        // ユーザーのメッセージをリストに追加
        messages.add({"text": _controller.text, "isUser": true});
        _controller.clear();  // 入力欄をクリア
      });

      // 1秒後に相手からの返信を追加する
      Timer(Duration(seconds: 1), () {
        setState(() {
          messages.add({"text": "相手の返信: ${messages.length + 1} 番目のメッセージ", "isUser": false});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("チャット画面"),
      ),
      body: Column(
        children: [
          // メッセージを表示するリストビュー
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                // メッセージがユーザーからか相手からかを区別
                bool isUserMessage = messages[index]["isUser"];
                return Align(
                  alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: isUserMessage ? Colors.blue[100] : Colors.green[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(messages[index]["text"]),
                  ),
                );
              },
            ),
          ),
          // メッセージ入力欄と送信ボタン
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // メッセージ入力欄
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "メッセージを入力",
                    ),
                  ),
                ),
                // 送信ボタン
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,  // ボタンを押したときの処理
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),  // ここでHomePageがチャット画面として使われる
    debugShowCheckedModeBanner: false,
  ));
}
