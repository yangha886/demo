import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:star/util/stringutil.dart';
class GameSound{
  AudioPlayer _audioPlayer;
  final AudioCache _playercache;
  AudioPlayer _audioPlayer1;
  final AudioCache _playercache1;
  AudioPlayer _audioPlayer2;
  final AudioCache _playercache2;
  static GameSound _instance;

  GameSound(this._playercache,this._playercache1,this._playercache2);
  
  static GameSound getInstance() {
    if (_instance == null) {
      AudioCache player = AudioCache();
      AudioCache player1 = AudioCache();
      AudioCache player2 = AudioCache();
      _instance = GameSound(player,player1,player2);
    }
    return _instance;
  }
  void playAudio(String type) async {
    _audioPlayer = null;
    if(soundOn == true)
      _audioPlayer = await _playercache.play("sounds/$type.mp3",mode: PlayerMode.LOW_LATENCY,volume: soundVolume);

  }
  void playAudio1(String type) async {
    _audioPlayer1 = null;
    if(soundOn == true)
      _audioPlayer1 = await _playercache1.play("sounds/$type.mp3",mode: PlayerMode.LOW_LATENCY,volume: soundVolume);

  }
  void playAudio2(String type) async {
    _audioPlayer2 = null;
    if(soundOn == true)
      _audioPlayer2 = await _playercache2.play("sounds/$type.mp3",mode: PlayerMode.LOW_LATENCY,volume: soundVolume);

  }
  void release() async{
    _audioPlayer = null;
    _audioPlayer1 = null;
    _audioPlayer2 = null;
  }
}