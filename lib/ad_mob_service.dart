import 'dart:io';

class AdMobService {
  static String getBannerAdUnitId(String page) {
    if (Platform.isAndroid) {
      switch (page) {
        case 'main':
          return 'ca-app-pub-8539970308562149/6803176217';
        case 'settings_page':
          return 'ca-app-pub-8539970308562149/3181046858';
        case 'view_contact_page':
          return 'ca-app-pub-8539970308562149/7381760719';

        default:
          return 'ca-app-pub-8539970308562149/6803176217';
      }
    } else if (Platform.isIOS) {
      // Podobne mapowanie dla platformy iOS, jeśli różne
      return ' '; // domyślne ID dla iOS
    } else {
      return '';
    }
  }
}