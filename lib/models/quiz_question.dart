// ========== quiz question model, built straight from the backend json ==========
class QuizQuestion {
  const QuizQuestion({
    required this.question,
    required this.options,
    required this.answer,
  });

  final String question;
  final List<String> options;
  final String answer;

  // ========== parse json, never assume how many options come in ==========
  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    if (rawOptions is! List || rawOptions.isEmpty) {
      throw const FormatException('Quiz JSON must contain a non-empty "options" list.');
    }
    final question = json['question'];
    final answer = json['answer'];
    if (question is! String || answer is! String) {
      throw const FormatException('Quiz JSON must contain string "question" and "answer".');
    }

    final options = rawOptions.map((e) => e.toString()).toList(growable: false);
    if (!options.contains(answer)) {
      throw const FormatException('Quiz "answer" must match one of the "options".');
    }

    return QuizQuestion(
      question: question,
      options: options,
      answer: answer,
    );
  }

  // ========== is the tapped option the right one ==========
  bool isCorrect(String option) => option == answer;
}
