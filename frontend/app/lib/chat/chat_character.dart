import 'dart:math' as math;

import 'package:app/provider/socket_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app/provider/speak_provider.dart';

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
  static final tsumugiUri = "$imagesRoot/sasayaki_upper.gif"; //仮

  //画像をあらかじめ読み込み
  final defaultImage = Image.asset(defaultUri, fit: BoxFit.contain);
  final sadHandImage = Image.asset(sadUri, fit: BoxFit.contain);
  final sadImage = Image.asset(sadHandUri, fit: BoxFit.contain);
  final sasayakiImage = Image.asset(sasayakiUri, fit: BoxFit.contain);
  final tsumugiImage = Image.asset(tsumugiUri, fit: BoxFit.contain); //仮

  Image _setImage(int speakerId, int synthModel) {
    if (synthModel == 0) {
      switch (speakerId) {
        case 1 || 3 || 5:
          return defaultImage;
        case 76:
          final random = math.Random();
          //trueかfalseかをランダムに発生させる
          if (random.nextBool()) return sadImage;
          return sadHandImage;
        case 22 || 38:
          return sasayakiImage;
      }
      throw Exception("accepted speakerId '$speakerId' from server is invalid");
    } else if (synthModel == 1) {
      return tsumugiImage;
    } else {
      throw Exception("'$synthModel' is invalid");
    }
  }

  @override
  Widget build(BuildContext context) {
    //デバイスの画面サイズを取得
    final Size deviceSize = MediaQuery.of(context).size;

    return OverflowBox(
      maxWidth: double.infinity,
      maxHeight: deviceSize.height,
      child: ClipRect(
        child: Container(
          alignment: Alignment.bottomCenter,
          //speakerIdの変更が通知された際に再描画
          child: Consumer<SpeakProvider>(
              builder: (context, speakProvider, _) =>
                  //ずんだもんと春日部つむぎが切り替わった時に再描画
                  Consumer<SocketStateProvider>(
                    builder: (context, socketStateProvider, child) => _setImage(
                        speakProvider.getSpeakerId,
                        socketStateProvider.getSynthModel),
                  )),
        ),
      ),
    );
  }
}
