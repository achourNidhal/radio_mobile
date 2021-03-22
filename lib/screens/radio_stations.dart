import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radio_mobile/models/station.dart';
import 'package:radio_mobile/services/radio_config.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

List<TextButton> radioButtons;
final _player = AudioPlayer(); // e.g. just_audio

class RadioStationsScreen extends StatefulWidget {
  @override
  _RadioStationsScreenState createState() => _RadioStationsScreenState();
}

class _RadioStationsScreenState extends State<RadioStationsScreen> {
  @override
  void initState() {
    super.initState();
    this.initRadioButtons();
  }

  initRadioButtons() {
    radioButtons = [];
    RadioConfig radioConfig = RadioConfig();
    for (Station radio in radioConfig.getStations()) {
      radioButtons.add(TextButton(
        onPressed: () {
          print(radio.id.toString() + ' pressed ');
          //play(radio.urls[0]);
          onStart(null);
        },
        child: Text(radio.label),
      ));
    }
  }

  onStart(Map<String, dynamic> params) async {
    final mediaItem = MediaItem(
      id: "https://streaming2.toutech.net/jawharafm",
      album: "Foo",
      title: "Bar",
    );
    // Tell the UI and media notification what we're playing.
    AudioServiceBackground.setMediaItem(mediaItem);
    // Listen to state changes on the player...
    _player.playerStateStream.listen((playerState) {
      // ... and forward them to all audio_service clients.
      AudioServiceBackground.setState(
        playing: playerState.playing,
        // Every state from the audio player gets mapped onto an audio_service state.
        processingState: {
          ProcessingState.idle: AudioProcessingState.none,
          ProcessingState.loading: AudioProcessingState.connecting,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[playerState.processingState],
        // Tell clients what buttons/controls should be enabled in the
        // current state.
        controls: [
          playerState.playing ? MediaControl.pause : MediaControl.play,
          MediaControl.stop,
        ],
      );
    });
    // Play when ready.
    _player.play();
    // Start loading something (will play when ready).
    await _player.setUrl(mediaItem.id);
  }
  // play(String url) async {
  //   AudioPlayer audioPlayer = AudioPlayer();

  //   int result = await audioPlayer.play(url);
  //   if (result == 1) {
  //     // success
  //     print('success');
  //     audioPlayer.onPlayerError.listen((msg) {
  //       print('audioPlayer error : $msg');
  //       setState(() {
  //         print('errrrrrrrrrrrror');
  //       });
  //     });

  //     audioPlayer.onPlayerCompletion.listen((event) {
  //       setState(() {
  //         print('compleeeeete');
  //       });
  //     });
  //   }
  // }

  // Must be a top-level function
  void _entrypoint() => AudioServiceBackground.run(() => AudioPlayerTask());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        children: radioButtons,
      ),
    );
  }
}

class AudioPlayerTask extends BackgroundAudioTask {
  final _player = AudioPlayer(); // e.g. just_audio

  // Implement callbacks here. e.g. onStart, onStop, onPlay, onPause
}
