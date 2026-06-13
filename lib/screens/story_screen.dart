import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/quiz_controller.dart';
import '../state/story_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/buddy_character.dart';
import '../widgets/quiz_view.dart';
import '../widgets/read_button.dart';
import '../widgets/story_card.dart';

// ========== the one screen, buddy then story then button then quiz ==========
class StoryScreen extends ConsumerWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ========== when the story finishes, reveal the quiz ==========
    ref.listen(
      storyControllerProvider.select((s) => s.status),
      (prev, next) {
        if (next == StoryStatus.finished) {
          ref.read(quizControllerProvider.notifier).reveal();
        }
      },
    );

    final speaking = ref.watch(
      storyControllerProvider.select((s) => s.status == StoryStatus.playing),
    );
    final quizStatus =
        ref.watch(quizControllerProvider.select((s) => s.status));
    final quizVisible = quizStatus != QuizStatus.hidden;
    final happy = quizStatus == QuizStatus.success;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scaffold,
        elevation: 0,
        scrolledUnderElevation: 0,
        // ========== top bar with logo and title ==========
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_stories_rounded,
                  size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Text(
              'AI Story Buddy',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.account_circle_outlined,
                color: AppColors.primary, size: 28),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            children: [
              const SizedBox(height: 8),
              BuddyCharacter(speaking: speaking, happy: happy),
              const SizedBox(height: 28),
              const StoryCard(text: kStoryText),
              const SizedBox(height: 20),
              const ReadButton(),
              // ========== quiz fades, slides and grows in once it's revealed ==========
              AnimatedSize(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        alignment: Alignment.topCenter,
                        child: child,
                      ),
                    );
                  },
                  child: quizVisible
                      ? const Padding(
                          key: ValueKey('quiz'),
                          padding: EdgeInsets.only(top: 28),
                          child: QuizView(),
                        )
                      : const SizedBox(
                          key: ValueKey('empty'), width: double.infinity),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
