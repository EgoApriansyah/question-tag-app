import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'materi_page.dart';
import 'latihan_page.dart';
import 'kuis_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.purple.shade50,
              Colors.pink.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // HEADER SECTION
                _buildHeader(),
                const SizedBox(height: 20),

                // ANIMASI LOTTIE dengan Card
                _buildAnimationCard(),
                const SizedBox(height: 30),

                // WELCOME TEXT
                _buildWelcomeText(),
                const SizedBox(height: 25),

                // MENU BUTTONS
                _buildMenuCard(
                  context,
                  title: "Penjelasan Materi",
                  subtitle: "Pelajari apa itu Tag Question",
                  page: const MateriPage(),
                  icon: Icons.book_rounded,
                  gradient: [Colors.blue.shade400, Colors.blue.shade600],
                ),

                _buildMenuCard(
                  context,
                  title: "Latihan Soal",
                  subtitle: "Latihan soal dengan jawaban langsung",
                  page: const LatihanPage(),
                  icon: Icons.edit_note_rounded,
                  gradient: [Colors.green.shade400, Colors.green.shade600],
                ),

                _buildMenuCard(
                  context,
                  title: "Kuis Cepat",
                  subtitle: "10 soal acak, siap test kemampuanmu?",
                  page: const KuisPage(),
                  icon: Icons.quiz_rounded,
                  gradient: [Colors.orange.shade400, Colors.orange.shade600],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // HEADER WIDGET
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.school_rounded,
              color: Colors.blue.shade600,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tag Question",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              Text(
                "Learning App",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ANIMATION CARD
  Widget _buildAnimationCard() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Center(
          child: _buildLottieAnimation(),
        ),
      ),
    );
  }

  // LOTTIE ANIMATION dengan multiple fallback options
  Widget _buildLottieAnimation() {
    // OPSI 1: Coba load dari assets lokal
    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 100)),
      builder: (context, snapshot) {
        return Lottie.asset(
          "assets/lottie/study.json",
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // OPSI 2: Gunakan Lottie dari network (online)
            return Lottie.network(
              'https://lottie.host/2c7c6b8a-42b6-4f42-b8b9-2e5c6d8f9e1a/z9KxJ5H5bU.json',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // OPSI 3: Fallback ke ilustrasi custom
                return _buildCustomIllustration();
              },
            );
          },
        );
      },
    );
  }

  // CUSTOM ILLUSTRATION sebagai fallback terakhir
  Widget _buildCustomIllustration() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
            ),
            Icon(
              Icons.menu_book_rounded,
              size: 70,
              color: Colors.blue.shade600,
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          "📚 Let's Learn!",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
      ],
    );
  }

  // WELCOME TEXT
  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          "Mulai Belajar! 🚀",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Pilih menu di bawah untuk memulai",
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  // ENHANCED MENU CARD
  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required Widget page,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // ICON CONTAINER
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 18),

              // TEXT CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              // ARROW ICON
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}