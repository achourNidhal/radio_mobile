import 'package:flutter/material.dart';
import 'package:radio_mobile/components/audio_service_widget.dart';
import 'package:radio_mobile/screens/radio_stations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AudioServiceWidget(
        child: RadioStationsScreen(),
      ),
    );
  }
}
