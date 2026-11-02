import 'package:flutter/material.dart';
import 'category_screen.dart';
import 'leaderboard_screen.dart';

void main() {
  runApp(const CloudEscapeApp());
}

class CloudEscapeApp extends StatelessWidget {
  const CloudEscapeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF9900),
          secondary: Color(0xFFFF9900),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A242F),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF9900),
            foregroundColor: Colors.black,
            padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232F3E),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A242F),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF9900).withValues(alpha: 0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Text('☁️',
                      style: TextStyle(fontSize: 64)),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Cloud Escape',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'The ultimate tech trivia night.\nProve you know your cloud.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white54,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 36),

                // Feature pills
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: const [
                    _FeaturePill('🏆 Leaderboard'),
                    _FeaturePill('⏰ 15s Timer'),
                    _FeaturePill('😂 Memes'),
                    _FeaturePill('🔔 Sound FX'),
                    _FeaturePill('4 Rooms × 10 Qs'),
                  ],
                ),
                const SizedBox(height: 40),

                // Start game
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const CategoryScreen()),
                    ),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Game'),
                  ),
                ),
                const SizedBox(height: 14),

                // Leaderboard
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF9900),
                      side: const BorderSide(
                          color: Color(0xFFFF9900), width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LeaderboardScreen()),
                    ),
                    icon: const Icon(Icons.leaderboard),
                    label: const Text('Leaderboard'),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'v2.0 • Good luck, Cloud Explorer.',
                  style: TextStyle(color: Colors.white24, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final String label;
  const _FeaturePill(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A242F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: const Color(0xFFFF9900).withValues(alpha: 0.35),
            width: 1),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }
}
