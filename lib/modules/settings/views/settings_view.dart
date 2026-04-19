import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../controllers/settings_controller.dart';
import '../../../widgets/responsive_app_bar_title.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _preferenceTile<T>({
    required IconData icon,
    required String title,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Icon(icon),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<T>(
                      isExpanded: true,
                      value: value,
                      onChanged: onChanged,
                      items: items,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ResponsiveAppBarTitle('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Get.offAllNamed(Routes.DASHBOARD);
            }
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Library'),
                ListTile(
                  leading: const Icon(Icons.bookmark),
                  title: const Text('My Private Vault'),
                  subtitle: const Text('View your saved movies and watch status.'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: controller.openPrivateVault,
                ),
                ListTile(
                  leading: const Icon(Icons.archive_outlined),
                  title: const Text('Archived'),
                  subtitle: const Text('View movies and series archived from your vault.'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: controller.openArchive,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('App Preferences'),
                Obx(
                  () => _preferenceTile<VaultSortPreference>(
                    icon: Icons.sort_outlined,
                    title: 'Sort Vault By',
                    value: controller.vaultSort.value,
                    onChanged: (value) {
                      if (value != null) controller.setVaultSort(value);
                    },
                    items: VaultSortPreference.values
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(controller.vaultSortLabel(value)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Obx(
                  () => _preferenceTile<DefaultHomeSectionPreference>(
                    icon: Icons.home_outlined,
                    title: 'Default Home Section',
                    value: controller.defaultHomeSection.value,
                    onChanged: (value) {
                      if (value != null) controller.setDefaultHomeSection(value);
                    },
                    items: DefaultHomeSectionPreference.values
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(controller.defaultHomeSectionLabel(value)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Obx(
                  () => _preferenceTile<PreferredContentTypePreference>(
                    icon: Icons.live_tv_outlined,
                    title: 'Preferred Content Type',
                    value: controller.preferredContentType.value,
                    onChanged: (value) {
                      if (value != null) controller.setPreferredContentType(value);
                    },
                    items: PreferredContentTypePreference.values
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(controller.preferredContentTypeLabel(value)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Obx(
                  () => _preferenceTile<ThemeAppearancePreference>(
                    icon: Icons.palette_outlined,
                    title: 'Theme Appearance',
                    value: controller.themeAppearance.value,
                    onChanged: (value) {
                      if (value != null) controller.setThemeAppearance(value);
                    },
                    items: ThemeAppearancePreference.values
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(controller.themeAppearanceLabel(value)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Obx(
                  () => _preferenceTile<DefaultStartupScreenPreference>(
                    icon: Icons.rocket_launch_outlined,
                    title: 'Default Startup Screen',
                    value: controller.defaultStartupScreen.value,
                    onChanged: (value) {
                      if (value != null) controller.setDefaultStartupScreen(value);
                    },
                    items: DefaultStartupScreenPreference.values
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(controller.defaultStartupScreenLabel(value)),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Security'),
                Obx(
                  () => SwitchListTile(
                    title: const Text('Enable Biometric Lock'),
                          subtitle: const Text(
                      'Require fingerprint or face ID to access your private vault.',
                    ),
                    value: controller.isBiometricEnabled.value,
                    onChanged: controller.toggleBiometric,
                    secondary: Icon(
                      Icons.fingerprint,
                      color: controller.isBiometricEnabled.value
                          ? Colors.deepPurpleAccent
                          : Colors.grey,
                    ),
                    activeThumbColor: Colors.deepPurpleAccent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.red.withOpacity(0.08),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Danger Zone'),
                ListTile(
                  leading: const Icon(Icons.delete_forever_outlined, color: Colors.redAccent),
                  title: const Text('Wipe All Data'),
                  subtitle: const Text('Delete watchlist, archive, and app settings permanently.'),
                  onTap: controller.wipeAllData,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Version 2.2',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
