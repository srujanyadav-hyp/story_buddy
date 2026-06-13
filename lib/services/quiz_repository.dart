import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/quiz_question.dart';

// ========== loads the quiz json, pretending it came from our backend ==========
class QuizRepository {
  const QuizRepository();

  static const String _assetPath = 'assets/quiz.json';

  Future<QuizQuestion> load() async {
    final raw = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return QuizQuestion.fromJson(decoded);
  }
}
