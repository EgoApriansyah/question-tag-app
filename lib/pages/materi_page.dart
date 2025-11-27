import 'package:flutter/material.dart';

class MateriPage extends StatelessWidget {
  const MateriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Penjelasan Materi"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _title("Apa itu Tag Question?"),

              _text(
                  "Tag Question adalah bentuk kalimat tanya singkat yang "
                  "ditambahkan di akhir kalimat untuk meminta persetujuan "
                  "atau memastikan informasi."),

              const SizedBox(height: 10),
              _exampleBox(
                "You are a student, **aren't you?**",
                "Kamu seorang pelajar, bukan?",
              ),

              const SizedBox(height: 20),
              _title("Aturan Umum Tag Question"),

              _bullet("Kalimat positif → tag negatif."),
              _bullet("Kalimat negatif → tag positif."),
              _bullet("Gunakan auxiliary verb yang sama dengan kalimat utama."),
              _bullet("Gunakan subjek pronomina (you, he, she, they, it)."),

              const SizedBox(height: 20),
              _title("Contoh Kalimat Positif → Tag Negatif"),

              _exampleBox(
                "She is smart, **isn't she?**",
                "Dia pintar, bukan?",
              ),
              _exampleBox(
                "They can swim, **can't they?**",
                "Mereka bisa berenang, kan?",
              ),

              const SizedBox(height: 20),
              _title("Contoh Kalimat Negatif → Tag Positif"),

              _exampleBox(
                "He isn't tired, **is he?**",
                "Dia tidak capek, kan?",
              ),
              _exampleBox(
                "You don't like coffee, **do you?**",
                "Kamu tidak suka kopi, ya?",
              ),

              const SizedBox(height: 20),
              _title("Catatan Penting"),

              _bullet("Khusus ‘I am’, tag-nya adalah **aren’t I?**"),
              _exampleBox(
                "I am your friend, **aren't I?**",
                "Aku temanmu, kan?",
              ),

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Kembali"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _text(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        height: 1.5,
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("•  "),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _exampleBox(String eng, String indo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.blue.withOpacity(0.1),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eng,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            indo,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
