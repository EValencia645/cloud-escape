import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'nickname_screen.dart';
import 'category_screen.dart';
import 'leaderboard_screen.dart';
import 'leaderboard_service.dart';
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
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      initialRoute: '/nickname',
      routes: {
        '/nickname': (_) => const NicknameScreen(),
        '/home':     (_) => const HomeScreen(),
      },
    );
  }
}

// ── Home Screen ───────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _svc = LeaderboardService.instance;

  // ── New Session dialog ────────────────────────────────────────────────────
  Future<void> _showNewSessionDialog() async {
    final controller = TextEditingController(
        text: 'Trivia Night ${DateTime.now().day}/${DateTime.now().month}');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A242F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('🎮 Start New Session',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Give this trivia night a name.\nAll scores will be grouped under this session.',
              style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Session name',
                hintStyle: const TextStyle(color: Colors.white30),
                filled: true,
                fillColor: const Color(0xFF232F3E),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: Color(0xFFFF9900), width: 2)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.white38))),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Create')),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      final session = await _svc.createSession(controller.text.trim());
      if (!mounted) return;
      setState(() {});
      _showSessionCreated(session);
    } catch (e) {
      if (!mounted) return;
      _showError('Could not create session: $e');
    }
  }

  void _showSessionCreated(GameSession session) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A242F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('✅ Session Created!',
            style: TextStyle(
                color: Colors.greenAccent, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(session.sessionName,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Share this Session ID with players:',
                style: TextStyle(color: Colors.white54, fontSize: 13)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
              decoration: BoxDecoration(
                color: const Color(0xFF232F3E),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: const Color(0xFFFF9900).withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      session.sessionId,
                      style: const TextStyle(
                          color: Color(0xFFFF9900),
                          fontSize: 12,
                          fontFamily: 'monospace'),
                    ),
                  ),
                  _CopyButton(text: session.sessionId),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Players enter this ID on their device\nunder "Join Session" to link their scores.',
              style: TextStyle(
                  color: Colors.white38, fontSize: 12, height: 1.5),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Got it!')),
        ],
      ),
    );
  }

  // ── Join Session dialog ───────────────────────────────────────────────────
  Future<void> _showJoinSessionDialog() async {
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A242F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('🔗 Join Session',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter the Session ID shared by the host.',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              style: const TextStyle(
                  color: Colors.white, fontFamily: 'monospace', fontSize: 13),
              decoration: InputDecoration(
                hintText: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
                hintStyle: const TextStyle(
                    color: Colors.white24, fontSize: 12),
                filled: true,
                fillColor: const Color(0xFF232F3E),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                        color: Color(0xFFFF9900), width: 2)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.white38))),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Join')),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await _svc.joinSession(controller.text.trim());
      if (!mounted) return;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '✅ Joined "${_svc.activeSession?.sessionName}"'),
          backgroundColor: const Color(0xFF1A242F),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showError('Could not join session: $e');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.redAccent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final nickname     = Session.instance.nickname;
    final hasSession   = _svc.isConfigured && _svc.hasSession;
    final sessionName  = _svc.activeSession?.sessionName;

    return Scaffold(
      backgroundColor: const Color(0xFF232F3E),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Logo ────────────────────────────────────────────────────
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
                  child: const Text('☁️', style: TextStyle(fontSize: 64)),
                ),
                const SizedBox(height: 20),
                const Text('Cloud Escape',
                    style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1)),
                const SizedBox(height: 6),

                // Nickname chip
                if (nickname.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 5),
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
                            color: Color(0xFFFF9900), size: 15),
                        const SizedBox(width: 5),
                        Text(nickname,
                            style: const TextStyle(
                                color: Color(0xFFFF9900),
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                      ],
                    ),
                  ),
                const SizedBox(height: 6),

                // Active session chip
                if (hasSession)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.greenAccent.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.circle,
                            color: Colors.greenAccent, size: 8),
                        const SizedBox(width: 6),
                        Text('Session: $sessionName',
                            style: const TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),

                const SizedBox(height: 28),

                // ── Play button ──────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(
                            builder: (_) => const CategoryScreen())),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play'),
                  ),
                ),
                const SizedBox(height: 10),

                // ── Leaderboard ──────────────────────────────────────────────
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
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(
                            builder: (_) => const LeaderboardScreen())),
                    icon: const Icon(Icons.leaderboard),
                    label: const Text('Live Leaderboard'),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Session controls ─────────────────────────────────────────
                if (_svc.isConfigured) ...[
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 8),
                  const Text('SESSION',
                      style: TextStyle(
                          color: Colors.white24,
                          fontSize: 11,
                          letterSpacing: 2)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white70,
                            side: const BorderSide(color: Colors.white24),
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _showNewSessionDialog,
                          icon: const Icon(Icons.add_circle_outline,
                              size: 18),
                          label: const Text('New Session',
                              style: TextStyle(fontSize: 13)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white70,
                            side: const BorderSide(color: Colors.white24),
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _showJoinSessionDialog,
                          icon: const Icon(Icons.link, size: 18),
                          label: const Text('Join Session',
                              style: TextStyle(fontSize: 13)),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),

                // Change nickname
                TextButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/nickname', (r) => false),
                  child: const Text('Change Nickname',
                      style:
                          TextStyle(color: Colors.white24, fontSize: 12)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Copy button ───────────────────────────────────────────────────────────────

class _CopyButton extends StatefulWidget {
  final String text;
  const _CopyButton({required this.text});

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.text));
    if (!mounted) return;
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _copied ? 'Copied!' : 'Copy to clipboard',
      child: IconButton(
        onPressed: _copy,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            _copied ? Icons.check : Icons.copy,
            key: ValueKey(_copied),
            color: _copied ? Colors.greenAccent : const Color(0xFFFF9900),
            size: 18,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        constraints: const BoxConstraints(),
        splashRadius: 18,
      ),
    );
  }
}
