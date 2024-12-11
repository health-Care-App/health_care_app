import 'dart:convert';
import 'dart:typed_data';

import 'package:app/chat/audio_queue.dart';
import 'package:app/provider/message_provider.dart';
import 'package:app/provider/socket_state_provider.dart';
import 'package:app/provider/speak_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

// テキストボックスのパディング
const double marginX = 15;

//アイコンサイズ
const double iconSize = 27;
const double stopIconSize = 50;

//テキストフィールドのベース色
const baseColor = Color(0xffA2D2FF);

//テキストフィールドの初期値文字色
const hintFontColor = Color.fromARGB(255, 175, 175, 175);

//テキストフィールドのユーザーが入力する文字色
const inputFontColor = Color.fromARGB(255, 76, 76, 76);

//テキストフィールドのボーダーの色
const borderColor = baseColor;

//テキストフィールドのボーダの太さ
const borderWidth = 3.0;

//テキストフィールドの高さ
const textFieldHeight = 95.0;

//テキストフィールドの中の色
const fillColor = Color.fromARGB(220, 255, 255, 255);

class ChatBottomAppBar extends StatefulWidget {
  const ChatBottomAppBar({super.key});

  @override
  State<ChatBottomAppBar> createState() => _ChatBottomAppBarState();
}

class _ChatBottomAppBarState extends State<ChatBottomAppBar> {
  final SpeechToText _speechToText = SpeechToText();
  final AudioQueue _audioQueue = AudioQueue();
  MessageProvider? messageProvider;
  SpeakProvider? speakProvider;
  SocketStateProvider? socketStateProvider;
  bool _isListening = false;
  bool _speechEnabled = false;
  final speechListenOptions = SpeechListenOptions(partialResults: false);

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (messageProvider == null) {
      throw Exception("_onSpeechResult: messageProvider is null");
    }

    if (socketStateProvider == null) {
      throw Exception("_onSpeechResult: socketStateProvider is null");
    }

    //送信するメッセージを更新
    messageProvider!.textChangeHandler(result.recognizedWords);

    //送信
    messageProvider!.sendMessageHandler(_sttMessageAcceptedCallback,
        socketStateProvider!.getChatModel, socketStateProvider!.getSynthModel,
        messageAcceptFinishCallback: _sttMessageAcceptFinishCallback);
  }

  //音声認識の状態を通知する関数
  void _onSpeechStatus(String? status) {
    if (status == "listening") {
      setState(() {
        _isListening = true;
      });
    } else if (status == "notListening") {
      setState(() {
        _isListening = false;
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
    // _startVoiceRecognitionHandler();
  }

  void _stopVoiceRecognitionHandler() async {
    await _speechToText.stop();
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
    messageProvider!.messages.add({"text": text, "isUser": false});

    //audio data decode
    Uint8List decodedAudio = base64Decode(base64Data);

    //play audio
    _audioQueue.add(decodedAudio);
  }

  void _sttMessageAcceptedCallback(
      String base64Data, String text, int newSpeakerId) async {
    _messageAcceptedCallback(base64Data, text, newSpeakerId);

    //メッセージを受け取ってる間は音声認識をストップ
    _speechToText.stop();
  }

  @override
  Widget build(BuildContext context) {
    messageProvider = context.watch<MessageProvider>();
    speakProvider = context.watch<SpeakProvider>();
    socketStateProvider = context.watch<SocketStateProvider>();

    //デバイスの画面サイズを取得
    final Size deviceSize = MediaQuery.of(context).size;

    return Container(
      width: deviceSize.width,
      height: textFieldHeight,
      alignment: Alignment.center,
      child: _isListening
          ? IconButton(
              tooltip: '対話停止',
              icon: const Icon(Icons.stop_circle),
              onPressed: _stopVoiceRecognitionHandler,
              color: baseColor,
              iconSize: stopIconSize,
            )
          : Row(children: [
              //テキストボックス
              Expanded(
                  child: Container(
                margin: EdgeInsets.fromLTRB(marginX, 0, 0, 0),
                //テキストボックスの影
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 221, 221, 221),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(1, 1),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: TextField(
                  controller: messageProvider!.controller,

                  //Enter押したときに送信
                  onSubmitted: (String? _) {
                    messageProvider!.sendMessageHandler(
                        _messageAcceptedCallback,
                        socketStateProvider!.getChatModel,
                        socketStateProvider!.getSynthModel);
                  },

                  //input text color
                  style: TextStyle(
                      color: inputFontColor, fontWeight: FontWeight.w600),

                  //corsur color
                  cursorColor: inputFontColor,
                  decoration: InputDecoration(
                    hintText: "メッセージを入力",

                    //入力部分の背景色
                    filled: true,
                    fillColor: fillColor,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,

                    //hint text color
                    hintStyle: TextStyle(
                        color: hintFontColor, fontWeight: FontWeight.w600),

                    //border style
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                        width: borderWidth,
                        color: borderColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                        width: borderWidth,
                        color: borderColor,
                      ),
                    ),
                  ),
                  onChanged: messageProvider!.textChangeHandler,
                ),
              )),

              //テキストボックスの左のアイコン(送信, マイクアイコン)
              Container(
                margin: EdgeInsets.fromLTRB(marginX, 0, marginX, 0),
                child: messageProvider!.isTextSet
                    ? IconButton(
                        tooltip: '送信',
                        icon: const Icon(Icons.send_rounded),
                        iconSize: iconSize,
                        onPressed: () {
                          messageProvider!.sendMessageHandler(
                              _messageAcceptedCallback,
                              socketStateProvider!.getChatModel,
                              socketStateProvider!.getSynthModel);
                        },
                        color: baseColor,
                      )
                    : IconButton(
                        tooltip: 'マイク',
                        icon: const Icon(Icons.mic),
                        iconSize: iconSize,
                        onPressed: _startVoiceRecognitionHandler,
                        color: baseColor,
                      ),
              )
            ]),
    );
  }
}
