import 'dart:async';

import 'package:just_audio/just_audio.dart';

class AudioPlayerStream{

  StreamSubscription<Duration> progressPosition(AudioPlayer audioPlayer){
    //Stream.multi(audioPlayer.positionStream.listen((event) {return event;}));
    return audioPlayer.positionStream.listen((position) => position);
  }

  Stream<int> tick() {
    return Stream.periodic(const Duration(seconds: 1), (x) => x).take(10);
  }
}