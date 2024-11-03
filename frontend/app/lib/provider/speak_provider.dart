import 'package:flutter/material.dart';

class SpeakProvider with ChangeNotifier {
  SpeakProvider() : _speakerId = 1;
  int _speakerId;

  int get getSpeakerId => _speakerId;
  set setSpeakerId(int newSpeakerId) {
    _speakerId = newSpeakerId;
  }
}
