import 'package:flutter/material.dart';
import 'questions.dart';
import 'question_screen.dart';
import 'session.dart';

class PlayerEntryScreen extends StatelessWidget {
  final Category category;

  const PlayerEntryScreen({super.key, required this.category});

  Color get _accent {
    switch (category.id) {
      case 'aws':        return const Color(0xFFFF9900);
      case 'security':   return const Color(0xFF00C2FF);
      case 'linux':      return const Color(0xFF8BC34A);
      case 'networking': return const Color(0xFFAB47BC);
      default:           return const Color(0xFFFF9900);
    }
  }

  void _start(BuildContext context) {
    // Shuffle the full bank and pick 10 — fresh every time
    final randomQuestions = category.randomSample(count: 10);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuestionScreen(
          category: category,
          questions: randomQuestions,
          questionIndex: 0,
          score: 0,
          playerName: Session.instance.nickname,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nickname = Session.instance.nickname;

    return Scaffold(
      backgroundColor: const Color(0xFF232F3E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A242F),
        title: Text('${category.emoji} ${category.title}'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(category.emoji,
                    style: const TextStyle(fontSize: 72)),
                const SizedBox(height: 16),
                Text(
                  category.roomName,
                  style: TextStyle(
                    color: _accent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Show pool size and how many will be drawn
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 14),
                    children: [
                      const TextSpan(text: '20 random questions from a pool of '),
                      TextSpan(
                        text: '${category.questions.length}',
                        style: TextStyle(
                            color: _accent, fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: '  •  15 s each'),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '🎲 Different questions every run!',
                  style: TextStyle(
                      color: _accent.withValues(alpha: 0.8),
                      fontSize: 13,
                      fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 36),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A242F),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: _accent.withValues(alpha: 0.4), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person,
                          color: Color(0xFFFF9900), size: 28),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Playing as',
                              style: TextStyle(
                                  color: Colors.white38, fontSize: 12)),
                          Text(
                            nickname,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => _start(context),
                    icon: const Icon(Icons.shuffle),
                    label: const Text(
                      'Deal My Questions',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
