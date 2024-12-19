import 'package:app/api/message/ws/ws.dart';
import 'package:app/chat/audio_queue.dart';
import 'package:flutter/material.dart';

class MessageProvider with ChangeNotifier {
  //websocket, サウンドキューを初期化
  final _socket = ChatWebsocket();
  final audioQueue = AudioQueue();

  MessageProvider()
      : _sendMessage = "",
        _coversationHistory = [],
        isWaitFirstMessage = false;

  //送信メッセージ
  String _sendMessage;

  //メッセージを送信してから初めてメッセージを受け取るまでtrue
  bool isWaitFirstMessage;

  //対話メッセージデータ
  final List<Map<String, dynamic>> _coversationHistory;

  //getter
  String get getSendMessage => _sendMessage;
  List<Map<String, dynamic>> get getCoversationHistory => _coversationHistory;

  set setSendMessage(String newSendMessage) {
    _sendMessage = newSendMessage;
  }

  //メッセージをセットする関数
  void setConversationHistory(String text, bool isUser) {
    _coversationHistory.add({"text": text, "isUser": isUser});
    notifyListeners();
  }

  //message送信を処理する関数
  Future<void> sendMessageHandler(
      void Function(String, String, int) messageAcceptedCallback,
      chatModel,
      synthModel,
      {void Function()? messageAcceptFinishCallback}) async {
    //入力された文字がない場合はreturn
    _sendMessage = _sendMessage.trim();
    if (_sendMessage.isEmpty) {
      return;
    }

    //websocket通信が始まってない場合は通信開始
    if (ChatWebsocket.isWsStart == false) {
      await _socket.wsStart((String base64Data, String text, int newSpeakerId) {
        messageAcceptedCallback(base64Data, text, newSpeakerId);
        notifyListeners();
      }, () {
        if (messageAcceptFinishCallback != null) {
          messageAcceptFinishCallback();
        }
        notifyListeners();
      });
    }

    //サーバーからのメッセージ待ち出ない場合は送信する。
    if (!_socket.getNowRecieving()) {
      _socket.wsSend(_sendMessage, chatModel, synthModel, true);
      _coversationHistory.add({"text": _sendMessage, "isUser": true});
      isWaitFirstMessage = true;
    }
    notifyListeners();
    print("sendMessageHandler end");
  }
}
