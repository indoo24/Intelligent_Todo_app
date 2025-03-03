import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/auth/login/login_screen.dart';
import 'package:todo_app/style/my_theme_data.dart';

import '../../firebase_utils.dart';
import '../../provider/firbase_provider.dart';
import '../../provider/select_theme.dart';
import '../../style/app_colors.dart';
import '../../widgets/custom_btn.dart';
import '../../widgets/drop_items_language.dart';

class Settings extends StatefulWidget {
  static const String routeName = 'settings';

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<SelectTheme>(context);
    var firebaseList = Provider.of<FireBaseProvider>(context);
    return themeProvider.isDarkMode()
        ? Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalizations.of(context)!.language,
                  style: MyThemeData.darkTheme.textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 8,
                ),
                const DropItemsMenuLanguage(),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  AppLocalizations.of(context)!.mode,
                  style: MyThemeData.darkTheme.textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 8,
                ),
                DropdownButtonFormField(
                  value: Provider.of<SelectTheme>(context).isDarkMode()
                      ? 'dark'
                      : 'light',
                  onChanged: (value) {
                    Provider.of<SelectTheme>(context, listen: false)
                        .selectTheme();
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'light',
                      child: Text(
                        AppLocalizations.of(context)!.light,
                        style: MyThemeData.darkTheme.textTheme.titleSmall,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'dark',
                      child: Text(
                        AppLocalizations.of(context)!.dark,
                        style: MyThemeData.darkTheme.textTheme.titleSmall,
                      ),
                    ),
                  ],
                  dropdownColor: AppColors.cardDarkColor,
                  hint: Text(
                    'Select Theme',
                    style: MyThemeData.darkTheme.textTheme.titleMedium,
                  ),
                  isExpanded: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    fillColor: AppColors.cardDarkColor,
                    filled: true,
                    enabled: false,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                CustomBtn(
                    titleBtn: AppLocalizations.of(context)!.logout_account,
                    onTap: () {
                      FirebaseUtils.signOut();
                      firebaseList.tasksList = [];
                      Navigator.pushReplacementNamed(
                          context, LoginScreen.routeName);
                    })
              ],
            ),
          )
        : //Dark Theme
        Container(
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalizations.of(context)!.language,
                  style: MyThemeData.lightTheme.textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 8,
                ),
                const DropItemsMenuLanguage(),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  AppLocalizations.of(context)!.mode,
                  style: MyThemeData.lightTheme.textTheme.bodyLarge,
                ),
                const SizedBox(
                  height: 8,
                ),
                DropdownButtonFormField(
                  value: Provider.of<SelectTheme>(context).isDarkMode()
                      ? 'dark'
                      : 'light',
                  onChanged: (value) {
                    Provider.of<SelectTheme>(context, listen: false)
                        .selectTheme();
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'light',
                      child: Text(
                        AppLocalizations.of(context)!.light,
                        style: MyThemeData.lightTheme.textTheme.titleMedium,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'dark',
                      child: Text(
                        AppLocalizations.of(context)!.dark,
                        style: MyThemeData.lightTheme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                  hint: Text(
                    'Select Theme',
                    style: MyThemeData.darkTheme.textTheme.titleMedium,
                  ),
                  isExpanded: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    fillColor: AppColors.whiteColor,
                    filled: true,
                    enabled: false,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                CustomBtn(
                    titleBtn: AppLocalizations.of(context)!.logout_account,
                    onTap: () {
                      FirebaseUtils.signOut();
                      firebaseList.tasksList = [];
                      Navigator.pushReplacementNamed(
                          context, LoginScreen.routeName);
                    })
              ],
            ),
          ); //Light Theme
  }
}
