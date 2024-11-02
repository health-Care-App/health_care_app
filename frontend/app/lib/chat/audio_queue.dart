import 'dart:collection';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';

class AudioQueue {
  static final AudioQueue _instance = AudioQueue._internal();
  static final Queue<Uint8List> _audioQueue = Queue();
  static final _player = AudioPlayer();

  factory AudioQueue() {
    return _instance;
  }

  AudioQueue._internal() {
    //playerの状態が変わった時のコールバック関数
    _player.onPlayerStateChanged.listen((PlayerState state) async {
      //再生終了以外の時とqueueが空の時はスキップ
      if (state != PlayerState.completed) return;
      if (_audioQueue.isEmpty) return;

      //再生
      await _play();
    });
  }

  Future<void> _play() async {
    Uint8List bytes = _audioQueue.removeFirst();
    _player.setSourceBytes(bytes);
    await _player.resume();
    return;
  }

  void add(Uint8List bytes) {
    _audioQueue.addLast(bytes);

    switch (_player.state) {
      //再生が止まっているときは再生開始
      case PlayerState.completed || PlayerState.paused || PlayerState.stopped:
        _play();
        return;
      default:
        return;
    }
  }
}