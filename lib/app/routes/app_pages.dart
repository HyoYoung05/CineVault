import 'package:get/get.dart';
import 'app_routes.dart';

// --- Modules ---
import '../../modules/splash/views/splash_view.dart';
import '../../modules/home/views/home_view.dart';
import '../../modules/home/bindings/home_binding.dart';
import '../../modules/search/views/search_view.dart';
import '../../modules/search/bindings/search_binding.dart';
import '../../modules/watchlist/views/watchlist_view.dart';
import '../../modules/watchlist/bindings/watchlist_binding.dart';
import '../../modules/lock/views/lock_view.dart';
import '../../modules/lock/bindings/lock_binding.dart';
import '../../modules/settings/views/settings_view.dart';
import '../../modules/settings/bindings/settings_binding.dart';
import '../../modules/details/views/details_view.dart';
import '../../modules/details/bindings/details_binding.dart';


class AppPages {
  // Define the very first screen the app should load
  static const INITIAL = Routes.SPLASH;

  // Map out all the pages
  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.LOCK,
      page: () => const LockView(),
      binding: LockBinding(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    // Notice how GetPage handles the bindings automatically!
    GetPage(
      name: Routes.SEARCH,
      page: () => SearchView(),
      binding: SearchBinding(), 
    ),
    GetPage(
      name: Routes.WATCHLIST,
      page: () => const WatchlistView(),
      binding: WatchlistBinding(),
    ),
    GetPage(
      name: Routes.DETAILS,
      page: () => const DetailsView(),
      binding: DetailsBinding(),
    ),
  ];
}
