import 'package:radio_mobile/enums/radio-enum.dart';
import 'package:radio_mobile/models/radio_station.dart';

class RadioConfig {
  List<RadioStation> getRadioStations() {
    return [
      new RadioStation(
          id: RadioEnum.JAWHARA_FM,
          label: 'Jawhara FM',
          urls: [
            'https://streaming2.toutech.net/jawharafm',
            'https://streaming2.toutech.net/jawharafm?1616284652804',
          ],
          icon: 'jawhara-fm.jpg'),
      new RadioStation(
          id: RadioEnum.MOSAIQUE_FM,
          label: 'Mosaique FM',
          urls: [
            'https://radio.mosaiquefm.net/mosalive',
            'https://radio.mosaiquefm.net/mosalive?1616284603226',
          ],
          icon: 'mosaique-fm.jpg'),
      new RadioStation(
          id: RadioEnum.SHEMS_FM,
          label: 'Shems FM',
          urls: [
            'https://stream6.tanitweb.com/shems',
            'https://stream6.tanitweb.com/shems?1616284534363',
          ],
          icon: 'shems-fm.jpg'),
    ];
  }
}
