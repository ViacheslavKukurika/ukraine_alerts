
/*-----------------------------------------------------------------------------
  Це extension (додавання корисної властивості) для Region, який формує шлях до
PNG-overlay відповідного регіону на карті України.

 Наприклад, Region.cherkasy перетворюється на шлях:
    assets/images/map/overlays/cherkasy.png.

  Шлях до зображення є деталлю інтерфейсу, тому ця логіка знаходиться у 
presentation-шарі, а не всередині data-моделі Region. 
-----------------------------------------------------------------------------*/

import 'package:ukraine_alerts/features/alerts/data/entities/region.dart';

extension RegionOverlayAsset on Region {
  // name — це значення в enum "Region"
  String get overlayAssetPath => 'assets/images/map/overlays/$name.png';
}
