import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// ========== how a single option should look right now ==========
enum OptionVisual { normal, wrong, correct }

// ========== one answer card, text on the left, status circle on the right ==========
class OptionTile extends StatelessWidget {
  const OptionTile({
    super.key,
    required this.text,
    required this.visual,
    required this.enabled,
    required this.onTap,
  });

  final String text;
  final OptionVisual visual;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (border, fill, circle, icon) = _styles();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                  ),
                ),
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: circle,
                    border: Border.all(color: border, width: 2),
                  ),
                  child: icon,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ========== colours and circle icon for each visual state ==========
  (Color border, Color fill, Color circle, Widget? icon) _styles() {
    switch (visual) {
      case OptionVisual.correct:
        return (
          AppColors.correct,
          AppColors.correct.withValues(alpha: 0.10),
          AppColors.correct,
          const Icon(Icons.check_rounded, size: 18, color: Colors.white),
        );
      case OptionVisual.wrong:
        return (
          AppColors.wrong,
          AppColors.wrong.withValues(alpha: 0.08),
          AppColors.wrong,
          const Icon(Icons.close_rounded, size: 18, color: Colors.white),
        );
      case OptionVisual.normal:
        return (
          const Color(0xFFE5E1F0),
          AppColors.card,
          Colors.transparent,
          null,
        );
    }
  }
}
