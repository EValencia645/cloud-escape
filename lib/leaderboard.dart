/// In-memory leaderboard for a single trivia night session.
/// Survives hot reload; resets when the app fully restarts.
class LeaderboardEntry {
  final String name;
  final String categoryId;
  final String categoryEmoji;
  final int score;
  final int total;
  final DateTime playedAt;

  LeaderboardEntry({
    required this.name,
    required this.categoryId,
    required this.categoryEmoji,
    required this.score,
    required this.total,
  }) : playedAt = DateTime.now();

  double get percentage => score / total;
  String get scoreLabel => '$score / $total';
}

class Leaderboard {
  Leaderboard._();
  static final Leaderboard instance = Leaderboard._();

  final List<LeaderboardEntry> _entries = [];

  List<LeaderboardEntry> get entries {
    final sorted = [..._entries];
    sorted.sort((a, b) {
      // Primary: score descending
      final cmp = b.score.compareTo(a.score);
      if (cmp != 0) return cmp;
      // Tiebreak: faster (played earlier in session) wins
      return a.playedAt.compareTo(b.playedAt);
    });
    return sorted;
  }

  void add(LeaderboardEntry entry) => _entries.add(entry);

  void clear() => _entries.clear();

  bool get isEmpty => _entries.isEmpty;
}
