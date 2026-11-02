import 'package:flutter/material.dart';
import 'leaderboard.dart';
import 'leaderboard_screen.dart';
import 'leaderboard_service.dart';
import 'questions.dart';
import 'sound_service.dart';

class VictoryScreen extends StatefulWidget {
  final int score;
  final int total;
  final String playerName;
  final Category category;

  const VictoryScreen({
    super.key,
    required this.score,
    required this.total,
    required this.playerName,
    required this.category,
  });

  @override
  State<VictoryScreen> createState() => _VictoryScreenState();
}

class _VictoryScreenState extends State<VictoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  bool _saving = false;
  bool _saved = false;
  String? _saveError;

  String get _grade {
    final pct = widget.score / widget.total;
    if (pct == 1.0) return 'S';
    if (pct >= 0.8) return 'A';
    if (pct >= 0.6) return 'B';
    if (pct >= 0.4) return 'C';
    return 'D';
  }

  String get _title {
    final pct = widget.score / widget.total;
    if (pct == 1.0) return '🏆 LEGENDARY CLOUD MASTER';
    if (pct >= 0.8) return '🥇 Cloud Champion';
    if (pct >= 0.6) return '🥈 Cloud Explorer';
    if (pct >= 0.4) return '🥉 Cloud Apprentice';
    return '☁️ Keep Exploring!';
  }

  String get _meme {
    final pct = widget.score / widget.total;
    final name = widget.playerName;
    if (pct == 1.0) return '😎 $name didn\'t miss a single question.\nThe cloud fears them.';
    if (pct >= 0.8) return '🔥 Almost perfect, $name!\nYour AWS bill is still scary though.';
    if (pct >= 0.6) return '👍 Not bad, $name!\nBut Stack Overflow knows what you Googled.';
    if (pct >= 0.4) return '😅 Half right, $name!\nAt least you didn\'t rm -rf /.';
    return '💀 The cloud has defeated $name...\nHave you tried turning it off and on again?';
  }

  Color get _gradeColor {
    final pct = widget.score / widget.total;
    if (pct == 1.0) return const Color(0xFFFFD700);
    if (pct >= 0.8) return Colors.greenAccent;
    if (pct >= 0.6) return const Color(0xFFFF9900);
    if (pct >= 0.4) return Colors.orange;
    return Colors.redAccent;
  }

  @override
  void initState() {
    super.initState();

    // Save to local leaderboard
    Leaderboard.instance.add(LeaderboardEntry(
      name: widget.playerName,
      categoryId: widget.category.id,
      categoryEmoji: widget.category.emoji,
      score: widget.score,
      total: widget.total,
    ));

    // Save to DynamoDB
    _saveToCloud();

    SoundService.instance.victory();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );
    _animController.forward();
  }

  Future<void> _saveToCloud() async {
    if (!LeaderboardService.instance.isConfigured) return;
    if (mounted) setState(() => _saving = true);
    try {
      await LeaderboardService.instance.saveScore(
        nickname:      widget.playerName,
        category:      widget.category.id,
        categoryEmoji: widget.category.emoji,
        score:         widget.score,
        total:         widget.total,
      );
      if (mounted) setState(() { _saving = false; _saved = true; });
    } catch (e) {
      if (mounted) setState(() { _saving = false; _saveError = 'Could not save to cloud'; });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232F3E),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated grade circle
                ScaleTransition(
                  scale: _scaleAnim,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1A242F),
                      border: Border.all(color: _gradeColor, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: _gradeColor.withValues(alpha: 0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _grade,
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: _gradeColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  widget.playerName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: _gradeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),

                // Cloud save status
                if (LeaderboardService.instance.isConfigured)
                  _CloudSaveStatus(
                      saving: _saving,
                      saved: _saved,
                      error: _saveError),

                const SizedBox(height: 16),

                // Score card
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A242F),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _gradeColor, width: 2),
                  ),
                  child: Column(
                    children: [
                      Text(widget.category.emoji,
                          style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 4),
                      Text(
                        widget.category.title,
                        style: TextStyle(
                          color: _gradeColor,
                          fontSize: 13,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${widget.score} / ${widget.total}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${((widget.score / widget.total) * 100).round()}%',
                        style:
                            TextStyle(color: _gradeColor, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Meme
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A242F),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _meme,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Leaderboard button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9900),
                      foregroundColor: Colors.black,
                      padding:
                          const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LeaderboardScreen()),
                    ),
                    icon: const Icon(Icons.leaderboard),
                    label: const Text(
                      'View Leaderboard',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Play another room / Home
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white70,
                          side:
                              const BorderSide(color: Colors.white24),
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => Navigator.of(context)
                            .popUntil((r) => r.isFirst),
                        icon: const Icon(Icons.home),
                        label: const Text('Home'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFF9900),
                          side: const BorderSide(
                              color: Color(0xFFFF9900)),
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          // Pass phone to next player —
                          // go back to nickname screen
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/nickname',
                            (r) => false,
                          );
                        },
                        icon: const Icon(Icons.person_add),
                        label: const Text('Next Player'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Cloud save status chip ────────────────────────────────────────────────────

class _CloudSaveStatus extends StatelessWidget {
  final bool saving;
  final bool saved;
  final String? error;

  const _CloudSaveStatus(
      {required this.saving, required this.saved, required this.error});

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    final String label;
    final Color color;

    if (saving) {
      icon  = Icons.cloud_upload;
      label = 'Saving to global leaderboard...';
      color = Colors.white38;
    } else if (saved) {
      icon  = Icons.cloud_done;
      label = 'Score saved to global leaderboard ✓';
      color = Colors.greenAccent;
    } else if (error != null) {
      icon  = Icons.cloud_off;
      label = 'Saved locally only (no internet?)';
      color = Colors.orange;
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          saving
              ? SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: color),
                )
              : Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}
