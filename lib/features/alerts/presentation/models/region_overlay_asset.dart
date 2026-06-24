/*
  extension дозволяє нам додати нові методи до вже наявного типу, не змінюючи
 сам клас (у нашому випадку складний enum). Це розширення функцілнальності 
 нявного enum, не розширюючи і не редагуючи його (не додаючи поле).

  Оверлей - це зображення (PNG), отже його місце в шарі "presentation".
*/

import 'package:ukraine_alerts/features/alerts/data/entities/region.dart';

extension RegionOverlayAsset on Region {
  String get overlayAssetPath => 
  'assets/images/map/overlays/$name.png';
}
