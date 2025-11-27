import 'package:flutter/material.dart';

class LatihanPage extends StatefulWidget {
  const LatihanPage({super.key});

  @override
  State<LatihanPage> createState() => _LatihanPageState();
}

class _LatihanPageState extends State<LatihanPage> {
  int currentIndex = 0;
  String? selectedAnswer;

  final List<Map<String, dynamic>> questions = [
    {
      "question": "She is beautiful, ___?",
      "options": ["isn't she", "is she", "does she"],
      "answer": "isn't she"
    },
    {
      "question": "They don't eat meat, ___?",
      "options": ["do they", "don't they", "are they"],
      "answer": "do they"
    },
    {
      "question": "He can drive a car, ___?",
      "options": ["can't he", "can he", "does he"],
      "answer": "can't he"
    },
    {
      "question": "You aren't busy, ___?",
      "options": ["are you", "aren't you", "do you"],
      "answer": "are you"
    },
  ];

  void checkAnswer(String option) {
    setState(() {
      selectedAnswer = option;
    });
  }

  void nextQuestion() {
    setState(() {
      selectedAnswer = null;
      if (currentIndex < questions.length - 1) {
        currentIndex++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var q = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Latihan Soal"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Soal ${currentIndex + 1} dari ${questions.length}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Text(
              q["question"],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // OPTIONS
            for (var option in q["options"]) ...[
              _optionButton(option, q["answer"]),
            ],

            const Spacer(),

            // TOMBOL LANJUT
            if (currentIndex < questions.length - 1)
              ElevatedButton(
                onPressed: selectedAnswer == null ? null : nextQuestion,
                child: const Text("Lanjut"),
              )
            else
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Selesai"),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _optionButton(String option, String correctAnswer) {
    bool selected = selectedAnswer == option;
    bool correct = option == correctAnswer;

    Color color() {
      if (selectedAnswer == null) return Colors.grey.shade200;

      if (selected && correct) return Colors.green.shade300;
      if (selected && !correct) return Colors.red.shade300;
      if (!selected && correct) return Colors.green.shade100;

      return Colors.grey.shade200;
    }

    return GestureDetector(
      onTap: selectedAnswer == null
          ? () => checkAnswer(option)
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
