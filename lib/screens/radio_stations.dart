import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:radio_mobile/models/station.dart';
import 'package:radio_mobile/services/radio_config.dart';
import 'package:audioplayers/audioplayers.dart';

List<TextButton> radioButtons;

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
          play(radio.urls[0]);
        },
        child: Text(radio.label),
      ));
    }
  }

  play(String url) async {
    AudioPlayer audioPlayer = AudioPlayer();

    int result = await audioPlayer.play(url);
    if (result == 1) {
      // success
      print('success');
      audioPlayer.onPlayerError.listen((msg) {
        print('audioPlayer error : $msg');
        setState(() {
          print('errrrrrrrrrrrror');
        });
      });

      audioPlayer.onPlayerCompletion.listen((event) {
        setState(() {
          print('compleeeeete');
        });
      });
    }
  }

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
