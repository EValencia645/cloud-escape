import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class RemoteScore {
  final String nickname;
  final String category;
  final String categoryEmoji;
  final int score;
  final int total;
  final int percentage;
  final String playedAt;

  RemoteScore({
    required this.nickname,
    required this.category,
    required this.categoryEmoji,
    required this.score,
    required this.total,
    required this.percentage,
    required this.playedAt,
  });

  factory RemoteScore.fromJson(Map<String, dynamic> j) => RemoteScore(
        nickname:      j['nickname']      as String? ?? 'Anonymous',
        category:      j['category']      as String? ?? '',
        categoryEmoji: j['categoryEmoji'] as String? ?? '☁️',
        score:         (j['score']      as num?)?.toInt() ?? 0,
        total:         (j['total']      as num?)?.toInt() ?? 20,
        percentage:    (j['percentage'] as num?)?.toInt() ?? 0,
        playedAt:      j['playedAt']      as String? ?? '',
      );
}

class GameSession {
  final String sessionId;
  final String sessionName;
  final String createdAt;

  GameSession({
    required this.sessionId,
    required this.sessionName,
    required this.createdAt,
  });

  factory GameSession.fromJson(Map<String, dynamic> j) => GameSession(
        sessionId:   j['sessionId']   as String? ?? '',
        sessionName: j['sessionName'] as String? ?? 'Trivia Night',
        createdAt:   j['createdAt']   as String? ?? '',
      );

  /// Formatted start time, e.g. "Nov 1 2026 • 19:30"
  String get formattedTime {
    try {
      final dt  = DateTime.parse(createdAt).toLocal();
      final mon = ['Jan','Feb','Mar','Apr','May','Jun',
                   'Jul','Aug','Sep','Oct','Nov','Dec'][dt.month - 1];
      final hh  = dt.hour.toString().padLeft(2, '0');
      final mm  = dt.minute.toString().padLeft(2, '0');
      return '$mon ${dt.day} ${dt.year}  •  $hh:$mm';
    } catch (_) {
      return createdAt;
    }
  }
}

class LeaderboardService {
  LeaderboardService._();
  static final LeaderboardService instance = LeaderboardService._();

  // Active session — set by host via createSession()
  GameSession? _activeSession;
  GameSession? get activeSession => _activeSession;
  bool get hasSession => _activeSession != null;

  bool get isConfigured => !apiBaseUrl.contains('YOUR_API_ID');

  // ── Session management ────────────────────────────────────────────────────

  /// Host creates a new session. Returns the session so the ID can be shared.
  Future<GameSession> createSession(String name) async {
    final uri = Uri.parse('$apiBaseUrl/sessions');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    ).timeout(const Duration(seconds: 10));

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to create session (${res.statusCode}): ${res.body}');
    }

    final decoded = jsonDecode(res.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected response: ${res.body}');
    }
    _activeSession = GameSession.fromJson(decoded);
    return _activeSession!;
  }

  /// Load an existing session by ID (players join via the ID the host shares).
  Future<GameSession> joinSession(String sessionId) async {
    final uri = Uri.parse('$apiBaseUrl/sessions/$sessionId');
    final res = await http.get(uri).timeout(const Duration(seconds: 10));

    if (res.statusCode == 404) throw Exception('Session not found');
    if (res.statusCode != 200) throw Exception('Error: ${res.statusCode}');

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    _activeSession = GameSession.fromJson(data['session'] as Map<String, dynamic>);
    return _activeSession!;
  }

  /// Delete all scores in the active session (host only).
  Future<void> clearSession() async {
    if (_activeSession == null) return;
    final uri = Uri.parse('$apiBaseUrl/sessions/${_activeSession!.sessionId}');
    await http.delete(uri).timeout(const Duration(seconds: 10));
    _activeSession = null;
  }

  // ── Scores ────────────────────────────────────────────────────────────────

  /// Save a score to the active session.
  Future<void> saveScore({
    required String nickname,
    required String category,
    required String categoryEmoji,
    required int score,
    required int total,
  }) async {
    if (!isConfigured || _activeSession == null) return;

    final uri = Uri.parse('$apiBaseUrl/scores');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'sessionId':     _activeSession!.sessionId,
        'nickname':      nickname,
        'category':      category,
        'categoryEmoji': categoryEmoji,
        'score':         score,
        'total':         total,
      }),
    ).timeout(const Duration(seconds: 10));

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Failed to save score: ${res.statusCode}');
    }
  }

  /// Fetch scores for the active session.
  Future<List<RemoteScore>> fetchScores() async {
    if (!isConfigured || _activeSession == null) return [];

    final uri = Uri.parse('$apiBaseUrl/scores')
        .replace(queryParameters: {'sessionId': _activeSession!.sessionId});

    final res = await http.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) throw Exception('Failed: ${res.statusCode}');

    final data  = jsonDecode(res.body) as Map<String, dynamic>;
    final list  = data['scores'] as List<dynamic>? ?? [];
    return list.map((e) => RemoteScore.fromJson(e as Map<String, dynamic>)).toList();
  }
}
