import 'package:flutter/material.dart';
import 'questions.dart';
import 'question_screen.dart';

class PlayerEntryScreen extends StatefulWidget {
  final Category category;

  const PlayerEntryScreen({super.key, required this.category});

  @override
  State<PlayerEntryScreen> createState() => _PlayerEntryScreenState();
}

class _PlayerEntryScreenState extends State<PlayerEntryScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Color get _accent {
    switch (widget.category.id) {
      case 'aws':        return const Color(0xFFFF9900);
      case 'security':   return const Color(0xFF00C2FF);
      case 'linux':      return const Color(0xFF8BC34A);
      case 'networking': return const Color(0xFFAB47BC);
      default:           return const Color(0xFFFF9900);
    }
  }

  void _start() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuestionScreen(
            category: widget.category,
            questionIndex: 0,
            score: 0,
            playerName: _controller.text.trim(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232F3E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A242F),
        title: Text('${widget.category.emoji} ${widget.category.title}'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.category.emoji,
                    style: const TextStyle(fontSize: 72),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.category.roomName,
                    style: TextStyle(
                      color: _accent,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.category.questions.length} questions • 15 seconds each',
                    style: const TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A242F),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: _accent.withValues(alpha: 0.4), width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Enter your name for the leaderboard:',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _controller,
                          autofocus: true,
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                          decoration: InputDecoration(
                            hintText: 'e.g. Alex',
                            hintStyle:
                                const TextStyle(color: Colors.white30),
                            filled: true,
                            fillColor: const Color(0xFF232F3E),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: _accent, width: 2),
                            ),
                            prefixIcon:
                                Icon(Icons.person, color: _accent),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            if (v.trim().length > 20) {
                              return 'Max 20 characters';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _start(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        foregroundColor: Colors.black,
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _start,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text(
                        'Start Challenge',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
