import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

import 'package:app/api/message/ws/type.dart';
import 'package:app/api/utils/export.dart';

class ChatWebsocket {
  static final ChatWebsocket _instance = ChatWebsocket._internal();
  WebSocketChannel? _channel;

  //データを送信し、空データが返ってくるまでtrue、それ以外の時はfalseのフィールド
  static bool _nowRecieving = false;

  factory ChatWebsocket() {
    return _instance;
  }

  ChatWebsocket._internal();

  //_nowRecieveingのゲッターとセッター
  //送信してから受信が終わったかを確認する処理にゲッターを利用する想定
  getNowRecieving() => _nowRecieving;
  void setNowRecieving(bool newStatus) {
    if (_channel != null) {
      _nowRecieving = newStatus;
    } else {
      _nowRecieving = false;
    }
  }

  //WebSocket通信を開始
  Future<void> wsStart(void Function(String, String, int) callback) async {
    //idtoken取得
    String idToken;
    try {
      idToken = await getIdToken();
    } on Exception catch (e) {
      print("$idTokenException: $e");
      rethrow;
    }

    final wsUrl = Uri.parse("$wsPath?idToken=$idToken");
    _channel = WebSocketChannel.connect(wsUrl);
    if (_channel != null) {
      await _channel!.ready;
    } else {
      throw Exception("wsStart: failed to connect WebScoket");
    }

    _channel!.stream.listen(
      (response) {
        final jsonResponse = WsMessageResponse.fromJson(json.decode(response));
        if (jsonResponse.base64Data.isEmpty &&
            jsonResponse.text.isEmpty &&
            (jsonResponse.speakerId == 0)) {
          setNowRecieving(false);
          return;
        }
        //空データでない場合,引数で受け取ったcallback関数でデータを処理
        callback(
            jsonResponse.base64Data, jsonResponse.text, jsonResponse.speakerId);
      },
    );
  }

  //messageを送信
  void wsSend(String question, int chatModel, int synthModel, bool isSynth) {
    if (_channel == null) {
      print("wsSend: _channel was null");
      return;
    }
    if (getNowRecieving()) {
      print("wsSend: receiving other messages");
    }

    final request = WsMessageRequest(
        question: question,
        chatModel: chatModel,
        synthModel: synthModel,
        isSynth: isSynth);
    final requestJson = json.encode(request.toJson());
    //サーバーにデータを送信
    _channel!.sink.add(requestJson);
    setNowRecieving(true);
  }

  //Websocketを終了
  void wsClose() {
    if (_channel == null) {
      print("wsDone: _channel was null");
      return;
    }
    if (getNowRecieving()) {
      print("wsDone: receiving messages");
      return;
    }

    _channel!.sink.close();
    print("wsDone: websocket closed");
  }
}

//サンプルコールバック関数
//ここでWebSocket内で受け取ったデータで必要に応じてステートの変更などを処理する
void callback(String base64Data, String text, int speakerId) {
  print(base64Data);
  print(text);
  print(speakerId);
}

// 利用例

// void main() async {
//   ChatWebsocket socket = ChatWebsocket();
//   await socket.wsStart(callback);

//   //データを送信
//   socket.wsSend("眠いです", 0, 0, true);

//   //通信が終了するのを待ってからclose
//   await Future.delayed(Duration(seconds: 20));
//   socket.wsClose();
// }
