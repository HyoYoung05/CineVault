import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ResponsiveAppBarTitle('Settings'),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('App Preferences'),
                Obx(
                  () => ListTile(
                    leading: const Icon(Icons.sort_outlined),
                    title: const Text('Sort Vault By'),
                    subtitle: Text(controller.vaultSortLabel(controller.vaultSort.value)),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<VaultSortPreference>(
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
                  ),
                ),
                Obx(
                  () => ListTile(
                    leading: const Icon(Icons.home_outlined),
                    title: const Text('Default Home Section'),
                    subtitle: Text(
                      controller.defaultHomeSectionLabel(controller.defaultHomeSection.value),
                    ),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<DefaultHomeSectionPreference>(
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
                  ),
                ),
                Obx(
                  () => ListTile(
                    leading: const Icon(Icons.live_tv_outlined),
                    title: const Text('Preferred Content Type'),
                    subtitle: Text(
                      controller.preferredContentTypeLabel(controller.preferredContentType.value),
                    ),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<PreferredContentTypePreference>(
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
                  ),
                ),
                Obx(
                  () => ListTile(
                    leading: const Icon(Icons.palette_outlined),
                    title: const Text('Theme Appearance'),
                    subtitle: Text(
                      controller.themeAppearanceLabel(controller.themeAppearance.value),
                    ),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<ThemeAppearancePreference>(
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
                  ),
                ),
                Obx(
                  () => ListTile(
                    leading: const Icon(Icons.rocket_launch_outlined),
                    title: const Text('Default Startup Screen'),
                    subtitle: Text(
                      controller.defaultStartupScreenLabel(controller.defaultStartupScreen.value),
                    ),
                    trailing: DropdownButtonHideUnderline(
                      child: DropdownButton<DefaultStartupScreenPreference>(
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
        ],
      ),
    );
  }
}
