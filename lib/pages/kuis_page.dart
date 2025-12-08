import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class KuisPage extends StatefulWidget {
  const KuisPage({super.key});

  @override
  State<KuisPage> createState() => _KuisPageState();
}

class _KuisPageState extends State<KuisPage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int currentIndex = 0;
  int score = 0;
  String? selectedAnswer;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  // Timer variables
  Timer? _timer;
  int _timeLeft = 15; // 15 detik per soal
  final int _initialTime = 15;
  bool _isAppInForeground = true;
  
  // Variable untuk mengontrol apakah kuis sudah dimulai
  bool _quizStarted = false;

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
    {
      "question": "She will come tomorrow, ___?",
      "options": ["won't she", "will she", "doesn't she"],
      "answer": "won't she"
    },
    {
      "question": "We haven't met before, ___?",
      "options": ["have we", "haven't we", "do we"],
      "answer": "have we"
    },
    {
      "question": "He should study harder, ___?",
      "options": ["shouldn't he", "should he", "doesn't he"],
      "answer": "shouldn't he"
    },
    {
      "question": "They were playing football, ___?",
      "options": ["weren't they", "were they", "didn't they"],
      "answer": "weren't they"
    },
    {
      "question": "You wouldn't lie to me, ___?",
      "options": ["would you", "wouldn't you", "do you"],
      "answer": "would you"
    },
    {
      "question": "She has finished her homework, ___?",
      "options": ["hasn't she", "has she", "doesn't she"],
      "answer": "hasn't she"
    },
    {
      "question": "It isn't raining, ___?",
      "options": ["is it", "isn't it", "does it"],
      "answer": "is it"
    },
    {
      "question": "Your brother can't drive, ___?",
      "options": ["can he", "can't he", "does he"],
      "answer": "can he"
    },
    {
      "question": "We must go now, ___?",
      "options": ["mustn't we", "must we", "don't we"],
      "answer": "mustn't we"
    },
    {
      "question": "They didn't see you, ___?",
      "options": ["did they", "didn't they", "do they"],
      "answer": "did they"
    },
    {
      "question": "You have been there, ___?",
      "options": ["haven't you", "have you", "don't you"],
      "answer": "haven't you"
    },
    {
      "question": "He won't forget us, ___?",
      "options": ["will he", "won't he", "does he"],
      "answer": "will he"
    },
    {
      "question": "Lisa could swim when she was five, ___?",
      "options": ["couldn't she", "could she", "can't she"],
      "answer": "couldn't she"
    },
    {
      "question": "You aren't tired, ___?",
      "options": ["are you", "aren't you", "do you"],
      "answer": "are you"
    },
    {
      "question": "We should help them, ___?",
      "options": ["shouldn't we", "should we", "don't we"],
      "answer": "shouldn't we"
    },
  ];

  late List<Map<String, dynamic>> quizQuestions;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    quizQuestions = [...allQuestions]..shuffle();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    
    _animationController.forward();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (state == AppLifecycleState.resumed) {
      _isAppInForeground = true;
      // Resume timer jika ada jawaban belum dipilih
      if (selectedAnswer == null && mounted && _quizStarted) {
        _resumeTimer();
      }
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _isAppInForeground = false;
      _pauseTimer();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _pauseTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _resumeTimer() {
    if (_isAppInForeground && selectedAnswer == null && _timer == null && mounted) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted || !_isAppInForeground) {
          _pauseTimer();
          return;
        }
        
        setState(() {
          if (_timeLeft > 0) {
            _timeLeft--;
          } else {
            _timer?.cancel();
            _autoNextQuestion();
          }
        });
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    if (!mounted) return;
    
    setState(() {
      _timeLeft = _initialTime;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || !_isAppInForeground) {
        _pauseTimer();
        return;
      }
      
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          _autoNextQuestion();
        }
      });
    });
  }

  void _autoNextQuestion() {
    // Jika tidak ada jawaban, anggap salah
    if (selectedAnswer == null) {
      setState(() {
        selectedAnswer = ""; // Marking as answered but wrong
      });
    }
    
    // Delay sedikit sebelum lanjut
    Future.delayed(const Duration(milliseconds: 800), () {
      nextQuestion();
    });
  }

  void checkAnswer(String option) {
    _timer?.cancel(); // Stop timer saat jawaban dipilih
    
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
        _animationController.reset();
        _animationController.forward();
      });
      _startTimer();
    } else {
      _timer?.cancel();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _resultDialog(),
      );
    }
  }

  Color _getTimerColor() {
    if (_timeLeft > 10) return Colors.green.shade500;
    if (_timeLeft > 5) return Colors.orange.shade500;
    return Colors.red.shade500;
  }

  // Method untuk memulai kuis
  void _startQuiz() {
    setState(() {
      _quizStarted = true;
    });
    // Start timer setelah build pertama
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Jika kuis belum dimulai, tampilkan halaman start
    if (!_quizStarted) {
      return _buildStartScreen();
    }
    
    // Jika sudah dimulai, tampilkan kuis seperti biasa
    var q = quizQuestions[currentIndex];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange.shade50,
              Colors.pink.shade50,
              Colors.purple.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLottieCard(),
                        const SizedBox(height: 20),
                        _buildTimerCard(),
                        const SizedBox(height: 16),
                        _buildProgressCard(),
                        const SizedBox(height: 24),
                        _buildQuestionCard(q),
                        const SizedBox(height: 24),

                        for (var option in q["options"])
                          _buildOption(option, q["answer"]),

                        const SizedBox(height: 24),
                        _buildNextButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Halaman Start Screen
  Widget _buildStartScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange.shade50,
              Colors.pink.shade50,
              Colors.purple.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                
                // Header dengan Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange.shade400, Colors.orange.shade600],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.quiz_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Title
                const Text(
                  "Kuis Tag Question",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  "Test kemampuanmu! 🎯",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32),
                
                // Illustration Card
                Container(
                  width: double.infinity,
                  height: 240,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade400, Colors.pink.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: Lottie.asset(
                        "assets/lottie/kuis.json",
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.quiz_rounded,
                                size: 80,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "🎯 Quiz Time",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Subtitle
                const Text(
                  "Test kemampuanmu dengan 25 pertanyaan!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 24),
                
                // Info Cards
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        Icons.timer_rounded,
                        "15 detik per soal",
                        Colors.orange,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        Icons.quiz_rounded,
                        "25 pertanyaan",
                        Colors.purple,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        Icons.star_rounded,
                        "Kumpulkan poin maksimal",
                        Colors.amber,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Start Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _startQuiz,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: Colors.orange.shade500,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                      shadowColor: Colors.orange.withOpacity(0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.play_arrow_rounded, size: 28),
                        SizedBox(width: 8),
                        Text(
                          "Mulai Kuis",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget untuk info row
  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade400, Colors.orange.shade600],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.quiz_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kuis Tag Question",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  "Test kemampuanmu! 🎯",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade400, Colors.orange.shade600],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  "$score",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLottieCard() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.pink.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -25,
            right: -25,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -15,
            left: -15,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: _buildLottieAnimation(),
            ),
          ),
          Positioned(
            top: 16,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.stars_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "Quiz Mode",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "$score pts",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLottieAnimation() {
    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 100)),
      builder: (context, snapshot) {
        return Lottie.asset(
          "assets/lottie/kuis.json",
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Lottie.network(
              'https://lottie.host/embed/7d8e9f0a-5c3d-6e4f-9a0b-3c4d5e6f7g8h/ghi789rst.json',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return _buildCustomIllustration();
              },
            );
          },
        );
      },
    );
  }

  Widget _buildCustomIllustration() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
            const Icon(
              Icons.quiz_rounded,
              size: 50,
              color: Colors.white,
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          "🎯 Quiz Time",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTimerCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_getTimerColor().withOpacity(0.2), _getTimerColor().withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getTimerColor().withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getTimerColor(),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _getTimerColor().withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              _timeLeft > 5 ? Icons.timer_rounded : Icons.timer_off_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Waktu Tersisa",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$_timeLeft detik",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _getTimerColor(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: _timeLeft / _initialTime,
                    strokeWidth: 6,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(_getTimerColor()),
                  ),
                ),
                Text(
                  "$_timeLeft",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getTimerColor(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    double progress = (currentIndex + 1) / quizQuestions.length;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pertanyaan ${currentIndex + 1}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${currentIndex + 1}/${quizQuestions.length}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.orange.shade50,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade500),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${(progress * 100).toInt()}% Complete",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> q) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.orange.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.help_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            q["question"],
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String option, String answer) {
    bool selected = option == selectedAnswer;
    bool correct = option == answer;
    bool showAnswer = selectedAnswer != null;

    Color backgroundColor() {
      if (!showAnswer) return Colors.white;
      if (correct) return Colors.green.shade50;
      if (selected && !correct) return Colors.red.shade50;
      return Colors.white;
    }

    Color borderColor() {
      if (!showAnswer) return Colors.grey.shade300;
      if (correct) return Colors.green.shade400;
      if (selected && !correct) return Colors.red.shade400;
      return Colors.grey.shade300;
    }

    IconData? getIcon() {
      if (!showAnswer) return null;
      if (correct) return Icons.check_circle_rounded;
      if (selected && !correct) return Icons.cancel_rounded;
      return null;
    }

    Color? getIconColor() {
      if (!showAnswer) return null;
      if (correct) return Colors.green.shade600;
      if (selected && !correct) return Colors.red.shade600;
      return null;
    }

    return GestureDetector(
      onTap: selectedAnswer == null ? () => checkAnswer(option) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: backgroundColor(),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor(),
            width: 2,
          ),
          boxShadow: [
            if (selected || correct)
              BoxShadow(
                color: borderColor().withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            if (getIcon() != null)
              Icon(
                getIcon(),
                color: getIconColor(),
                size: 28,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: selectedAnswer == null ? null : nextQuestion,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.orange.shade500,
          disabledBackgroundColor: Colors.grey.shade300,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: selectedAnswer == null ? 0 : 5,
          shadowColor: Colors.orange.withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentIndex < quizQuestions.length - 1 ? "Lanjut" : "Selesai",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded),
          ],
        ),
      ),
    );
  }

  Widget _resultDialog() {
    double percentage = (score / quizQuestions.length) * 100;
    String emoji = percentage >= 80 ? "🎉" : percentage >= 60 ? "👍" : "💪";
    String message = percentage >= 80 
        ? "Luar biasa!" 
        : percentage >= 60 
            ? "Bagus!" 
            : "Terus belajar!";

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange.shade50,
              Colors.purple.shade50,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 120,
              child: Lottie.asset(
                percentage >= 80 
                    ? "assets/lottie/success.json"
                    : percentage >= 60
                        ? "assets/lottie/good.json"
                        : "assets/lottie/tryagain.json",
                repeat: false,
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    emoji,
                    style: const TextStyle(fontSize: 64),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            Text(
              message,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              "Hasil Kuis",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade400, Colors.orange.shade600],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Skor Kamu",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$score / ${quizQuestions.length}",
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${percentage.toInt()}% Benar",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        currentIndex = 0;
                        score = 0;
                        selectedAnswer = null;
                        _quizStarted = false;
                        quizQuestions.shuffle();
                        _animationController.reset();
                        _animationController.forward();
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.orange.shade400, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Ulangi",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.orange.shade500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Selesai",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}