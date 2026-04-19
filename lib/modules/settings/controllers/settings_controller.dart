import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../app/constants/app_constants.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/utils/app_snackbar.dart';
import '../../../data/models/movie_model.dart';

enum VaultSortPreference { recentlyAdded, titleAZ, releaseDate, watchedFirst, unwatchedFirst }
enum DefaultHomeSectionPreference { browse, trending, popular, updated, genre }
enum PreferredContentTypePreference { all, movies, series }
enum ThemeAppearancePreference { system, dark, light, oled }
enum DefaultStartupScreenPreference { home, vault }

class SettingsController extends GetxController {
  var isBiometricEnabled = false.obs;
  var vaultSort = VaultSortPreference.recentlyAdded.obs;
  var defaultHomeSection = DefaultHomeSectionPreference.trending.obs;
  var preferredContentType = PreferredContentTypePreference.all.obs;
  var themeAppearance = ThemeAppearancePreference.dark.obs;
  var defaultStartupScreen = DefaultStartupScreenPreference.home.obs;
  late Box settingsBox;

  @override
  void onInit() {
    super.onInit();
    settingsBox = Hive.box(AppConstants.settingsBox);

    isBiometricEnabled.value = settingsBox.get(
      AppConstants.biometricEnabledKey,
      defaultValue: false,
    );
    vaultSort.value = _vaultSortFromValue(
      settingsBox.get(AppConstants.vaultSortKey, defaultValue: 'recentlyAdded') as String,
    );
    defaultHomeSection.value = _defaultHomeFromValue(
      settingsBox.get(AppConstants.defaultHomeSectionKey, defaultValue: 'trending') as String,
    );
    preferredContentType.value = _contentTypeFromValue(
      settingsBox.get(AppConstants.preferredContentTypeKey, defaultValue: 'all') as String,
    );
    themeAppearance.value = _themeFromValue(
      settingsBox.get(AppConstants.themeAppearanceKey, defaultValue: 'dark') as String,
    );
    defaultStartupScreen.value = _startupFromValue(
      settingsBox.get(AppConstants.defaultStartupScreenKey, defaultValue: 'home') as String,
    );
  }

  void toggleBiometric(bool value) {
    isBiometricEnabled.value = value;
    settingsBox.put(AppConstants.biometricEnabledKey, value);

    if (value) {
      AppSnackbar.show('Vault Secured', 'Biometric lock is now enabled.');
    } else {
      AppSnackbar.show('Vault Unlocked', 'Biometric lock has been disabled.');
    }
  }

  void setVaultSort(VaultSortPreference value) {
    vaultSort.value = value;
    settingsBox.put(AppConstants.vaultSortKey, value.name);
    AppSnackbar.show('Vault Sorting Updated', 'Vault items will now use ${vaultSortLabel(value)}.');
  }

  void setDefaultHomeSection(DefaultHomeSectionPreference value) {
    defaultHomeSection.value = value;
    settingsBox.put(AppConstants.defaultHomeSectionKey, value.name);
    AppSnackbar.show('Default Home Updated', 'Home will open to ${defaultHomeSectionLabel(value)}.');
  }

  void setPreferredContentType(PreferredContentTypePreference value) {
    preferredContentType.value = value;
    settingsBox.put(AppConstants.preferredContentTypeKey, value.name);
    AppSnackbar.show('Preferred Content Updated', 'Default content type set to ${preferredContentTypeLabel(value)}.');
  }

  void setThemeAppearance(ThemeAppearancePreference value) {
    themeAppearance.value = value;
    settingsBox.put(AppConstants.themeAppearanceKey, value.name);
    AppSnackbar.show('Theme Updated', 'Theme appearance set to ${themeAppearanceLabel(value)}.');
  }

  void setDefaultStartupScreen(DefaultStartupScreenPreference value) {
    defaultStartupScreen.value = value;
    settingsBox.put(AppConstants.defaultStartupScreenKey, value.name);
    AppSnackbar.show('Startup Screen Updated', 'App will launch to ${defaultStartupScreenLabel(value)}.');
  }

  void openPrivateVault() {
    if (isBiometricEnabled.value && !kIsWeb) {
      Get.toNamed(Routes.LOCK, arguments: {
        'route': Routes.WATCHLIST,
        'arguments': {'mode': 'vault'},
      });
    } else {
      Get.toNamed(Routes.WATCHLIST, arguments: {'mode': 'vault'});
    }
  }

  void openArchive() {
    if (isBiometricEnabled.value && !kIsWeb) {
      Get.toNamed(Routes.LOCK, arguments: {
        'route': Routes.WATCHLIST,
        'arguments': {'mode': 'archive'},
      });
    } else {
      Get.toNamed(Routes.WATCHLIST, arguments: {'mode': 'archive'});
    }
  }

  Future<void> wipeAllData() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Wipe All Data?'),
        content: const Text(
          'This will permanently delete your vault, archive, and all app preferences.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Wipe All'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await Hive.box<MovieItem>(AppConstants.watchlistBox).clear();
    await settingsBox.clear();

    isBiometricEnabled.value = false;
    vaultSort.value = VaultSortPreference.recentlyAdded;
    defaultHomeSection.value = DefaultHomeSectionPreference.trending;
    preferredContentType.value = PreferredContentTypePreference.all;
    themeAppearance.value = ThemeAppearancePreference.dark;
    defaultStartupScreen.value = DefaultStartupScreenPreference.home;

    AppSnackbar.show('Data Wiped', 'CineVault has been reset.');
    Get.offAllNamed(Routes.SPLASH);
  }

  String vaultSortLabel(VaultSortPreference value) {
    switch (value) {
      case VaultSortPreference.recentlyAdded:
        return 'Recently Added';
      case VaultSortPreference.titleAZ:
        return 'Title A-Z';
      case VaultSortPreference.releaseDate:
        return 'Release Date';
      case VaultSortPreference.watchedFirst:
        return 'Watched First';
      case VaultSortPreference.unwatchedFirst:
        return 'Unwatched First';
    }
  }

  String defaultHomeSectionLabel(DefaultHomeSectionPreference value) {
    switch (value) {
      case DefaultHomeSectionPreference.browse:
        return 'Browse';
      case DefaultHomeSectionPreference.trending:
        return 'Trending';
      case DefaultHomeSectionPreference.popular:
        return 'Popular';
      case DefaultHomeSectionPreference.updated:
        return 'Updated';
      case DefaultHomeSectionPreference.genre:
        return 'Genre';
    }
  }

  String preferredContentTypeLabel(PreferredContentTypePreference value) {
    switch (value) {
      case PreferredContentTypePreference.all:
        return 'All';
      case PreferredContentTypePreference.movies:
        return 'Movies';
      case PreferredContentTypePreference.series:
        return 'Series';
    }
  }

  String themeAppearanceLabel(ThemeAppearancePreference value) {
    switch (value) {
      case ThemeAppearancePreference.system:
        return 'System Default';
      case ThemeAppearancePreference.dark:
        return 'Dark';
      case ThemeAppearancePreference.light:
        return 'Light';
      case ThemeAppearancePreference.oled:
        return 'OLED Pitch Black';
    }
  }

  String defaultStartupScreenLabel(DefaultStartupScreenPreference value) {
    switch (value) {
      case DefaultStartupScreenPreference.home:
        return 'Home/Discovery';
      case DefaultStartupScreenPreference.vault:
        return 'My Private Vault';
    }
  }

  VaultSortPreference _vaultSortFromValue(String value) {
    return VaultSortPreference.values.firstWhere(
      (item) => item.name == value,
      orElse: () => VaultSortPreference.recentlyAdded,
    );
  }

  DefaultHomeSectionPreference _defaultHomeFromValue(String value) {
    return DefaultHomeSectionPreference.values.firstWhere(
      (item) => item.name == value,
      orElse: () => DefaultHomeSectionPreference.trending,
    );
  }

  PreferredContentTypePreference _contentTypeFromValue(String value) {
    return PreferredContentTypePreference.values.firstWhere(
      (item) => item.name == value,
      orElse: () => PreferredContentTypePreference.all,
    );
  }

  ThemeAppearancePreference _themeFromValue(String value) {
    return ThemeAppearancePreference.values.firstWhere(
      (item) => item.name == value,
      orElse: () => ThemeAppearancePreference.dark,
    );
  }

  DefaultStartupScreenPreference _startupFromValue(String value) {
    return DefaultStartupScreenPreference.values.firstWhere(
      (item) => item.name == value,
      orElse: () => DefaultStartupScreenPreference.home,
    );
  }
}
