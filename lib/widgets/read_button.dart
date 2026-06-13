import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/story_controller.dart';
import '../theme/app_theme.dart';

// ========== the read me a story button, shows every narration state ==========
class ReadButton extends ConsumerWidget {
  const ReadButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ========== only watch the status so we rebuild on real changes ==========
    final status = ref.watch(
      storyControllerProvider.select((s) => s.status),
    );
    final controller = ref.read(storyControllerProvider.notifier);

    // ========== on failure show the friendly retry block ==========
    if (status == StoryStatus.error) {
      final message = ref.read(storyControllerProvider).errorMessage ??
          'Something went wrong.';
      return _ErrorRetry(message: message, onRetry: controller.readStory);
    }

    final busy =
        status == StoryStatus.preparing || status == StoryStatus.playing;

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: busy ? null : controller.readStory,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white,
          elevation: 4,
          shadowColor: AppColors.primary.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: _label(status),
      ),
    );
  }

  // ========== pick the label/icon for the current state ==========
  Widget _label(StoryStatus status) {
    switch (status) {
      case StoryStatus.preparing:
        return const _BusyLabel(text: 'Getting ready…');
      case StoryStatus.playing:
        return const _BusyLabel(text: 'Reading aloud…', icon: Icons.volume_up_rounded);
      case StoryStatus.finished:
        return const _IconLabel(text: 'Read it again', icon: Icons.replay_rounded);
      case StoryStatus.idle:
      case StoryStatus.error:
        return const _IconLabel(text: 'Read Me a Story', icon: Icons.volume_up_rounded);
    }
  }
}

// ========== simple icon + text label ==========
class _IconLabel extends StatelessWidget {
  const _IconLabel({required this.text, required this.icon});
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 24),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

// ========== busy label, spinner while preparing else a speaker icon ==========
class _BusyLabel extends StatelessWidget {
  const _BusyLabel({required this.text, this.icon});
  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon == null)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          )
        else
          Icon(icon, size: 24),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

// ========== friendly error message with a try again button ==========
class _ErrorRetry extends StatelessWidget {
  const _ErrorRetry({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.wrong.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text('🙊', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const _IconLabel(
                text: 'Try Again', icon: Icons.refresh_rounded),
          ),
        ),
      ],
    );
  }
}
