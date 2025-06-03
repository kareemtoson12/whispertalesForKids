import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;

  TTSService() {
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(
      0.5,
    ); // Slightly slower for better storytelling
    await _flutterTts.setVolume(1.0);
  }

  Future<void> speak(String text) async {
    if (_isPlaying) {
      await stop();
    }
    _isPlaying = true;
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    _isPlaying = false;
    await _flutterTts.stop();
  }

  Future<void> pause() async {
    _isPlaying = false;
    await _flutterTts.pause();
  }

  bool get isPlaying => _isPlaying;

  void dispose() {
    _flutterTts.stop();
  }
}
