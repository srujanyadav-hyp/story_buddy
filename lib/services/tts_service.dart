import 'package:flutter_tts/flutter_tts.dart';

// ========== small wrapper around the native tts engine ==========
class TtsService {
  TtsService() : _tts = FlutterTts();

  final FlutterTts _tts;
  bool _initialised = false;

  // ========== events we send back to the controller ==========
  void Function()? onStart;
  void Function()? onComplete;
  void Function()? onCancel;
  void Function(String message)? onError;

  // ========== set up a warm, kid friendly voice (run once) ==========
  Future<void> init() async {
    if (_initialised) return;

    // ========== make speak() wait until narration is fully done ==========
    await _tts.awaitSpeakCompletion(true);

    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.1);
    await _tts.setVolume(1.0);

    _tts.setStartHandler(() => onStart?.call());
    _tts.setCompletionHandler(() => onComplete?.call());
    _tts.setCancelHandler(() => onCancel?.call());
    _tts.setErrorHandler((dynamic msg) => onError?.call(msg.toString()));

    _initialised = true;
  }

  // ========== speak the text, throw if the engine refuses to start ==========
  Future<void> speak(String text) async {
    await init();

    final result = await _tts.speak(text);
    if (result != 1) {
      throw const TtsException('The narrator could not start.');
    }
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  void dispose() {
    _tts.stop();
  }
}

// ========== thrown when narration cannot start ==========
class TtsException implements Exception {
  const TtsException(this.message);
  final String message;

  @override
  String toString() => 'TtsException: $message';
}
