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
        _coversationHistory = [],
        isTextSet = false,
        isWaitFirstMessage = false;

  //送信メッセージ
  String _sendMessage;

  //送信iconかマイクiconかを判断するのに利用
  bool isTextSet;

  //メッセージを送信してから初めてメッセージを受け取るまでtrue
  bool isWaitFirstMessage;

  //対話メッセージデータ
  final List<Map<String, dynamic>> _coversationHistory;

  //getter
  String get getSendMessage => _sendMessage;
  List<Map<String, dynamic>> get getCoversationHistory => _coversationHistory;

  //メッセージをセットする関数
  void setConversationHistory(String text, bool isUser) {
    _coversationHistory.add({"text": text, "isUser": isUser});
    notifyListeners();
  }

  //textfieldに変化があった際に呼び出される関数
  void textChangeHandler(String newSendMessage) {
    _sendMessage = newSendMessage;

    if (isTextSet != _sendMessage.isNotEmpty) {
      isTextSet = _sendMessage.isNotEmpty;
      notifyListeners();
    }
  }

  //message送信を処理する関数
  void sendMessageHandler(
      void Function(String, String, int) messageAcceptedCallback,
      chatModel,
      synthModel,
      {void Function()? messageAcceptFinishCallback}) async {
    //入力された文字がない場合はreturn
    if (_sendMessage.isEmpty) {
      return;
    }

    //websocket通信が始まってない場合は通信開始
    if (ChatWebsocket.isWsStart == false) {
      await _socket.wsStart((String base64Data, String text, int newSpeakerId) {
        messageAcceptedCallback(base64Data, text, newSpeakerId);
        notifyListeners();
      }, messageAcceptFinishCallback: () {
        messageAcceptFinishCallback;
        notifyListeners();
      });
    }

    //サーバーからのメッセージ待ち出ない場合は送信する。
    if (!_socket.getNowRecieving()) {
      _socket.wsSend(_sendMessage, chatModel, synthModel, true);
      _coversationHistory.add({"text": _sendMessage, "isUser": true});
      isWaitFirstMessage = true;
    }

    //textFieldをクリア
    controller.clear();
    //iconを変更をさせるため空文字でハンドラを呼び出し
    textChangeHandler("");
    notifyListeners();
  }
}
