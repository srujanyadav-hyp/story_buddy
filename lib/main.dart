import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/story_screen.dart';
import 'theme/app_theme.dart';

// ========== app entry point, wrap everything in a provider scope ==========
void main() {
  runApp(const ProviderScope(child: StoryBuddyApp()));
}

// ========== root app widget ==========
class StoryBuddyApp extends StatelessWidget {
  const StoryBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Story Buddy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const StoryScreen(),
    );
  }
}
