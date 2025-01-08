import 'package:app/google_auth/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

import 'package:app/api/message/ws/type.dart';
import 'package:app/api/utils/export.dart';

class ChatWebsocket {
  static final ChatWebsocket _instance = ChatWebsocket._internal();
  WebSocketChannel? _channel;

  //データを送信し、空データが返ってくるまでtrue、それ以外の時はfalseのフィールド
  static bool _nowRecieving = false;

  //websocket通信が開始されているかどうか
  static bool isWsStart = false;

  factory ChatWebsocket() {
    return _instance;
  }

  ChatWebsocket._internal();

  //送信してから受信が終わったかを確認する処理にゲッターを利用する想定
  bool getNowRecieving() {
    return _nowRecieving;
  }

  void _setNowRecieving(bool newStatus) {
    if (_channel == null) {
      _nowRecieving = false;
    }
    _nowRecieving = newStatus;
  }

  //WebSocket通信を開始
  Future<void> wsStart(
      void Function(String, String, int) messageAcceptedCallback,
      void Function() messageAcceptFinishCallback) async {
    //idtoken取得
    final idToken = await Authentication.getIdToken();

    //環境によってwebsocketにアクセスするurlを変える
    String rootWsUrl;
    if (kDebugMode) {
      rootWsUrl = devWsPath;
    } else {
      rootWsUrl = prodWsPath;
    }

    final wsUrl = Uri.parse("$rootWsUrl?idToken=$idToken");
    _channel = WebSocketChannel.connect(wsUrl);
    if (_channel != null) {
      await _channel!.ready;
    } else {
      throw Exception("wsStart: failed to connect WebScoket");
    }

    isWsStart = true;
    _channel!.stream.listen(
      (response) {
        final jsonResponse = WsMessageResponse.fromJson(json.decode(response));
        //空データの場合
        if (jsonResponse.base64Data.isEmpty &&
            jsonResponse.text.isEmpty &&
            (jsonResponse.speakerId == 0)) {
          _setNowRecieving(false);

          messageAcceptFinishCallback();

          //debug log
          print("wsStart: all messages was recieved");
          return;
        }
        print("text:${jsonResponse.text}");
        //空データでない場合
        messageAcceptedCallback(
            jsonResponse.base64Data, jsonResponse.text, jsonResponse.speakerId);
      },
    );
  }

  // messageを送信 メッセージ送信成功時にtrueを返し, 失敗時にfalseを返す
  void wsSend(String question, int chatModel, int synthModel, bool isSynth) {
    if (_channel == null) {
      throw Exception("wsSend: _channel was null");
    }
    if (getNowRecieving()) {
      print("wsSend: receiving other messages");
      return;
    }

    final request = WsMessageRequest(
        question: question,
        chatModel: chatModel,
        synthModel: synthModel,
        isSynth: isSynth);
    final requestJson = json.encode(request.toJson());

    //サーバーにデータを送信
    _channel!.sink.add(requestJson);
    _setNowRecieving(true);
  }

  //Websocketを終了
  void wsClose() {
    if (_channel == null) {
      throw Exception("wsDone: _channel was null");
    }
    if (getNowRecieving()) {
      print("wsDone: receiving messages");
      return;
    }

    _channel!.sink.close();
    print("wsDone: websocket closed");
    isWsStart = false;
  }
}
