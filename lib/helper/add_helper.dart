import 'dart:io';

// Prod ad units
class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4997882241408011/3541942307';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-4997882241408011/5957304343';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-4997882241408011/7425346999";
    } else if (Platform.isIOS) {
      return "ca-app-pub-4997882241408011/7662441714";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}

// Testing ad units
// class AdHelper {
//   static String get bannerAdUnitId {
//     if (Platform.isAndroid) {
//       return 'ca-app-pub-3940256099942544/6300978111';
//     } else if (Platform.isIOS) {
//       return 'ca-app-pub-3940256099942544/6300978111';
//     } else {
//       throw new UnsupportedError('Unsupported platform');
//     }
//   }

//   static String get interstitialAdUnitId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-3940256099942544/1033173712";
//     } else if (Platform.isIOS) {
//       return "ca-app-pub-3940256099942544/1033173712";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }

//   static String get rewardedAdUnitId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-3940256099942544/6300978111";
//     } else if (Platform.isIOS) {
//       return "ca-app-pub-3940256099942544/1712485313";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }
// }
