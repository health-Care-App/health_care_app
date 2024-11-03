import 'package:app/provider/speak_provider.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class ChatCharacter extends StatefulWidget {
  const ChatCharacter({super.key});

  @override
  State<ChatCharacter> createState() => _ChatCharacterState();
}

class _ChatCharacterState extends State<ChatCharacter> {
  SpeakProvider? speakProvider;
  static final imagesRoot = "assets/images/";
  static final defaultUri = "$imagesRoot/default_upper.gif";
  static final sadHandUri = "$imagesRoot/sad_upper_hand.gif";
  static final sadUri = "$imagesRoot/sad_upper.gif";
  static final sasayakiUri = "$imagesRoot/sasayaki_upper.gif";
  String imageUri = defaultUri; //初期値

  String _setImageUri(int speakerId) {
    switch (speakerId) {
      case 1 || 3 || 5:
        return defaultUri;
      case 76:
        final random = math.Random();
        //trueかfalseかをランダムに発生させる
        if (random.nextBool()) return sadUri;
        return sadHandUri;
      case 22 || 38:
        return sasayakiUri;
    }
    throw Exception("accepted speakerId '$speakerId' from server is invalid");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 700,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: OverflowBox(
          maxWidth: 1000,
          maxHeight: 1000,
          child: ClipRect(
            child: Consumer<SpeakProvider>(
              builder: (context, speakProvider, _) => Image.asset(
                  _setImageUri(speakProvider.getSpeakerId),
                  fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }
}
