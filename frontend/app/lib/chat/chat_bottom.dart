import 'dart:convert';
import 'dart:typed_data';

import 'package:app/api/message/ws/ws.dart';
import 'package:app/chat/audio_queue.dart';
import 'package:app/chat/color.dart';
import 'package:app/chat/size.dart';
import 'package:app/color.dart';
import 'package:app/provider/message_provider.dart';
import 'package:app/provider/socket_state_provider.dart';
import 'package:app/provider/speak_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatBottom extends StatefulWidget {
  const ChatBottom({super.key});

  @override
  State<ChatBottom> createState() => _ChatBottomState();
}

class _ChatBottomState extends State<ChatBottom> {
  final SpeechToText _speechToText = SpeechToText();
  final AudioQueue _audioQueue = AudioQueue();
  final ChatWebsocket _webSocket = ChatWebsocket();
  final TextEditingController controller = TextEditingController();
  final speechListenOptions = SpeechListenOptions(partialResults: false);
  MessageProvider? messageProvider;
  SpeakProvider? speakProvider;
  SocketStateProvider? socketStateProvider;
  bool _isRecognition = false;
  bool _speechEnabled = false;
  //送信iconかマイクiconかを判断するのに利用
  bool isTextFieldSet = false;

  void _onSpeechResult(SpeechRecognitionResult result) async {
    //メッセージ送信時に音声認識をストップ
    _speechToText.stop();

    if (messageProvider == null) {
      throw Exception("_onSpeechResult: messageProvider is null");
    }

    if (socketStateProvider == null) {
      throw Exception("_onSpeechResult: socketStateProvider is null");
    }

    //送信するメッセージを更新
    textChangeHandler(result.recognizedWords);

    //送信
    await messageProvider!.sendMessageHandler(_messageAcceptedCallback,
        socketStateProvider!.getChatModel, socketStateProvider!.getSynthModel,
        messageAcceptFinishCallback: _sttMessageAcceptFinishCallback);

    //空文字に更新
    textChangeHandler("");
    //textFieldをクリア
    controller.clear();
  }

  //音声認識の状態を通知する関数
  void _onSpeechStatus(String? status) {
    if (status == "listening") {
      setState(() {
        _isRecognition = true;
      });
    } else if (status == "notListening") {
      setState(() {
        _isRecognition = false;
      });
    }
  }

  void _startVoiceRecognitionHandler() async {
    _speechEnabled = await _speechToText.initialize(onStatus: _onSpeechStatus);
    if (_speechEnabled) {
      await _speechToText.listen(
          onResult: _onSpeechResult, listenOptions: speechListenOptions);
    } else {
      print("The user has denied the use of speech recognition.");
    }
    return;
  }

  void _sttMessageAcceptFinishCallback() {
    //音声認識を再開
    _startVoiceRecognitionHandler();
  }

  void _stopVoiceRecognitionHandler() async {
    _speechToText.stop();
    setState(() {});
  }

  void _messageAcceptedCallback(
      String base64Data, String text, int newSpeakerId) async {
    //isWaitFirstMessageがtrueの場合falseにする
    if (messageProvider != null) {
      if (messageProvider!.isWaitFirstMessage) {
        messageProvider!.isWaitFirstMessage = false;
      }
    }

    if (speakProvider != null) {
      //speakerIdを更新
      speakProvider?.setSpeakerId = newSpeakerId;
    }

    //set character message
    messageProvider!.setConversationHistory(text, false);

    //audio data decode
    Uint8List decodedAudio = base64Decode(base64Data);

    //play audio
    _audioQueue.add(decodedAudio);
  }

  //textfieldに変化があった際に呼び出される関数
  void textChangeHandler(String newSendMessage) {
    if (messageProvider == null) {
      throw Exception("_onSpeechResult: messageProvider is null");
    }
    messageProvider!.setSendMessage = newSendMessage;
    if (isTextFieldSet != messageProvider!.getSendMessage.isNotEmpty) {
      setState(() {
        isTextFieldSet = messageProvider!.getSendMessage.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //watchで再描画
    messageProvider = context.watch<MessageProvider>();
    speakProvider = context.watch<SpeakProvider>();
    socketStateProvider = context.watch<SocketStateProvider>();

    //デバイスの画面サイズを取得
    final Size deviceSize = MediaQuery.of(context).size;
    return Container(
      //debug時に範囲を可視化する
      // color: Colors.amber,
      width: deviceSize.width,
      height: textFieldHeight,
      alignment: Alignment.center,
      child: _webSocket.getNowRecieving()
          //メッセージ送信してから、メッセージ受信完了までプログレスサークル表示
          ? CircularProgressIndicator(
              strokeWidth: 7,
              color: whiteTransparentColor,
            )
          : _isRecognition
              ? IconButton(
                  alignment: Alignment.bottomCenter,
                  tooltip: '対話停止',
                  onPressed: _stopVoiceRecognitionHandler,
                  icon: CircleAvatar(
                    radius: stopIconCircleR,
                    backgroundColor: baseColor,
                    child: Icon(
                      size: stopIconSize,
                      Icons.stop_circle,
                      color: Colors.white,
                    ),
                  ))
              : Row(
                  children: [
                    Expanded(
                      //テキストボックス
                      child: Container(
                        margin: EdgeInsets.fromLTRB(marginX, 0, 0, 0),
                        child: TextField(
                          controller: controller,

                          //Enter押したときに送信
                          onSubmitted: (_) async {
                            await messageProvider!.sendMessageHandler(
                              _messageAcceptedCallback,
                              socketStateProvider!.getChatModel,
                              socketStateProvider!.getSynthModel,
                            );

                            //空文字に更新
                            textChangeHandler("");
                            //textFieldをクリア
                            controller.clear();
                          },

                          //input text color
                          style: TextStyle(
                            color: inputFontColor,
                            fontWeight: FontWeight.w600,
                          ),

                          //corsur color
                          cursorColor: inputFontColor,
                          decoration: InputDecoration(
                            //border
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                color: borderColor,
                                width: focusedTextFieldBorderSize,
                              ),
                            ),

                            //入力部分の背景色
                            filled: true,
                            fillColor: whiteTransparentColor,
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,

                            hintText: "メッセージを入力 ...",
                            //hint text color
                            hintStyle: TextStyle(
                              color: hintFontColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onChanged: textChangeHandler,
                        ),
                      ),
                    ),

                    //テキストボックスの左のアイコン(送信, マイクアイコン)
                    Container(
                      margin: EdgeInsets.fromLTRB(marginX, 0, marginX, 0),
                      child: isTextFieldSet
                          ? IconButton(
                              tooltip: '送信',
                              icon: CircleAvatar(
                                radius: iconCircleR,
                                backgroundColor: baseColor,
                                child: Icon(
                                  Icons.send_rounded,
                                  size: iconSize,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () async {
                                await messageProvider!.sendMessageHandler(
                                  _messageAcceptedCallback,
                                  socketStateProvider!.getChatModel,
                                  socketStateProvider!.getSynthModel,
                                );
                                //空文字に更新
                                textChangeHandler("");
                                //textFieldをクリア
                                controller.clear();
                              },
                            )
                          : IconButton(
                              tooltip: 'マイク',
                              icon: CircleAvatar(
                                radius: iconCircleR,
                                backgroundColor: baseColor,
                                child: Icon(
                                  Icons.mic,
                                  size: iconSize,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: _startVoiceRecognitionHandler,
                            ),
                    ),
                  ],
                ),
    );
  }
}
