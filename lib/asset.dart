import 'package:flutter/material.dart';

class APIEndpointAssets {
  static final protocol = 'https://';
  static final domain = 'pahala.xyz';
  static final baseURL = APIEndpointAssets.protocol + APIEndpointAssets.domain;
  static final userService = APIEndpointAssets.baseURL + '/user';
  static final userSignUpService = APIEndpointAssets.userService + '/signup';
  static final userDataService = APIEndpointAssets.userService + '/data';
  static final userHeightService = APIEndpointAssets.userService + '/height';
  static final userAlarmService = APIEndpointAssets.userService + '/alarm';
  static final userNextAlarmService = APIEndpointAssets.userService + '/nextalarm';
  static final userNodeService = APIEndpointAssets.userService + '/node';
  static final userNodeGetLampService = APIEndpointAssets.userNodeService + '/getlamp';
  static final userNodeSetLampService = APIEndpointAssets.userNodeService + '/setlamp';
  static final nodeSleepService = APIEndpointAssets.userService + '/sleep';
  static final userAvailStatsService = APIEndpointAssets.userService + '/availstats';
  static final userStatisticsService = APIEndpointAssets.userService + '/stats';
  static final weatherService = APIEndpointAssets.baseURL + '/weather';
  static final quoteService = APIEndpointAssets.baseURL + '/quote';
  static final newsService = APIEndpointAssets.baseURL + '/news';
  static final menuService = APIEndpointAssets.baseURL + '/menu';
}

class BrandImageAssets {
  static final logo = 'assets/images/logo.png';
  static final iconBg = 'assets/images/icon.png';
  static final iconFg = 'assets/images/icon-fg.png';
}

class BaseColorAssets {
  static final Color primary20 = Color(0xFFFBFEFD);
  static final Color primary40 = Color(0xFFE1F2ED);
  static final Color primary60 = Color(0xFFB8DCD2);
  static final Color primary80 = Color(0xFF87BDAE);
  static final Color primary100 = Color(0xFF579B88);
  static final MaterialColor materialPrimary = MaterialColor(primary60.value, {
    50: Colors.white,
    100: primary20,
    200: primary20,
    300: primary20,
    400: primary40,
    500: primary60,
    600: primary80,
    700: primary100,
    800: primary100,
    900: primary100,
  });
  static final Color accent20 = Color(0xFFFFFBEF);
  static final Color accent40 = Color(0xFFFFF5D7);
  static final Color accent60 = Color(0xFFF7E6B2);
  static final Color accent80 = Color(0xFFD1BB78);
  static final Color accent100 = Color(0xFFAC9347);
  static final MaterialColor materialAccent = MaterialColor(accent60.value, {
    50: Colors.white,
    100: accent20,
    200: accent20,
    300: accent20,
    400: accent40,
    500: accent60,
    600: accent80,
    700: accent100,
    800: accent100,
    900: accent100,
  });
  static final Color secondary20 = Color(0xFFCBF4E8);
  static final Color secondary40 = Color(0xFF96DFCB);
  static final Color secondary60 = Color(0xFF67C5AB);
  static final Color secondary80 = Color(0xFF41A78B);
  static final Color secondary100 = Color(0xFF279275);
  static final MaterialColor materialSecondary = MaterialColor(secondary60.value, {
    50: Colors.white,
    100: secondary20,
    200: secondary20,
    300: secondary20,
    400: secondary40,
    500: secondary60,
    600: secondary80,
    700: secondary100,
    800: secondary100,
    900: secondary100,
  });
  static final Color tertiary20 = Color(0xFFF9FFFD);
  static final Color tertiary40 = Color(0xFFC7F9EB);
  static final Color tertiary60 = Color(0xFF96EBD3);
  static final Color tertiary80 = Color(0xFF6AD7B9);
  static final Color tertiary100 = Color(0xFF44BA99);
  static final MaterialColor materialTertiary = MaterialColor(tertiary60.value, {
    50: Colors.white,
    100: tertiary20,
    200: tertiary20,
    300: tertiary20,
    400: tertiary40,
    500: tertiary60,
    600: tertiary80,
    700: tertiary100,
    800: tertiary100,
    900: tertiary100,
  });
  static final Color quaternary20 = Color(0xFFFCFDF4);
  static final Color quaternary40 = Color(0xFFF6FADE);
  static final Color quaternary60 = Color(0xFFEEF7C0);
  static final Color quaternary80 = Color(0xFFC9D589);
  static final Color quaternary100 = Color(0xFFA2B155);
  static final MaterialColor materialQuaternary = MaterialColor(quaternary60.value, {
    50: Colors.white,
    100: quaternary20,
    200: quaternary20,
    300: quaternary20,
    400: quaternary40,
    500: quaternary60,
    600: quaternary80,
    700: quaternary100,
    800: quaternary100,
    900: quaternary100,
  });
  static final Color light20 = Color(0xFFF7F7F7);
  static final Color light40 = Color(0xFFEFEFEF);
  static final Color light60 = Color(0xFFE7E7E7);
  static final Color light80 = Color(0xFFDFDFDF);
  static final Color light100 = Color(0xFFD7D7D7);
  static final Color gray20 = Color(0xFFAFAFAF);
  static final Color gray40 = Color(0xFFA7A7A7);
  static final Color gray60 = Color(0xFF9F9F9F);
  static final Color gray80 = Color(0xFF979797);
  static final Color gray100 = Color(0xFF8F8F8F);
  static final Color dark20 = Color(0xFF4F4F4F);
  static final Color dark40 = Color(0xFF474747);
  static final Color dark60 = Color(0xFF3F3F3F);
  static final Color dark80 = Color(0xFF373737);
  static final Color dark100 = Color(0xFF2F2F2F);
}

class WeatherAssets {
//  static final icons = {
//    1: 'assets/images/weather/01.png',
//    2: 'assets/images/weather/02.png',
//    3: 'assets/images/weather/03.png',
//    4: 'assets/images/weather/04.png',
//    5: 'assets/images/weather/05.png',
//    6: 'assets/images/weather/06.png',
//    7: 'assets/images/weather/07.png',
//    8: 'assets/images/weather/08.png',
////    9: 'assets/images/weather/09.png',
////    10: 'assets/images/weather/10.png',
//    11: 'assets/images/weather/11.png',
//    12: 'assets/images/weather/12.png',
//    13: 'assets/images/weather/13.png',
//    14: 'assets/images/weather/14.png',
//    15: 'assets/images/weather/15.png',
//    16: 'assets/images/weather/16.png',
//    17: 'assets/images/weather/17.png',
//    18: 'assets/images/weather/18.png',
//    19: 'assets/images/weather/19.png',
//    20: 'assets/images/weather/20.png',
//    21: 'assets/images/weather/21.png',
//    22: 'assets/images/weather/22.png',
//    23: 'assets/images/weather/23.png',
//    24: 'assets/images/weather/24.png',
//    25: 'assets/images/weather/25.png',
//    26: 'assets/images/weather/26.png',
////    27: 'assets/images/weather/27.png',
////    28: 'assets/images/weather/28.png',
//    29: 'assets/images/weather/29.png',
//    30: 'assets/images/weather/30.png',
//    31: 'assets/images/weather/31.png',
//    32: 'assets/images/weather/32.png',
//    33: 'assets/images/weather/33.png',
//    34: 'assets/images/weather/34.png',
//    35: 'assets/images/weather/35.png',
//    36: 'assets/images/weather/36.png',
//    37: 'assets/images/weather/37.png',
//    38: 'assets/images/weather/38.png',
//    39: 'assets/images/weather/39.png',
//    40: 'assets/images/weather/40.png',
//    41: 'assets/images/weather/41.png',
//    42: 'assets/images/weather/42.png',
//    43: 'assets/images/weather/43.png',
//    44: 'assets/images/weather/44.png',
//  };
  static final image = {
    '200d': 'assets/images/weather/17.png',
    '200n': 'assets/images/weather/41.png',
    '201d': 'assets/images/weather/17.png',
    '201n': 'assets/images/weather/41.png',
    '202d': 'assets/images/weather/17.png',
    '202n': 'assets/images/weather/41.png',
    '210d': 'assets/images/weather/16.png',
    '210n': 'assets/images/weather/40.png',
    '211d': 'assets/images/weather/15.png',
    '211n': 'assets/images/weather/15.png',
    '212d': 'assets/images/weather/15.png',
    '212n': 'assets/images/weather/15.png',
    '221d': 'assets/images/weather/15.png',
    '221n': 'assets/images/weather/15.png',
    '230d': 'assets/images/weather/16.png',
    '230n': 'assets/images/weather/40.png',
    '231d': 'assets/images/weather/16.png',
    '231n': 'assets/images/weather/40.png',
    '232d': 'assets/images/weather/16.png',
    '232n': 'assets/images/weather/40.png',
    '300d': 'assets/images/weather/13.png',
    '300n': 'assets/images/weather/39.png',
    '301d': 'assets/images/weather/13.png',
    '301n': 'assets/images/weather/39.png',
    '302d': 'assets/images/weather/13.png',
    '302n': 'assets/images/weather/39.png',
    '310d': 'assets/images/weather/13.png',
    '310n': 'assets/images/weather/39.png',
    '311d': 'assets/images/weather/13.png',
    '311n': 'assets/images/weather/39.png',
    '312d': 'assets/images/weather/13.png',
    '312n': 'assets/images/weather/39.png',
    '313d': 'assets/images/weather/13.png',
    '313n': 'assets/images/weather/39.png',
    '314d': 'assets/images/weather/13.png',
    '314n': 'assets/images/weather/39.png',
    '321d': 'assets/images/weather/13.png',
    '321n': 'assets/images/weather/39.png',
    '500d': 'assets/images/weather/14.png',
    '500n': 'assets/images/weather/40.png',
    '501d': 'assets/images/weather/14.png',
    '501n': 'assets/images/weather/40.png',
    '502d': 'assets/images/weather/14.png',
    '502n': 'assets/images/weather/40.png',
    '503d': 'assets/images/weather/14.png',
    '503n': 'assets/images/weather/40.png',
    '504d': 'assets/images/weather/14.png',
    '504n': 'assets/images/weather/40.png',
    '511d': 'assets/images/weather/12.png',
    '511n': 'assets/images/weather/12.png',
    '520d': 'assets/images/weather/12.png',
    '520n': 'assets/images/weather/12.png',
    '521d': 'assets/images/weather/12.png',
    '521n': 'assets/images/weather/12.png',
    '522d': 'assets/images/weather/12.png',
    '522n': 'assets/images/weather/12.png',
    '531d': 'assets/images/weather/12.png',
    '531n': 'assets/images/weather/12.png',
    '600d': 'assets/images/weather/19.png',
    '600n': 'assets/images/weather/19.png',
    '601d': 'assets/images/weather/22.png',
    '601n': 'assets/images/weather/22.png',
    '602d': 'assets/images/weather/24.png',
    '602n': 'assets/images/weather/24.png',
    '611d': 'assets/images/weather/25.png',
    '611n': 'assets/images/weather/25.png',
    '612d': 'assets/images/weather/25.png',
    '612n': 'assets/images/weather/25.png',
    '615d': 'assets/images/weather/25.png',
    '615n': 'assets/images/weather/25.png',
    '616d': 'assets/images/weather/26.png',
    '616n': 'assets/images/weather/26.png',
    '620d': 'assets/images/weather/25.png',
    '620n': 'assets/images/weather/25.png',
    '621d': 'assets/images/weather/26.png',
    '621n': 'assets/images/weather/26.png',
    '622d': 'assets/images/weather/29.png',
    '622n': 'assets/images/weather/29.png',
    '701d': 'assets/images/weather/07.png',
    '701n': 'assets/images/weather/08.png',
    '711d': 'assets/images/weather/07.png',
    '711n': 'assets/images/weather/08.png',
    '721d': 'assets/images/weather/07.png',
    '721n': 'assets/images/weather/08.png',
    '731d': 'assets/images/weather/07.png',
    '731n': 'assets/images/weather/08.png',
    '741d': 'assets/images/weather/07.png',
    '741n': 'assets/images/weather/08.png',
    '751d': 'assets/images/weather/07.png',
    '751n': 'assets/images/weather/08.png',
    '761d': 'assets/images/weather/07.png',
    '761n': 'assets/images/weather/08.png',
    '762d': 'assets/images/weather/07.png',
    '762n': 'assets/images/weather/08.png',
    '771d': 'assets/images/weather/07.png',
    '771n': 'assets/images/weather/08.png',
    '781d': 'assets/images/weather/07.png',
    '781n': 'assets/images/weather/08.png',
    '800d': 'assets/images/weather/01.png',
    '800n': 'assets/images/weather/33.png',
    '801d': 'assets/images/weather/02.png',
    '801n': 'assets/images/weather/34.png',
    '802d': 'assets/images/weather/03.png',
    '802n': 'assets/images/weather/35.png',
    '803d': 'assets/images/weather/06.png',
    '803n': 'assets/images/weather/38.png',
    '804d': 'assets/images/weather/07.png',
    '804n': 'assets/images/weather/08.png',
  };
  static final sky = {
    '7': [
      'assets/images/sky/misty_a1.png',
      'assets/images/sky/misty_a2.png',
    ],
    '8': [
      'assets/images/sky/bright_a1.png',
      'assets/images/sky/bright_a2.png',
      'assets/images/sky/bright_a3.png',
      'assets/images/sky/bright_a4.png',
      'assets/images/sky/bright_a5.png',
      'assets/images/sky/bright_a6.png',
      'assets/images/sky/bright_a7.png',
      'assets/images/sky/bright_a8.png',
      'assets/images/sky/bright_b1.png',
      'assets/images/sky/bright_b2.png',
    ],
  };
}

class SkyAssets {
  static final daySky = [
    'assets/images/sky/bright_a1.jpg',
  ];
  static final nightSky = [
    'assets/images/sky/night_b2.jpg',
  ];
}

class VendorAsset {
  static final googleFav = 'assets/images/vendor/google-fav.png';
}
