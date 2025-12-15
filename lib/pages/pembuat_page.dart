import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

class WordScrambleGame extends StatefulWidget {
  const WordScrambleGame({super.key});

  @override
  State<WordScrambleGame> createState() => _WordScrambleGameState();
}

class _WordScrambleGameState extends State<WordScrambleGame> {
  // Data kata-kata
  final List<Map<String, dynamic>> _words = [
    {'word': 'BEAUTIFUL', 'hint': 'Indah, cantik', 'category': 'Adjective'},
    {'word': 'COMPUTER', 'hint': 'Alat elektronik untuk bekerja', 'category': 'Noun'},
    {'word': 'ELEPHANT', 'hint': 'Hewan besar dengan belalai', 'category': 'Animal'},
    {'word': 'MOUNTAIN', 'hint': 'Tempat tinggi di alam', 'category': 'Nature'},
    {'word': 'HAPPINESS', 'hint': 'Perasaan senang', 'category': 'Emotion'},
    {'word': 'BUTTERFLY', 'hint': 'Serangga dengan sayap indah', 'category': 'Animal'},
    {'word': 'CHOCOLATE', 'hint': 'Makanan manis berwarna coklat', 'category': 'Food'},
    {'word': 'UMBRELLA', 'hint': 'Alat pelindung dari hujan', 'category': 'Object'},
    {'word': 'GUITAR', 'hint': 'Alat musik berdawai', 'category': 'Music'},
    {'word': 'LIBRARY', 'hint': 'Tempat meminjam buku', 'category': 'Place'},
  ];

  int _currentWordIndex = 0;
  List<String> _scrambledLetters = [];
  List<String> _playerAnswer = [];
  List<int> _selectedIndices = [];
  bool _showResult = false;
  bool _isCorrect = false;
  int _score = 0;
  bool _showHint = false;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _scrambleWord();
  }

  void _scrambleWord() {
    String word = _words[_currentWordIndex]['word'];
    List<String> letters = word.split('');
    
    // Acak huruf
    letters.shuffle(Random());
    
    // Pastikan huruf teracak tidak sama dengan aslinya
    int attempts = 0;
    while (letters.join('') == word && attempts < 10) {
      letters.shuffle(Random());
      attempts++;
    }
    
    setState(() {
      _scrambledLetters = letters;
      _playerAnswer = [];
      _selectedIndices = [];
      _showResult = false;
      _isCorrect = false;
      _showHint = false;
    });
  }

  void _onLetterTap(int index) {
    if (_selectedIndices.contains(index) || _showResult) return;

    setState(() {
      _selectedIndices.add(index);
      _playerAnswer.add(_scrambledLetters[index]);
    });
  }

  void _onAnswerLetterTap(int index) {
    if (_showResult) return;

    setState(() {
      int scrambledIndex = _selectedIndices[index];
      _selectedIndices.removeAt(index);
      _playerAnswer.removeAt(index);
    });
  }

  void _checkAnswer() {
    if (_playerAnswer.isEmpty) return;

    String answer = _playerAnswer.join('');
    String correctWord = _words[_currentWordIndex]['word'];

    setState(() {
      _isCorrect = answer == correctWord;
      _showResult = true;
      
      if (_isCorrect) {
        _score += 10;
      }
    });

    // Play sound
    if (_isCorrect) {
      _audioPlayer.play(AssetSource('sounds/benar.mp3'));
    } else {
      _audioPlayer.play(AssetSource('sounds/salah.mp3'));
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _nextWord();
      }
    });
  }

  void _nextWord() {
    if (_currentWordIndex < _words.length - 1) {
      setState(() {
        _currentWordIndex++;
      });
      _scrambleWord();
    } else {
      _showCompletionDialog();
    }
  }

  void _resetAnswer() {
    setState(() {
      _playerAnswer = [];
      _selectedIndices = [];
      _showResult = false;
      _isCorrect = false;
    });
  }

  void _shuffleAgain() {
    _scrambleWord();
  }

  void _toggleHint() {
    setState(() {
      _showHint = !_showHint;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '🎉 Permainan Selesai!',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$_score',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Skor Akhir',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'Kamu telah menyelesaikan ${_words.length} kata!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentWordIndex = 0;
                _score = 0;
              });
              _scrambleWord();
            },
            child: const Text('Main Lagi'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Kembali'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade300,
              Colors.blue.shade400,
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
                  child: Column(
                    children: [
                      _buildCategoryBadge(),
                      const SizedBox(height: 20),
                      _buildHintCard(),
                      const SizedBox(height: 30),
                      _buildAnswerArea(),
                      const SizedBox(height: 30),
                      _buildScrambledLetters(),
                      const SizedBox(height: 30),
                      _buildActionButtons(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 8),
                Text(
                  '$_score',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              '${_currentWordIndex + 1}/${_words.length}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Text(
        _words[_currentWordIndex]['category'],
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildHintCard() {
    return GestureDetector(
      onTap: _toggleHint,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _showHint ? Icons.lightbulb : Icons.lightbulb_outline,
                  color: Colors.amber,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Petunjuk',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            if (_showHint) ...[
              const SizedBox(height: 12),
              Text(
                _words[_currentWordIndex]['hint'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ] else ...[
              const SizedBox(height: 8),
              Text(
                'Ketuk untuk melihat petunjuk',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerArea() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _showResult
            ? (_isCorrect ? Colors.green.shade50 : Colors.red.shade50)
            : Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _showResult
              ? (_isCorrect ? Colors.green : Colors.red)
              : Colors.white,
          width: 3,
        ),
      ),
      child: Column(
        children: [
          if (_showResult)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isCorrect ? Icons.check_circle : Icons.cancel,
                    color: _isCorrect ? Colors.green : Colors.red,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isCorrect ? 'Benar!' : 'Salah!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _isCorrect ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: _playerAnswer.isEmpty
                ? [
                    Text(
                      'Susun kata di sini...',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ]
                : List.generate(_playerAnswer.length, (index) {
                    return GestureDetector(
                      onTap: () => _onAnswerLetterTap(index),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _playerAnswer[index],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
          ),
        ],
      ),
    );
  }

  Widget _buildScrambledLetters() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: List.generate(_scrambledLetters.length, (index) {
        bool isSelected = _selectedIndices.contains(index);
        
        return GestureDetector(
          onTap: () => _onLetterTap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.grey.shade300
                  : Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: isSelected
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
            ),
            child: Center(
              child: Text(
                _scrambledLetters[index],
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Colors.grey.shade500
                      : Colors.deepPurple,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _showResult ? null : _shuffleAgain,
              icon: const Icon(Icons.shuffle),
              label: const Text('Acak Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _showResult ? null : _resetAnswer,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _showResult || _playerAnswer.isEmpty ? null : _checkAnswer,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 8,
            ),
            child: const Text(
              'Cek Jawaban',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}