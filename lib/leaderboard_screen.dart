import 'package:flutter/material.dart';
import 'leaderboard.dart';
import 'leaderboard_service.dart';
import 'api_config.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  // Remote (DynamoDB) state
  List<RemoteScore> _remoteScores = [];
  bool _loadingRemote = false;
  String? _remoteError;

  // Local (in-memory) scores — still shown as fallback
  List<LeaderboardEntry> get _localScores => Leaderboard.instance.entries;

  final bool _apiConfigured = LeaderboardService.instance.isConfigured;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: _apiConfigured ? 2 : 1, vsync: this);
    if (_apiConfigured) _fetchRemote();
  }

  Future<void> _fetchRemote() async {
    setState(() { _loadingRemote = true; _remoteError = null; });
    try {
      final scores = await LeaderboardService.instance.fetchScores();
      if (mounted) setState(() { _remoteScores = scores; _loadingRemote = false; });
    } catch (e) {
      if (mounted) setState(() { _remoteError = e.toString(); _loadingRemote = false; });
    }
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232F3E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A242F),
        title: const Text('🏆 Leaderboard'),
        centerTitle: true,
        bottom: _apiConfigured
            ? TabBar(
                controller: _tabs,
                indicatorColor: const Color(0xFFFF9900),
                labelColor: const Color(0xFFFF9900),
                unselectedLabelColor: Colors.white38,
                tabs: const [
                  Tab(text: '🌐 Global'),
                  Tab(text: '📱 This Session'),
                ],
              )
            : null,
        actions: [
          if (_apiConfigured)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white54),
              onPressed: _fetchRemote,
            ),
        ],
      ),
      body: _apiConfigured
          ? TabBarView(
              controller: _tabs,
              children: [
                _RemoteLeaderboard(
                  scores: _remoteScores,
                  loading: _loadingRemote,
                  error: _remoteError,
                  onRetry: _fetchRemote,
                ),
                _LocalLeaderboard(entries: _localScores),
              ],
            )
          : _LocalLeaderboard(entries: _localScores),
    );
  }
}

// ── Remote (DynamoDB) tab ─────────────────────────────────────────────────────

class _RemoteLeaderboard extends StatelessWidget {
  final List<RemoteScore> scores;
  final bool loading;
  final String? error;
  final VoidCallback onRetry;

  const _RemoteLeaderboard({
    required this.scores,
    required this.loading,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFFF9900)),
            SizedBox(height: 16),
            Text('Fetching global scores...',
                style: TextStyle(color: Colors.white54)),
          ],
        ),
      );
    }
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('⚠️', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              const Text('Could not load scores',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                apiBaseUrl.contains('YOUR_API_ID')
                    ? 'API not configured yet.\nSee backend/README.md to set up DynamoDB.'
                    : error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
    if (scores.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🌐', style: TextStyle(fontSize: 56)),
            SizedBox(height: 16),
            Text('No global scores yet!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Be the first to get on the board.',
                style: TextStyle(color: Colors.white54)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFFFF9900),
      onRefresh: () async => onRetry(),
      child: Column(
        children: [
          if (scores.length >= 3) _Podium(scores: scores),
          const Divider(color: Colors.white12, height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              itemCount: scores.length,
              itemBuilder: (_, i) => _RemoteRow(score: scores[i], rank: i + 1),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Podium ────────────────────────────────────────────────────────────────────

class _Podium extends StatelessWidget {
  final List<RemoteScore> scores;
  const _Podium({required this.scores});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A242F),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _PodiumSlot(score: scores[1], rank: 2, height: 75),
          const SizedBox(width: 12),
          _PodiumSlot(score: scores[0], rank: 1, height: 105),
          const SizedBox(width: 12),
          if (scores.length > 2)
            _PodiumSlot(score: scores[2], rank: 3, height: 55)
          else
            const SizedBox(width: 82),
        ],
      ),
    );
  }
}

class _PodiumSlot extends StatelessWidget {
  final RemoteScore score;
  final int rank;
  final double height;
  const _PodiumSlot(
      {required this.score, required this.rank, required this.height});

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
        Text(_medals[rank - 1], style: const TextStyle(fontSize: 26)),
        const SizedBox(height: 4),
        Text(score.categoryEmoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        SizedBox(
          width: 86,
          child: Text(
            score.nickname,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: rank == 1 ? 14 : 12,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${score.score}/${score.total}',
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
        const SizedBox(height: 6),
        Container(
          width: 78,
          height: height,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.13),
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
                color: color, fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

// ── Remote row ────────────────────────────────────────────────────────────────

class _RemoteRow extends StatelessWidget {
  final RemoteScore score;
  final int rank;
  const _RemoteRow({required this.score, required this.rank});

  Color get _rankColor {
    if (rank == 1) return const Color(0xFFFFD700);
    if (rank == 2) return const Color(0xFFC0C0C0);
    if (rank == 3) return const Color(0xFFCD7F32);
    return Colors.white38;
  }

  @override
  Widget build(BuildContext context) {
    final pct = score.percentage / 100;
    final barColor = pct >= 0.8
        ? Colors.greenAccent
        : pct >= 0.5
            ? Colors.orange
            : Colors.redAccent;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
          SizedBox(
            width: 32,
            child: Text('#$rank',
                style: TextStyle(
                    color: _rankColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ),
          Text(score.categoryEmoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(score.nickname,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation<Color>(barColor),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${score.score}/${score.total}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              Text('${score.percentage}%',
                  style: TextStyle(color: barColor, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Local (session) tab ───────────────────────────────────────────────────────

class _LocalLeaderboard extends StatelessWidget {
  final List<LeaderboardEntry> entries;
  const _LocalLeaderboard({required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('📱', style: TextStyle(fontSize: 56)),
            SizedBox(height: 16),
            Text('No scores this session yet!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Play a round to get on the board.',
                style: TextStyle(color: Colors.white54)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      itemCount: entries.length,
      itemBuilder: (_, i) => _LocalRow(entry: entries[i], rank: i + 1),
    );
  }
}

class _LocalRow extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;
  const _LocalRow({required this.entry, required this.rank});

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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A242F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: rank <= 3
              ? _rankColor.withValues(alpha: 0.4)
              : Colors.white12,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text('#$rank',
                style: TextStyle(
                    color: _rankColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
          ),
          Text(entry.categoryEmoji,
              style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation<Color>(barColor),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(entry.scoreLabel,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              Text('${(pct * 100).round()}%',
                  style: TextStyle(color: barColor, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
