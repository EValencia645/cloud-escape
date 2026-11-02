/// Holds the current player's nickname for the whole app session.
class Session {
  Session._();
  static final Session instance = Session._();

  String _nickname = '';
  String get nickname => _nickname;
  bool get hasNickname => _nickname.isNotEmpty;

  void setNickname(String name) => _nickname = name.trim();
}
