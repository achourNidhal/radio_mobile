import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';

class AudioServiceWidget extends StatefulWidget {
  final Widget child;

  AudioServiceWidget({@required this.child});

  @override
  _AudioServiceWidgetState createState() => _AudioServiceWidgetState();
}

class _AudioServiceWidgetState extends State<AudioServiceWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AudioService.connect();
  }

  @override
  void dispose() {
    AudioService.disconnect();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        AudioService.connect();
        break;
      case AppLifecycleState.paused:
        AudioService.disconnect();
        break;
      default:
        break;
    }
  }

  @override
  Future<bool> didPopRoute() async {
    AudioService.disconnect();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
