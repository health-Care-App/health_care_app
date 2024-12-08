import 'package:flutter/material.dart';

class SocketStateProvider with ChangeNotifier {
  SocketStateProvider()
      : _synthModel = 0,
        _chatModel = 0;
  int _synthModel;
  int _chatModel;

  int get getSynthModel => _synthModel;
  set setSynthModel(int newSynthModel) {
    _synthModel = newSynthModel;
    notifyListeners();
  }

  int get getChatModel => _chatModel;
  set setChatModel(int newChatModel) {
    _chatModel = newChatModel;
    notifyListeners();
  }
}
