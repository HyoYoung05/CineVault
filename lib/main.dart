import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';

import 'data/models/movie_model.dart'; 
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

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CineVault',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, 
      
      // Upgrade to Named Routing!
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
