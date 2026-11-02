import 'package:audioplayers/audioplayers.dart';

/// Singleton sound service. Call SoundService.instance.play*() anywhere.
class SoundService {
  SoundService._();
  static final SoundService instance = SoundService._();

  bool _enabled = true;
  bool get enabled => _enabled;

  void toggle() => _enabled = !_enabled;

  Future<void> _play(String asset) async {
    if (!_enabled) return;
    try {
      final player = AudioPlayer();
      await player.setReleaseMode(ReleaseMode.release); // auto-dispose
      await player.play(AssetSource('sounds/$asset'));
    } catch (_) {
      // Never crash the game over audio
    }
  }

  void correct() => _play('correct.wav');
  void wrong()   => _play('wrong.wav');
  void tick()    => _play('tick.wav');
  void victory() => _play('victory.wav');
}
