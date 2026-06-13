import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// ========== pip the buddy, drawn from shapes so there's no image to load ==========
class BuddyCharacter extends StatefulWidget {
  const BuddyCharacter({
    super.key,
    this.speaking = false,
    this.happy = false,
  });

  final bool speaking;
  final bool happy;

  @override
  State<BuddyCharacter> createState() => _BuddyCharacterState();
}

class _BuddyCharacterState extends State<BuddyCharacter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bob;

  @override
  void initState() {
    super.initState();
    // ========== gentle up and down bob, runs forever ==========
    _bob = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final amplitude = widget.speaking ? 8.0 : 5.0;
    return AnimatedBuilder(
      animation: _bob,
      child: _face(),
      builder: (context, child) {
        final dy = (_bob.value - 0.5) * 2 * amplitude;
        return Transform.translate(offset: Offset(0, dy), child: child);
      },
    );
  }

  // ========== the robot head ==========
  Widget _face() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.deep],
        ),
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ========== antenna on top ==========
          Positioned(
            top: -10,
            child: Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD75E),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(width: 3, height: 12, color: Colors.white70),
              ],
            ),
          ),
          // ========== two eyes ==========
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _eye(),
                const SizedBox(width: 26),
                _eye(),
              ],
            ),
          ),
          // ========== rosy cheeks only when he's happy ==========
          if (widget.happy)
            Positioned(
              bottom: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _cheek(),
                  const SizedBox(width: 60),
                  _cheek(),
                ],
              ),
            ),
          // ========== mouth, smiles bigger on success ==========
          Positioned(
            bottom: 30,
            child: _mouth(),
          ),
        ],
      ),
    );
  }

  Widget _eye() {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          color: AppColors.deep,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _cheek() {
    return Container(
      width: 16,
      height: 10,
      decoration: BoxDecoration(
        color: const Color(0xFFFF8FB1).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _mouth() {
    if (widget.happy) {
      // ========== big open happy smile ==========
      return Container(
        width: 46,
        height: 24,
        decoration: const BoxDecoration(
          color: Color(0xFFFFD75E),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      );
    }
    // ========== calm little resting smile ==========
    return Container(
      width: 34,
      height: 16,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.9), width: 4),
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
    );
  }
}
