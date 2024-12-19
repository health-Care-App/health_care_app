import 'dart:math' as math;

import 'package:app/chat/character_progress.dart';
import 'package:app/provider/socket_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app/provider/speak_provider.dart';

class ChatCharacter extends StatefulWidget {
  const ChatCharacter({super.key});

  @override
  State<ChatCharacter> createState() => _ChatCharacterState();
}

Widget imageLoadingWidget(
    BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
  return CircularProgressIndicator(
    color: Colors.grey,
  );
}

class _ChatCharacterState extends State<ChatCharacter> {
  static final imagesRoot = "assets/images/";
  static final defaultUri = "$imagesRoot/default_upper.gif";
  static final sadHandUri = "$imagesRoot/sad_upper_hand.gif";
  static final sadUri = "$imagesRoot/sad_upper.gif";
  static final sasayakiUri = "$imagesRoot/sasayaki_upper.gif";
  static final tsumugiUri = "$imagesRoot/tsumugi_default.gif";
  final defaultImage = AssetImage(defaultUri);
  final sadHandImage = AssetImage(sadUri);
  final sadImage = AssetImage(sadHandUri);
  final sasayakiImage = AssetImage(sasayakiUri);
  final tsumugiImage = AssetImage(tsumugiUri);

  AssetImage _setImage(int speakerId, int synthModel) {
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

  //画像表示をはやくするため、画像をキャッシュ
  @override
  void didChangeDependencies() {
    precacheImage(defaultImage, context);
    precacheImage(sadHandImage, context);
    precacheImage(sadImage, context);
    precacheImage(sasayakiImage, context);
    precacheImage(tsumugiImage, context);
    super.didChangeDependencies();
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
              builder: (context, socketStateProvider, _) => Image(
                image: _setImage(speakProvider.getSpeakerId,
                    socketStateProvider.getSynthModel),
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return CharacterProgress();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
