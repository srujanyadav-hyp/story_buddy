import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/quiz_controller.dart';
import '../theme/app_theme.dart';
import 'option_tile.dart';
import 'shake_widget.dart';

// ========== draws the quiz fully from json, any number of options ==========
class QuizView extends ConsumerStatefulWidget {
  const QuizView({super.key});

  @override
  ConsumerState<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends ConsumerState<QuizView> {
  late final ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti =
        ConfettiController(duration: const Duration(milliseconds: 1200));
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ========== buzz on every wrong answer ==========
    ref.listen(
      quizControllerProvider.select((s) => s.shakeToken),
      (prev, next) {
        if (prev != null && next > prev) HapticFeedback.heavyImpact();
      },
    );
    // ========== confetti + buzz when they get it right ==========
    ref.listen(
      quizControllerProvider.select((s) => s.status),
      (prev, next) {
        if (next == QuizStatus.success) {
          _confetti.play();
          HapticFeedback.mediumImpact();
        }
      },
    );

    final state = ref.watch(quizControllerProvider);
    final question = state.question;
    if (question == null) return const SizedBox.shrink();

    final isSuccess = state.status == QuizStatus.success;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ========== the question text from the json ==========
            Text(
              question.question,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.deep,
                  ),
            ),
            const SizedBox(height: 20),
            // ========== whole option list shakes together when wrong ==========
            ShakeWidget(
              shakeToken: state.shakeToken,
              child: Column(
                children: [
                  // ========== one tile per option, however many there are ==========
                  for (final option in question.options)
                    OptionTile(
                      text: option,
                      visual: _visualFor(option, state),
                      enabled: state.status == QuizStatus.active,
                      onTap: () => ref
                          .read(quizControllerProvider.notifier)
                          .selectOption(option),
                    ),
                ],
              ),
            ),
            if (isSuccess) const _SuccessBanner(),
          ],
        ),
        // ========== confetti emitter, bursts on success ==========
        ConfettiWidget(
          confettiController: _confetti,
          blastDirectionality: BlastDirectionality.explosive,
          numberOfParticles: 20,
          maxBlastForce: 18,
          minBlastForce: 6,
          gravity: 0.25,
          shouldLoop: false,
          colors: const [
            AppColors.primary,
            Color(0xFFFFD75E),
            AppColors.correct,
            Color(0xFFFF8FB1),
          ],
        ),
      ],
    );
  }

  // ========== decide how one option should look ==========
  OptionVisual _visualFor(String option, QuizState state) {
    if (state.status == QuizStatus.success && option == state.correctOption) {
      return OptionVisual.correct;
    }
    if (state.wrongOptions.contains(option)) return OptionVisual.wrong;
    return OptionVisual.normal;
  }
}

// ========== the success state shown after the right answer ==========
class _SuccessBanner extends StatelessWidget {
  const _SuccessBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.correct.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                'Hooray! You got it right!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.correct,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
