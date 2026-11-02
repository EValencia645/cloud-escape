import 'package:flutter/material.dart';
import 'nickname_screen.dart';
import 'category_screen.dart';
import 'leaderboard_screen.dart';
import 'session.dart';

void main() {
  runApp(const CloudEscapeApp());
}

class CloudEscapeApp extends StatelessWidget {
  const CloudEscapeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cloud Escape',
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
      // Named routes so "Next Player" can pop everything and restart
      initialRoute: '/nickname',
      routes: {
        '/nickname': (_) => const NicknameScreen(),
        '/home':     (_) => const HomeScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nickname = Session.instance.nickname;

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
                        color: const Color(0xFFFF9900)
                            .withValues(alpha: 0.3),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Text('☁️',
                      style: TextStyle(fontSize: 64)),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Cloud Escape',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                if (nickname.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A242F),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFFFF9900)
                              .withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person,
                            color: Color(0xFFFF9900), size: 16),
                        const SizedBox(width: 6),
                        Text(
                          nickname,
                          style: const TextStyle(
                            color: Color(0xFFFF9900),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
                const Text(
                  'The ultimate tech trivia night.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 32),

                // Feature pills
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: const [
                    _FeaturePill('🌐 Global Leaderboard'),
                    _FeaturePill('⏰ 15s Timer'),
                    _FeaturePill('😂 Memes'),
                    _FeaturePill('🔔 Sound FX'),
                    _FeaturePill('4 Rooms × 10 Qs'),
                  ],
                ),
                const SizedBox(height: 36),

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
                const SizedBox(height: 12),

                // Leaderboard
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF9900),
                      side: const BorderSide(
                          color: Color(0xFFFF9900), width: 1.5),
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
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
                const SizedBox(height: 12),

                // Change nickname
                TextButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/nickname',
                    (r) => false,
                  ),
                  child: const Text(
                    'Change Nickname',
                    style: TextStyle(color: Colors.white38, fontSize: 13),
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
            color:
                const Color(0xFFFF9900).withValues(alpha: 0.35),
            width: 1),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }
}
