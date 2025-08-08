import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/tabs/settings/settings_provider.dart';
import '../../app_theme.dart';
import '../../auth/login_screen.dart';
import '../../auth/user_provider.dart';
import '../../l10n/app_localizations.dart';
import '../tasks/firebase_functions.dart';
import '../tasks/tasks_provider.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);

    return SafeArea(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                color: AppTheme.primary,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.settings,
                    style: TextStyle(
                      color: settingsProvider.isDark
                          ? AppTheme.white
                          : AppTheme.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 36,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.state,
                      style: TextStyle(
                        color: settingsProvider.isDark
                            ? AppTheme.white
                            : AppTheme.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      value: settingsProvider.isDark,
                      onChanged: (isDark) async {
                        await settingsProvider.changeThemeMode(
                            isDark ? ThemeMode.dark : ThemeMode.light);
                      },
                      activeTrackColor: AppTheme.green,
                      inactiveTrackColor: AppTheme.grey,
                    )
                  ],
                ),
                const SizedBox(
                  height: 36,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.language,
                      style: TextStyle(
                        color: settingsProvider.isDark
                            ? AppTheme.white
                            : AppTheme.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: settingsProvider.language,
                        items: [
                          DropdownMenuItem(
                            value: 'en',
                            child: settingsProvider.isDark
                                ? const Text(
                                    'English',
                                    style: TextStyle(color: AppTheme.grey),
                                  )
                                : const Text(
                                    'English',
                                    style: TextStyle(color: AppTheme.black),
                                  ),
                          ),
                          DropdownMenuItem(
                            value: 'ar',
                            child: settingsProvider.isDark
                                ? const Text(
                                    'العربية',
                                    style: TextStyle(color: AppTheme.grey),
                                  )
                                : const Text(
                                    'العربية',
                                    style: TextStyle(color: AppTheme.black),
                                  ),
                          )
                        ],
                        onChanged: (selectedLanguage) {
                          if (selectedLanguage == null) return;
                          settingsProvider.changeLanguage(selectedLanguage);
                        },
                        dropdownColor: settingsProvider.isDark
                            ? AppTheme.black
                            : AppTheme.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 36,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.logout,
                      style: TextStyle(
                        color: settingsProvider.isDark
                            ? AppTheme.white
                            : AppTheme.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        FirebaseFunctions.logout();
                        Navigator.of(context)
                            .pushReplacementNamed(LoginScreen.routeName);
                        Provider.of<TasksProvider>(context, listen: false)
                            .tasks
                            .clear();
                        Provider.of<UserProvider>(context, listen: false)
                            .updateUser(null);
                      },
                      icon: Icon(
                        Icons.logout_outlined,
                        size: 32,
                        color: settingsProvider.isDark
                            ? AppTheme.white
                            : AppTheme.black,
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
