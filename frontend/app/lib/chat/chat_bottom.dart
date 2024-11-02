import 'dart:convert';
import 'dart:typed_data';

import 'package:app/chat/audio_queue.dart';
import 'package:app/provider/message_provider.dart';
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
  bool _speechEnabled = false;
  final speechListenOptions = SpeechListenOptions(partialResults: false);

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (messageProvider == null) {
      throw Exception("_onSpeechResult: messageProvider is null");
    }
    //送信するメッセージを更新
    messageProvider!.textChangeHandler(result.recognizedWords);

    //送信
    messageProvider!.sendMessageHandler(_sttMessageAcceptedCallback,
        messageAcceptFinishCallback: _sttMessageAcceptFinishCallback);
  }

  void _startVoiceRecognitionHandler() async {
    _speechEnabled = await _speechToText.initialize();
    if (_speechEnabled) {
      _speechToText.listen(
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

  void _messageAcceptedCallback(
      String base64Data, String text, int newSpeakerId) async {
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

    return BottomAppBar(
        color: Colors.blueAccent,
        child: Row(children: [
          Flexible(
            child: TextField(
              controller: messageProvider!.controller,

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
              onChanged: messageProvider!.textChangeHandler,
            ),
          ),
          messageProvider!.isTextSet
              ? IconButton(
                  tooltip: '送信',
                  icon: const Icon(Icons.send_rounded),
                  onPressed: () {
                    messageProvider!
                        .sendMessageHandler(_messageAcceptedCallback);
                  },
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
