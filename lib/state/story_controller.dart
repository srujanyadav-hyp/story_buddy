import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/tts_service.dart';

// ========== the exact story line from the brief ==========
const String kStoryText =
    'Once upon a time, a clever little robot named Pip lost his shiny blue '
    'gear in the Whispering Woods...';

// ========== the states narration can be in ==========
enum StoryStatus {
  idle,
  preparing,
  playing,
  finished,
  error,
}

// ========== holds the current narration status + any error text ==========
class StoryState {
  const StoryState({required this.status, this.errorMessage});

  final StoryStatus status;
  final String? errorMessage;

  const StoryState.idle() : this(status: StoryStatus.idle);
  const StoryState.preparing() : this(status: StoryStatus.preparing);
  const StoryState.playing() : this(status: StoryStatus.playing);
  const StoryState.finished() : this(status: StoryStatus.finished);
  const StoryState.error(String message)
      : this(status: StoryStatus.error, errorMessage: message);

  bool get isBusy =>
      status == StoryStatus.preparing || status == StoryStatus.playing;
}

// ========== gives the tts engine, cleaned up with the scope ==========
final ttsServiceProvider = Provider<TtsService>((ref) {
  final service = TtsService();
  ref.onDispose(service.dispose);
  return service;
});

// ========== drives the tts engine and tracks narration state ==========
class StoryController extends Notifier<StoryState> {
  late final TtsService _tts;

  @override
  StoryState build() {
    _tts = ref.read(ttsServiceProvider);

    // ========== wire engine events once, so no duplicate handlers/leaks ==========
    _tts
      ..onStart = _handleStart
      ..onComplete = _handleComplete
      ..onCancel = _handleCancel
      ..onError = _handleError;

    return const StoryState.idle();
  }

  // ========== start (or retry) reading the story ==========
  Future<void> readStory() async {
    if (state.isBusy) return;

    state = const StoryState.preparing();
    try {
      await _tts.speak(kStoryText);
    } on TtsException {
      _failGracefully();
    } catch (_) {
      _failGracefully();
    }
  }

  // ========== engine started actually making sound ==========
  void _handleStart() {
    if (state.status == StoryStatus.preparing) {
      state = const StoryState.playing();
    }
  }

  // ========== narration finished, this is the cue for the quiz ==========
  void _handleComplete() {
    if (state.status == StoryStatus.playing ||
        state.status == StoryStatus.preparing) {
      state = const StoryState.finished();
    }
  }

  // ========== stopped before finishing, go back to idle ==========
  void _handleCancel() {
    if (state.isBusy) state = const StoryState.idle();
  }

  void _handleError(String _) => _failGracefully();

  // ========== show a friendly message and let the kid retry ==========
  void _failGracefully() {
    state = const StoryState.error(
      "Oops! I couldn't read aloud right now. Tap to try again.",
    );
  }
}

final storyControllerProvider =
    NotifierProvider<StoryController, StoryState>(StoryController.new);
