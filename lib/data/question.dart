import '../models/question.dart';

class QuestionsData {
  static List<Question> questions = [
    Question(
      question: "She is a teacher, ______?",
      options: ["isn't she", "is she", "does she"],
      answer: "isn't she",
    ),
    Question(
      question: "You don't like spicy food, ______?",
      options: ["do you", "don't you", "are you"],
      answer: "do you",
    ),
    Question(
      question: "They went to the beach, ______?",
      options: ["didn't they", "weren't they", "don't they"],
      answer: "didn't they",
    ),
    Question(
      question: "He can drive a car, ______?",
      options: ["can he", "can't he", "does he"],
      answer: "can't he",
    ),
    Question(
      question: "We are late, ______?",
      options: ["aren't we", "are we", "were we"],
      answer: "aren't we",
    ),
  ];
}
