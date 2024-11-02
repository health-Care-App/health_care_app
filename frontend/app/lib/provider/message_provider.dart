import 'package:app/api/message/ws/ws.dart';
import 'package:app/chat/audio_queue.dart';
import 'package:flutter/material.dart';

class MessageProvider with ChangeNotifier {
  //websocket, サウンドキュー, textコントローラを初期化
  final _socket = ChatWebsocket();
  final audioQueue = AudioQueue();
  final TextEditingController controller = TextEditingController();

  MessageProvider()
      : _sendMessage = "",
        messages = [],
        isTextSet = false;

  //送信メッセージ
  String _sendMessage;

  //送信iconかマイクiconかを判断するのに利用
  bool isTextSet;

  //対話メッセージデータ
  List<Map<String, dynamic>> messages;

  //getter
  String get getSendMessage => _sendMessage;

  //messageに変化があった際に呼び出される関数
  void textChangeHandler(String newSendMessage) {
    _sendMessage = newSendMessage;
    isTextSet = _sendMessage.isNotEmpty;

    notifyListeners();
  }

  //message送信を処理する関数
  void sendMessageHandler(
      void Function(String, String, int) messageAcceptedCallback,
      {void Function()? messageAcceptFinishCallback}) async {
    if (ChatWebsocket.isWsStart == false) {
      await _socket.wsStart((String base64Data, String text, int newSpeakerId) {
        messageAcceptedCallback(base64Data, text, newSpeakerId);
        notifyListeners();
      }, messageAcceptFinishCallback: messageAcceptFinishCallback);
    }

    ChatWebsocket.isWsStart = true;

    if (_sendMessage.isEmpty) {
      return;
    }

    if (!_socket.getNowRecieving()) {
      _socket.wsSend(_sendMessage, 0, 0, true);
      messages.add({"text": _sendMessage, "isUser": true});
    }

    //textFieldをクリア
    controller.clear();
    //iconを変更をさせるため空文字でハンドラを呼び出し
    textChangeHandler("");
    notifyListeners();
  }
}
