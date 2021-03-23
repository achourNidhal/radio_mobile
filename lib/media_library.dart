import 'package:audio_service/audio_service.dart';
import 'package:radio_mobile/models/radio_station.dart';
import 'config/radio_config.dart';

class MediaLibrary {
  List<MediaItem> get items {
    final _items = <MediaItem>[];

    RadioConfig radioConfig = RadioConfig();
    for (RadioStation rs in radioConfig.getRadioStations()) {
      _items.add(
        MediaItem(
          id: rs.urls[0],
          album: rs.label,
          title: rs.label,
          artist: '',
          duration: Duration(hours: 9999),
          artUri: '',
        ),
      );
    }
    return _items;
  }
}
