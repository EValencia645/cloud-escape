import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'leaderboard_service.dart';
import 'api_config.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final _svc = LeaderboardService.instance;

  List<RemoteScore> _scores = [];
  bool _loading = false;
  String? _error;
  Timer? _autoRefresh;
  DateTime? _lastRefreshed;

  @override
  void initState() {
    super.initState();
    if (_svc.isConfigured && _svc.hasSession) {
      _fetch();
      // Auto-refresh every 10 s so everyone watching sees live scores
      _autoRefresh = Timer.periodic(
        const Duration(seconds: 10),
        (_) => _fetch(),
      );
    }
  }

  @override
  void dispose() {
    _autoRefresh?.cancel();
    super.dispose();
  }

  Future<void> _fetch() async {
    if (!mounted) return;
    setState(() { _loading = true; _error = null; });
    try {
      final scores = await _svc.fetchScores();
      if (mounted) {
        setState(() {
          _scores        = scores;
          _loading       = false;
          _lastRefreshed = DateTime.now();
        });
      }
    } catch (e) {
      if (mounted) setState(() { _loading = false; _error = e.toString(); });
    }
  }

  // ── No API configured ─────────────────────────────────────────────────────
  Widget _notConfigured() => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔧', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          const Text('Backend not set up yet',
              style: TextStyle(color: Colors.white, fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Text(
            'Follow the steps in backend/README.md\nto deploy the Lambda + DynamoDB,\nthen paste your API URL into api_config.dart.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A242F),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              apiBaseUrl,
              style: const TextStyle(color: Color(0xFFFF9900),
                  fontSize: 11, fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    ),
  );

  // ── No session started ────────────────────────────────────────────────────
  Widget _noSession() => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎮', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          const Text('No active session',
              style: TextStyle(color: Colors.white, fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'Go to Home → Start New Session\nto create a session for your trivia night.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 14, height: 1.6),
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (!_svc.isConfigured) return _scaffold(_notConfigured());
    if (!_svc.hasSession)   return _scaffold(_noSession());

    final session = _svc.activeSession!;

    return _scaffold(
      Column(
        children: [
          // ── Session header ───────────────────────────────────────────────
          Container(
            color: const Color(0xFF1A242F),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.circle, color: Colors.greenAccent, size: 10),
                    const SizedBox(width: 6),
                    Text(
                      session.sessionName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    const Spacer(),
                    if (_lastRefreshed != null)
                      Text(
                        'Updated ${_timeAgo(_lastRefreshed!)}',
                        style: const TextStyle(color: Colors.white38, fontSize: 11),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.white38, size: 12),
                    const SizedBox(width: 4),
                    Text(session.formattedTime,
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 11)),
                    const Spacer(),
                    Text(
                      '${_scores.length} player${_scores.length == 1 ? '' : 's'}',
                      style: const TextStyle(
                          color: Color(0xFFFF9900),
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),

          // ── Body ─────────────────────────────────────────────────────────
          Expanded(child: _body()),
        ],
      ),
      session: session,
    );
  }

  Widget _body() {
    if (_loading && _scores.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFFF9900)),
            SizedBox(height: 14),
            Text('Loading scores...', style: TextStyle(color: Colors.white54)),
          ],
        ),
      );
    }

    if (_error != null && _scores.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('⚠️', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              const Text('Could not load scores',
                  style: TextStyle(color: Colors.white, fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white54, fontSize: 13)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _fetch,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_scores.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🎯', style: TextStyle(fontSize: 56)),
            SizedBox(height: 16),
            Text('Waiting for players...',
                style: TextStyle(color: Colors.white, fontSize: 20,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Scores appear here as people finish.',
                style: TextStyle(color: Colors.white54)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFFFF9900),
      onRefresh: _fetch,
      child: CustomScrollView(
        slivers: [
          // Podium (top 3)
          if (_scores.length >= 2)
            SliverToBoxAdapter(child: _Podium(scores: _scores)),

          if (_scores.length >= 2)
            const SliverToBoxAdapter(
                child: Divider(color: Colors.white12, height: 1)),

          // Full ranked list
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 80),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _ScoreRow(score: _scores[i], rank: i + 1),
                childCount: _scores.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scaffold(Widget body, {GameSession? session}) {
    return Scaffold(
      backgroundColor: const Color(0xFF232F3E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A242F),
        title: const Text('🏆 Live Leaderboard'),
        centerTitle: true,
        actions: [
          if (_svc.isConfigured && _svc.hasSession) ...[
            // Manual refresh
            _loading
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white54),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white54),
                    onPressed: _fetch,
                  ),
            // Session menu
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white54),
              color: const Color(0xFF1A242F),
              onSelected: (v) => _onMenu(v, context),
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'copy_id',
                  child: Row(children: [
                    Icon(Icons.copy, color: Colors.white54, size: 18),
                    SizedBox(width: 10),
                    Text('Copy Session ID',
                        style: TextStyle(color: Colors.white)),
                  ]),
                ),
                const PopupMenuItem(
                  value: 'clear',
                  child: Row(children: [
                    Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                    SizedBox(width: 10),
                    Text('Clear All Scores',
                        style: TextStyle(color: Colors.redAccent)),
                  ]),
                ),
              ],
            ),
          ],
        ],
      ),
      body: body,
    );
  }

  Future<void> _onMenu(String action, BuildContext ctx) {
    if (action == 'copy_id') return _copySessionId(ctx);
    if (action == 'clear')   return _confirmClear(ctx);
    return Future.value();
  }

  Future<void> _copySessionId(BuildContext ctx) async {
    if (!_svc.hasSession) return;
    final messenger = ScaffoldMessenger.of(ctx);
    await Clipboard.setData(
        ClipboardData(text: _svc.activeSession!.sessionId));
    if (!mounted) return;
    messenger.showSnackBar(const SnackBar(
      content: Text('Session ID copied to clipboard'),
      backgroundColor: Color(0xFF1A242F),
      duration: Duration(seconds: 2),
    ));
  }

  Future<void> _confirmClear(BuildContext ctx) async {
    final confirm = await showDialog<bool>(
      context: ctx,
      builder: (dlg) => AlertDialog(
        backgroundColor: const Color(0xFF1A242F),
        title: const Text('Clear all scores?',
            style: TextStyle(color: Colors.white)),
        content: const Text(
          'This permanently deletes all scores in this session.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(dlg, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(dlg, true),
              child: const Text('Clear',
                  style: TextStyle(color: Colors.redAccent))),
        ],
      ),
    );
    if (confirm == true) {
      await _svc.clearSession();
      if (!mounted) return;
      setState(() { _scores = []; });
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt).inSeconds;
    if (diff < 10) return 'just now';
    if (diff < 60) return '${diff}s ago';
    return '${diff ~/ 60}m ago';
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
          if (scores.length > 1) _PodiumSlot(score: scores[1], rank: 2, height: 76),
          const SizedBox(width: 12),
          _PodiumSlot(score: scores[0], rank: 1, height: 108),
          const SizedBox(width: 12),
          if (scores.length > 2)
            _PodiumSlot(score: scores[2], rank: 3, height: 56)
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
  const _PodiumSlot({required this.score, required this.rank, required this.height});

  static const _medals = ['🥇', '🥈', '🥉'];
  static const _colors = [Color(0xFFFFD700), Color(0xFFC0C0C0), Color(0xFFCD7F32)];

  @override
  Widget build(BuildContext context) {
    final color = _colors[rank - 1];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (rank == 1)
          const Text('👑', style: TextStyle(fontSize: 22)),
        Text(_medals[rank - 1], style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(score.categoryEmoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        SizedBox(
          width: 88,
          child: Text(
            score.nickname,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: rank == 1 ? 14 : 12),
          ),
        ),
        const SizedBox(height: 2),
        Text('${score.score}/${score.total}',
            style: const TextStyle(color: Colors.white54, fontSize: 11)),
        Text('${score.percentage}%',
            style: TextStyle(
                color: score.percentage >= 80
                    ? Colors.greenAccent
                    : score.percentage >= 50
                        ? Colors.orange
                        : Colors.redAccent,
                fontSize: 11,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          width: 80,
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
          child: Text('$rank',
              style: TextStyle(
                  color: color, fontSize: 28, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

// ── Score row ─────────────────────────────────────────────────────────────────

class _ScoreRow extends StatelessWidget {
  final RemoteScore score;
  final int rank;
  const _ScoreRow({required this.score, required this.rank});

  Color get _rankColor {
    if (rank == 1) return const Color(0xFFFFD700);
    if (rank == 2) return const Color(0xFFC0C0C0);
    if (rank == 3) return const Color(0xFFCD7F32);
    return Colors.white38;
  }

  @override
  Widget build(BuildContext context) {
    final pct      = score.percentage / 100;
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
          color: rank <= 3 ? _rankColor.withValues(alpha: 0.45) : Colors.white12,
          width: rank <= 3 ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 36,
            child: rank == 1
                ? const Text('👑', style: TextStyle(fontSize: 20))
                : Text('#$rank',
                    style: TextStyle(
                        color: _rankColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
          ),
          // Category emoji
          Text(score.categoryEmoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          // Name + progress bar
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
                const SizedBox(height: 2),
                Text(score.category.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white24, fontSize: 10, letterSpacing: 1)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Score
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
