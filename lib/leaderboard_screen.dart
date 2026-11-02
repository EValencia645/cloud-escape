import 'package:flutter/material.dart';
import 'leaderboard.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = Leaderboard.instance.entries;

    return Scaffold(
      backgroundColor: const Color(0xFF232F3E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A242F),
        title: const Text('🏆 Leaderboard'),
        centerTitle: true,
        actions: [
          if (entries.isNotEmpty)
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: const Color(0xFF1A242F),
                    title: const Text('Clear leaderboard?',
                        style: TextStyle(color: Colors.white)),
                    content: const Text(
                      'This removes all scores for this session.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Leaderboard.instance.clear();
                          Navigator.pop(ctx);
                          Navigator.pop(context);
                        },
                        child: const Text('Clear',
                            style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Clear',
                  style: TextStyle(color: Colors.white38)),
            ),
        ],
      ),
      body: entries.isEmpty
          ? const _EmptyState()
          : Column(
              children: [
                // Podium — top 3
                if (entries.length >= 2) _Podium(entries: entries),
                const Divider(color: Colors.white12, height: 1),
                // Full list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    itemCount: entries.length,
                    itemBuilder: (_, i) => _LeaderboardRow(
                      entry: entries[i],
                      rank: i + 1,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

// ── Podium ────────────────────────────────────────────────────────────────────

class _Podium extends StatelessWidget {
  final List<LeaderboardEntry> entries;
  const _Podium({required this.entries});

  @override
  Widget build(BuildContext context) {
    final first  = entries[0];
    final second = entries.length > 1 ? entries[1] : null;
    final third  = entries.length > 2 ? entries[2] : null;

    return Container(
      color: const Color(0xFF1A242F),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (second != null)
            _PodiumSlot(entry: second, rank: 2, height: 80),
          const SizedBox(width: 12),
          _PodiumSlot(entry: first, rank: 1, height: 110),
          const SizedBox(width: 12),
          if (third != null)
            _PodiumSlot(entry: third, rank: 3, height: 60)
          else
            const SizedBox(width: 80),
        ],
      ),
    );
  }
}

class _PodiumSlot extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;
  final double height;

  const _PodiumSlot({
    required this.entry,
    required this.rank,
    required this.height,
  });

  static const _medals = ['🥇', '🥈', '🥉'];
  static const _colors = [
    Color(0xFFFFD700),
    Color(0xFFC0C0C0),
    Color(0xFFCD7F32),
  ];

  @override
  Widget build(BuildContext context) {
    final color = _colors[rank - 1];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_medals[rank - 1], style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(
          entry.categoryEmoji,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 90,
          child: Text(
            entry.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: rank == 1 ? 15 : 13,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          entry.scoreLabel,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        const SizedBox(height: 6),
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            border: Border(
              top:   BorderSide(color: color, width: 2),
              left:  BorderSide(color: color, width: 2),
              right: BorderSide(color: color, width: 2),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            '$rank',
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Row ───────────────────────────────────────────────────────────────────────

class _LeaderboardRow extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;

  const _LeaderboardRow({required this.entry, required this.rank});

  Color get _rankColor {
    if (rank == 1) return const Color(0xFFFFD700);
    if (rank == 2) return const Color(0xFFC0C0C0);
    if (rank == 3) return const Color(0xFFCD7F32);
    return Colors.white38;
  }

  @override
  Widget build(BuildContext context) {
    final pct = entry.percentage;
    final barColor = pct >= 0.8
        ? Colors.greenAccent
        : pct >= 0.5
            ? Colors.orange
            : Colors.redAccent;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A242F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: rank <= 3
              ? _rankColor.withValues(alpha: 0.4)
              : Colors.white12,
          width: rank <= 3 ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Rank number
          SizedBox(
            width: 32,
            child: Text(
              '#$rank',
              style: TextStyle(
                color: _rankColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Category emoji
          Text(entry.categoryEmoji,
              style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          // Name + progress bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: Colors.white12,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(barColor),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                entry.scoreLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '${(pct * 100).round()}%',
                style: TextStyle(
                  color: barColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('🏆', style: TextStyle(fontSize: 64)),
          SizedBox(height: 16),
          Text(
            'No scores yet!',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Play a round to get on the board.',
            style: TextStyle(color: Colors.white54, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
