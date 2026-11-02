import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

/// A single score entry returned from DynamoDB.
class RemoteScore {
  final String nickname;
  final String category;
  final String categoryEmoji;
  final int score;
  final int total;
  final int percentage;
  final String playedAt;

  const RemoteScore({
    required this.nickname,
    required this.category,
    required this.categoryEmoji,
    required this.score,
    required this.total,
    required this.percentage,
    required this.playedAt,
  });

  factory RemoteScore.fromJson(Map<String, dynamic> j) => RemoteScore(
        nickname:      j['nickname'] as String? ?? 'Anonymous',
        category:      j['category'] as String? ?? '',
        categoryEmoji: j['categoryEmoji'] as String? ?? '☁️',
        score:         (j['score'] as num?)?.toInt() ?? 0,
        total:         (j['total'] as num?)?.toInt() ?? 10,
        percentage:    (j['percentage'] as num?)?.toInt() ?? 0,
        playedAt:      j['playedAt'] as String? ?? '',
      );
}

class LeaderboardService {
  LeaderboardService._();
  static final LeaderboardService instance = LeaderboardService._();

  // Whether the API URL has been configured
  bool get isConfigured =>
      !apiBaseUrl.contains('YOUR_API_ID');

  /// POST /scores — save a score to DynamoDB.
  Future<void> saveScore({
    required String nickname,
    required String category,
    required String categoryEmoji,
    required int score,
    required int total,
  }) async {
    if (!isConfigured) return; // silently skip if not set up yet

    final uri = Uri.parse('$apiBaseUrl/scores');
    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'nickname':      nickname,
            'category':      category,
            'categoryEmoji': categoryEmoji,
            'score':         score,
            'total':         total,
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to save score: ${response.statusCode}');
    }
  }

  /// GET /scores — fetch top scores, optionally filtered by category.
  Future<List<RemoteScore>> fetchScores({String? category}) async {
    if (!isConfigured) return [];

    final uri = Uri.parse('$apiBaseUrl/scores').replace(
      queryParameters: category != null ? {'category': category} : null,
    );

    final response = await http
        .get(uri)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch scores: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final list = data['scores'] as List<dynamic>? ?? [];
    return list
        .map((e) => RemoteScore.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
