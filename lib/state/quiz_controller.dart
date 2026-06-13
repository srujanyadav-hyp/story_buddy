import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quiz_question.dart';
import '../services/quiz_repository.dart';

// ========== the states the quiz can be in ==========
enum QuizStatus {
  hidden,
  active,
  success,
}

// ========== everything the quiz ui needs to draw itself ==========
class QuizState {
  const QuizState({
    required this.status,
    this.question,
    this.shakeToken = 0,
    this.wrongOptions = const <String>{},
    this.correctOption,
  });

  final QuizStatus status;
  final QuizQuestion? question;
  final int shakeToken;
  final Set<String> wrongOptions;
  final String? correctOption;

  const QuizState.hidden() : this(status: QuizStatus.hidden);

  QuizState copyWith({
    QuizStatus? status,
    QuizQuestion? question,
    int? shakeToken,
    Set<String>? wrongOptions,
    String? correctOption,
  }) {
    return QuizState(
      status: status ?? this.status,
      question: question ?? this.question,
      shakeToken: shakeToken ?? this.shakeToken,
      wrongOptions: wrongOptions ?? this.wrongOptions,
      correctOption: correctOption ?? this.correctOption,
    );
  }
}

final quizRepositoryProvider =
    Provider<QuizRepository>((ref) => const QuizRepository());

// ========== loads the question and handles taps ==========
class QuizController extends Notifier<QuizState> {
  @override
  QuizState build() {
    _loadQuestion();
    return const QuizState.hidden();
  }

  // ========== preload the question while still hidden, so reveal is instant ==========
  Future<void> _loadQuestion() async {
    final question = await ref.read(quizRepositoryProvider).load();
    state = state.copyWith(question: question);
  }

  // ========== show the quiz once the story has finished ==========
  void reveal() {
    if (state.status == QuizStatus.hidden && state.question != null) {
      state = state.copyWith(status: QuizStatus.active);
    }
  }

  // ========== handle a tapped option, true if it was correct ==========
  bool selectOption(String option) {
    final question = state.question;
    if (state.status != QuizStatus.active || question == null) return false;

    if (question.isCorrect(option)) {
      state = state.copyWith(
        status: QuizStatus.success,
        correctOption: option,
      );
      return true;
    }

    // ========== wrong, mark it and bump the shake token to retry ==========
    state = state.copyWith(
      wrongOptions: {...state.wrongOptions, option},
      shakeToken: state.shakeToken + 1,
    );
    return false;
  }
}

final quizControllerProvider =
    NotifierProvider<QuizController, QuizState>(QuizController.new);
