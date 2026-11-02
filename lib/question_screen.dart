import 'dart:async';
import 'package:flutter/material.dart';
import 'questions.dart';
import 'victory_screen.dart';
import 'sound_service.dart';

class QuestionScreen extends StatefulWidget {
  final Category category;
  final int questionIndex;
  final int score;
  final String playerName;

  const QuestionScreen({
    super.key,
    required this.category,
    required this.questionIndex,
    required this.score,
    required this.playerName,
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen>
    with SingleTickerProviderStateMixin {
  static const int _timerSeconds = 15;

  late int _timeLeft;
  Timer? _timer;
  int? _selectedIndex;
  bool _answered = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  Question get _question =>
      widget.category.questions[widget.questionIndex];

  bool get _isLastQuestion =>
      widget.questionIndex >= widget.category.questions.length - 1;

  @override
  void initState() {
    super.initState();
    _timeLeft = _timerSeconds;

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 12).animate(
      CurvedAnimation(
          parent: _shakeController, curve: Curves.elasticIn),
    );

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_answered) { t.cancel(); return; }
      setState(() => _timeLeft--);
      if (_timeLeft > 0 && _timeLeft <= 5) {
        SoundService.instance.tick();
      }
      if (_timeLeft <= 0) {
        t.cancel();
        _onTimeUp();
      }
    });
  }

  void _onTimeUp() {
    if (_answered) return;
    setState(() => _answered = true);
    SoundService.instance.wrong();
    _shakeController.forward(from: 0);
    _showFeedback(false, timeUp: true);
  }

  void _onAnswer(int index) {
    if (_answered) return;
    _timer?.cancel();
    final correct = index == _question.correctIndex;
    setState(() {
      _selectedIndex = index;
      _answered = true;
    });
    if (correct) {
      SoundService.instance.correct();
    } else {
      SoundService.instance.wrong();
      _shakeController.forward(from: 0);
    }
    _showFeedback(correct);
  }

  void _showFeedback(bool correct, {bool timeUp = false}) {
    final newScore = widget.score + (correct ? 1 : 0);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A242F),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Text(
          timeUp
              ? '⏰ Time\'s Up!'
              : correct
                  ? '✅ Access Granted!'
                  : '❌ Access Denied!',
          style: TextStyle(
            color: timeUp
                ? Colors.orange
                : correct
                    ? Colors.greenAccent
                    : Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!correct && !timeUp) ...[
              const Text('Correct answer:',
                  style: TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 4),
              Text(
                _question.options[_question.correctIndex],
                style: const TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
            ],
            if (timeUp) ...[
              Text(
                'The answer was: ${_question.options[_question.correctIndex]}',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),
            ],
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF232F3E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _question.meme,
                style: const TextStyle(
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                    height: 1.4),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFFF9900),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _goNext(newScore);
            },
            child: Text(
              _isLastQuestion ? 'See Results' : 'Next Question →',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _goNext(int newScore) {
    if (_isLastQuestion) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VictoryScreen(
            score: newScore,
            total: widget.category.questions.length,
            playerName: widget.playerName,
            category: widget.category,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuestionScreen(
            category: widget.category,
            questionIndex: widget.questionIndex + 1,
            score: newScore,
            playerName: widget.playerName,
          ),
        ),
      );
    }
  }

  Color _buttonColor(int index) {
    if (!_answered) return const Color(0xFF1A242F);
    if (index == _question.correctIndex) return Colors.green.shade800;
    if (index == _selectedIndex) return Colors.red.shade800;
    return const Color(0xFF1A242F);
  }

  Color _buttonBorder(int index) {
    if (!_answered) return const Color(0xFF3A4F63);
    if (index == _question.correctIndex) return Colors.greenAccent;
    if (index == _selectedIndex) return Colors.redAccent;
    return const Color(0xFF3A4F63);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _question;
    final progress =
        (widget.questionIndex + 1) / widget.category.questions.length;

    final timerColor = _timeLeft > 10
        ? Colors.greenAccent
        : _timeLeft > 5
            ? Colors.orange
            : Colors.redAccent;

    return Scaffold(
      backgroundColor: const Color(0xFF232F3E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A242F),
        title: Text('${widget.category.emoji} ${widget.category.roomName}'),
        actions: [
          // Sound toggle
          IconButton(
            icon: Icon(
              SoundService.instance.enabled
                  ? Icons.volume_up
                  : Icons.volume_off,
              color: Colors.white54,
            ),
            onPressed: () =>
                setState(() => SoundService.instance.toggle()),
          ),
          // Score chip
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9900),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.black, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${widget.score}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) => Transform.translate(
          offset: Offset(
            _shakeController.isAnimating
                ? (_shakeAnimation.value *
                    ((_shakeController.value * 10)
                            .round()
                            .isEven
                        ? 1
                        : -1))
                : 0,
            0,
          ),
          child: child,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Player name + progress
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.white38, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      widget.playerName,
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 13),
                    ),
                    const Spacer(),
                    Text(
                      'Q${widget.questionIndex + 1}/${widget.category.questions.length}',
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFF1A242F),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF9900)),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 16),

                // Timer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timer, color: timerColor, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      '$_timeLeft s',
                      style: TextStyle(
                        color: timerColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _timeLeft / _timerSeconds,
                    backgroundColor: const Color(0xFF1A242F),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(timerColor),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 20),

                // Question card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A242F),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: const Color(0xFF3A4F63), width: 1),
                  ),
                  child: Text(
                    q.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Answer options
                Expanded(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: q.options.length,
                    itemBuilder: (_, i) {
                      final labels = ['A', 'B', 'C', 'D'];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () => _onAnswer(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: _buttonColor(i),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: _buttonBorder(i), width: 2),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF9900),
                                    borderRadius:
                                        BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    labels[i],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    q.options[i],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                if (_answered &&
                                    i == _question.correctIndex)
                                  const Icon(Icons.check_circle,
                                      color: Colors.greenAccent),
                                if (_answered &&
                                    i == _selectedIndex &&
                                    i != _question.correctIndex)
                                  const Icon(Icons.cancel,
                                      color: Colors.redAccent),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
