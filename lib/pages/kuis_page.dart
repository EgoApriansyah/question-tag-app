import 'dart:math';
import 'package:flutter/material.dart';

class KuisPage extends StatefulWidget {
  const KuisPage({super.key});

  @override
  State<KuisPage> createState() => _KuisPageState();
}

class _KuisPageState extends State<KuisPage> {
  int currentIndex = 0;
  int score = 0;
  String? selectedAnswer;

  List<Map<String, dynamic>> allQuestions = [
    {
      "question": "She is your sister, ___?",
      "options": ["isn't she", "is she", "does she"],
      "answer": "isn't she"
    },
    {
      "question": "They aren't here, ___?",
      "options": ["are they", "aren't they", "do they"],
      "answer": "are they"
    },
    {
      "question": "You can swim, ___?",
      "options": ["can you", "can't you", "do you"],
      "answer": "can't you"
    },
    {
      "question": "He doesn't work here, ___?",
      "options": ["does he", "doesn't he", "is he"],
      "answer": "does he"
    },
    {
      "question": "We are late, ___?",
      "options": ["aren't we", "are we", "do we"],
      "answer": "aren't we"
    },
    {
      "question": "I am your friend, ___?",
      "options": ["aren't I", "am I", "do I"],
      "answer": "aren't I"
    },
    {
      "question": "She likes coffee, ___?",
      "options": ["doesn't she", "does she", "is she"],
      "answer": "doesn't she"
    },
    {
      "question": "You don't know him, ___?",
      "options": ["do you", "don't you", "are you"],
      "answer": "do you"
    },
    {
      "question": "He is a doctor, ___?",
      "options": ["isn't he", "is he", "does he"],
      "answer": "isn't he"
    },
    {
      "question": "They can dance, ___?",
      "options": ["can they", "can't they", "do they"],
      "answer": "can't they"
    },
  ];

  late List<Map<String, dynamic>> quizQuestions;

  @override
  void initState() {
    super.initState();
    quizQuestions = [...allQuestions]..shuffle();
  }

  void checkAnswer(String option) {
    setState(() {
      selectedAnswer = option;

      if (option == quizQuestions[currentIndex]["answer"]) {
        score++;
      }
    });
  }

  void nextQuestion() {
    if (currentIndex < quizQuestions.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswer = null;
      });
    } else {
      // selesai → tampilkan hasil
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _resultDialog(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var q = quizQuestions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kuis Tag Question"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PROGRESS
            Text(
              "Soal ${currentIndex + 1} dari ${quizQuestions.length}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: (currentIndex + 1) / quizQuestions.length,
            ),

            const SizedBox(height: 30),

            Text(
              q["question"],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            for (var option in q["options"])
              _option(option, q["answer"]),

            const Spacer(),

            ElevatedButton(
              onPressed: selectedAnswer == null ? null : nextQuestion,
              child: const Text("Lanjut"),
            )
          ],
        ),
      ),
    );
  }

  Widget _option(String option, String answer) {
    bool selected = option == selectedAnswer;
    bool correct = option == answer;

    Color color() {
      if (selectedAnswer == null) return Colors.grey.shade200;
      if (selected && correct) return Colors.green.shade300;
      if (selected && !correct) return Colors.red.shade300;
      if (correct) return Colors.green.shade100;
      return Colors.grey.shade200;
    }

    return GestureDetector(
      onTap: selectedAnswer == null ? () => checkAnswer(option) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Text(option, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _resultDialog() {
    return AlertDialog(
      title: const Text("Hasil Kuis"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Skor kamu:",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Text(
            "$score / ${quizQuestions.length}",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: const Text("Kembali"),
        )
      ],
    );
  }
}
