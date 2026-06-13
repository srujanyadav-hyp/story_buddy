import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// ========== the card that shows the story text ==========
class StoryCard extends StatelessWidget {
  const StoryCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.storyCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========== little header with a book icon ==========
          Row(
            children: [
              Text(
                'STORY TIME',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textMuted,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              const Icon(Icons.menu_book_rounded,
                  color: AppColors.primary, size: 22),
            ],
          ),
          const SizedBox(height: 12),
          // ========== the actual story line ==========
          Text(
            text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  height: 1.5,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
