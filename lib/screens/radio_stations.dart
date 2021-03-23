import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radio_mobile/audio_player_task.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:radio_mobile/models/radio_station.dart';
import 'package:radio_mobile/config/radio_config.dart';

List<Card> radioButtons = [];

class RadioStationsScreen extends StatefulWidget {
  @override
  _RadioStationsScreenState createState() => _RadioStationsScreenState();
}

class _RadioStationsScreenState extends State<RadioStationsScreen> {
  @override
  void initState() {
    super.initState();
    initRadioButtons();
  }

  @override
  Widget build(BuildContext context) {
    print(radioButtons);
    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 150,
                padding: EdgeInsets.all(20),
                child: Text(
                  'publicity',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          GridView.count(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            crossAxisCount: 4,
            children: radioButtons,
          ),
          // Play/pause/stop buttons.
          StreamBuilder<bool>(
            stream: AudioService.playbackStateStream
                .map((state) => state.playing)
                .distinct(),
            builder: (context, snapshot) {
              final playing = snapshot.data ?? false;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  playPreviousButton(),
                  if (playing) pauseButton() else playButton(),
                  playNextButton(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

TextButton audioPlayerButton() => startButton(
      'AudioPlayer',
      () {
        AudioService.start(
          backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
          androidNotificationChannelName: 'Audio Service Demo',
          // Enable this if you want the Android service to exit the foreground state on pause.
          //androidStopForegroundOnPause: true,
          androidNotificationColor: 0xFF2196f3,
          androidNotificationIcon: 'mipmap/ic_launcher',
          androidEnableQueue: true,
        );
      },
    );

TextButton startButton(String label, VoidCallback onPressed) => TextButton(
      child: Text(label),
      onPressed: onPressed,
    );

TextButton playButton() => TextButton(
      child: Icon(
        Icons.play_arrow,
        size: 40,
      ),
      onPressed: AudioService.play,
    );

TextButton pauseButton() => TextButton(
      child: Icon(
        Icons.pause,
        size: 40,
      ),
      onPressed: AudioService.pause,
    );
TextButton playNextButton() => TextButton(
      child: Icon(
        Icons.arrow_forward,
        size: 40,
      ),
      onPressed: () {},
    );
TextButton playPreviousButton() => TextButton(
      child: Icon(
        Icons.arrow_back,
        size: 40,
      ),
      onPressed: () {},
    );

class QueueState {
  final List<MediaItem> queue;
  final MediaItem mediaItem;

  QueueState(this.queue, this.mediaItem);
}

// NOTE: Your entrypoint MUST be a top-level function.
void _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

initRadioButtons() {
  radioButtons = [];
  RadioConfig radioConfig = RadioConfig();
  List<RadioStation> radioStations = radioConfig.getRadioStations();
  for (var rs in radioStations) {
    radioButtons.add(Card(
      margin: EdgeInsets.all(10),
      color: rs.selected ? Colors.lightBlueAccent : Colors.white,
      elevation: 8,
      child: StreamBuilder<bool>(
          stream: AudioService.runningStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.active) {
              print('not connected');
              return InkWell(
                splashColor: Colors.amber,
                onTap: () async {
                  rs.selected = true;
                  print('click ${rs.label}');
                  // onStart({'label': rs.label, 'links': rs.urls});
                  // await AudioService.start(
                  //     params: {'label': rs.label, 'links': rs.urls},
                  //     backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint);
                },
                child: Center(
                  child: Text(rs.label),
                ),
              );
            } else {
              return InkWell(
                splashColor: Colors.amber,
                onTap: () async {
                  print(' connected');

                  rs.selected = true;
                  print('click ${rs.label}');
                  // onStart({'label': rs.label, 'links': rs.urls});
                  await AudioService.start(
                      params: {'label': rs.label, 'links': rs.urls},
                      backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint);
                },
                child: Center(
                  child: Text(rs.label),
                ),
              );
            }
          }),
    ));
  }
}

//   @override
//   Widget build(BuildContext context) {
//     int columnCount = 3;


// class AudioPlayerTask extends BackgroundAudioTask {
//   final _player = AudioPlayer(); // e.g. just_audio

//   // Implement callbacks here. e.g. onStart, onStop, onPlay, onPause
//   onStart(Map<String, dynamic> params) async {
//     final mediaItem = MediaItem(
//       id: params['links'] != null ? params['links'][0] : null,
//       album: "live",
//       title: params['label'],
//     );
//     // Tell the UI and media notification what we're playing.
//     AudioServiceBackground.setMediaItem(mediaItem);
//     // Listen to state changes on the player...
//     _player.playerStateStream.listen((playerState) {
//       // ... and forward them to all audio_service clients.
//       AudioServiceBackground.setState(
//         playing: playerState.playing,
//         // Every state from the audio player gets mapped onto an audio_service state.
//         processingState: {
//           ProcessingState.idle: AudioProcessingState.none,
//           ProcessingState.loading: AudioProcessingState.connecting,
//           ProcessingState.buffering: AudioProcessingState.buffering,
//           ProcessingState.ready: AudioProcessingState.ready,
//           ProcessingState.completed: AudioProcessingState.completed,
//         }[playerState.processingState],
//         // Tell clients what buttons/controls should be enabled in the
//         // current state.
//         controls: [
//           playerState.playing ? MediaControl.pause : MediaControl.play,
//           MediaControl.stop,
//         ],
//       );
//     });
//     // Play when ready.
//     _player.play();
//     // Start loading something (will play when ready).
//     await _player.setUrl(mediaItem.id);
//   }

//   onPlay() => _player.play();
//   onPause() => _player.pause();
//   onSeekTo(Duration duration) => _player.seek(duration);
//   onSetSpeed(double speed) => _player.setSpeed(speed);
// }
