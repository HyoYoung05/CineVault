import 'package:hive_flutter/hive_flutter.dart';
import '../../app/constants/app_constants.dart';
import '../models/movie_model.dart';

class HiveProvider {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MovieItemAdapter());
    await Hive.openBox<MovieItem>(AppConstants.watchlistBox);
    await Hive.openBox(AppConstants.settingsBox);
  }

  static Box<MovieItem> getWatchlistBox() {
    return Hive.box<MovieItem>(AppConstants.watchlistBox);
  }
}
