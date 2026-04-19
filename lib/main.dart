import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';

import 'data/models/movie_model.dart'; 
import 'app/constants/app_constants.dart';
import 'app/theme/app_theme.dart';
import 'app/routes/app_pages.dart';

void main() async {
  // 1. Ensure Flutter is ready before doing background work
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Hive Database
  await Hive.initFlutter();
  
  // Register the adapter generated for local storage
  Hive.registerAdapter(MovieItemAdapter());

  // 3. Open Boxes as defined in the Planning Document
  await Hive.openBox<MovieItem>('watchlist'); 
  await Hive.openBox('settingsBox');

  // 4. Run the App
  runApp(const CineVaultApp());
}

class CineVaultApp extends StatelessWidget {
  const CineVaultApp({super.key});

  ThemeMode _themeModeFromSetting(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
      case 'oled':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsBox = Hive.box(AppConstants.settingsBox);

    return ValueListenableBuilder(
      valueListenable: settingsBox.listenable(),
      builder: (context, box, _) {
        final appearance = box.get(
          AppConstants.themeAppearanceKey,
          defaultValue: 'dark',
        ) as String;

        return GetMaterialApp(
          title: 'CineVault',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: appearance == 'oled' ? AppTheme.oledTheme : AppTheme.darkTheme,
          themeMode: _themeModeFromSetting(appearance),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
