import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:story_buddy/models/quiz_question.dart';
import 'package:story_buddy/screens/story_screen.dart';

void main() {
  group('QuizQuestion.fromJson', () {
    test('parses a 4-option payload', () {
      final q = QuizQuestion.fromJson({
        'question': 'What colour was Pip the Robot\'s lost gear?',
        'options': ['Red', 'Green', 'Blue', 'Yellow'],
        'answer': 'Blue',
      });
      expect(q.options.length, 4);
      expect(q.isCorrect('Blue'), isTrue);
      expect(q.isCorrect('Red'), isFalse);
    });

    test('handles a different option count without changes (3 options)', () {
      final q = QuizQuestion.fromJson({
        'question': 'Pick one',
        'options': ['A', 'B', 'C'],
        'answer': 'C',
      });
      expect(q.options.length, 3);
      expect(q.isCorrect('C'), isTrue);
    });

    test('rejects payloads whose answer is not among the options', () {
      expect(
        () => QuizQuestion.fromJson({
          'question': 'Bad',
          'options': ['A', 'B'],
          'answer': 'Z',
        }),
        throwsA(isA<FormatException>()),
      );
    });
  });

  testWidgets('renders the story screen with the read button', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: StoryScreen()),
      ),
    );
    await tester.pump();

    expect(find.text('AI Story Buddy'), findsOneWidget);
    expect(find.text('Read Me a Story'), findsOneWidget);
  });
}
