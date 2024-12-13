import 'dart:convert';
import 'dart:typed_data';

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
  bool _isRecognition = false;
  bool _speechEnabled = false;
  final speechListenOptions = SpeechListenOptions(partialResults: false);

  void _onSpeechResult(SpeechRecognitionResult result) {
    //メッセージ送信時に音声認識をストップ
    _speechToText.stop();

    if (messageProvider == null) {
      throw Exception("_onSpeechResult: messageProvider is null");
    }

    if (socketStateProvider == null) {
      throw Exception("_onSpeechResult: socketStateProvider is null");
    }

    //送信するメッセージを更新
    messageProvider!.textChangeHandler(result.recognizedWords);

    //送信
    messageProvider!.sendMessageHandler(_messageAcceptedCallback,
        socketStateProvider!.getChatModel, socketStateProvider!.getSynthModel,
        messageAcceptFinishCallback: _sttMessageAcceptFinishCallback);
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
      child: _isRecognition
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
          : Row(children: [
              Expanded(
                  //テキストボックス
                  child: Container(
                margin: EdgeInsets.fromLTRB(marginX, 0, 0, 0),

                //テキストボックスの角を丸くする
                decoration: BoxDecoration(
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
                    border: InputBorder.none,
                    hintText: "メッセージを入力...",

                    //入力部分の背景色
                    filled: true,
                    fillColor: whiteTransparentColor,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,

                    //hint text color
                    hintStyle: TextStyle(
                        color: hintFontColor, fontWeight: FontWeight.w600),
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
                        icon: CircleAvatar(
                            radius: iconCircleR,
                            backgroundColor: baseColor,
                            child: Icon(
                              Icons.send_rounded,
                              size: iconSize,
                              color: Colors.white,
                            )),
                        onPressed: () {
                          messageProvider!.sendMessageHandler(
                              _messageAcceptedCallback,
                              socketStateProvider!.getChatModel,
                              socketStateProvider!.getSynthModel);
                        },
                      )
                    : IconButton(
                        tooltip: 'マイク',
                        icon: CircleAvatar(
                            radius: iconCircleR,
                            backgroundColor: baseColor,
                            child: Icon(Icons.mic,
                                size: iconSize, color: Colors.white)),
                        onPressed: _startVoiceRecognitionHandler,
                      ),
              ),
            ]),
    );
  }
}
