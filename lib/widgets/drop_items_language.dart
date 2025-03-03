import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../provider/select_language.dart';
import '../provider/select_theme.dart';
import '../style/app_colors.dart';
import '../style/my_theme_data.dart';

class DropItemsMenuLanguage extends StatelessWidget {
  const DropItemsMenuLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<SelectTheme>(context, listen: false);
    return themeProvider.isDarkMode()
        ? DropdownButtonFormField(
            onChanged: (value) {
              Provider.of<SelectLanguage>(context, listen: false)
                  .changeLanguage(value!);
            },
            items: [
              DropdownMenuItem(
                value: 'en',
                child: Text(
                  AppLocalizations.of(context)!.english,
                  style: MyThemeData.darkTheme.textTheme.titleSmall,
                ),
              ),
              DropdownMenuItem(
                value: 'ar',
                child: Text(
                  AppLocalizations.of(context)!.arabic,
                  style: MyThemeData.darkTheme.textTheme.titleSmall,
                ),
              ),
            ],
            hint: Text(
              'Select Language',
              style: MyThemeData.darkTheme.textTheme.titleMedium,
            ),
            isExpanded: true,
            dropdownColor: AppColors.cardDarkColor,
            value: Provider.of<SelectLanguage>(context).appLanguage,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              fillColor: AppColors.cardDarkColor,
              filled: true,
              enabled: false,
            ),
          )
        : DropdownButtonFormField(
            onChanged: (value) {
              Provider.of<SelectLanguage>(context, listen: false)
                  .changeLanguage(value!);
            },
            items: [
              DropdownMenuItem(
                value: 'en',
                child: Text(
                  AppLocalizations.of(context)!.english,
                  style: MyThemeData.lightTheme.textTheme.titleMedium,
                ),
              ),
              DropdownMenuItem(
                value: 'ar',
                child: Text(
                  AppLocalizations.of(context)!.arabic,
                  style: MyThemeData.lightTheme.textTheme.titleMedium,
                ),
              ),
            ],
            hint: Text(
              'Select Language',
              style: MyThemeData.lightTheme.textTheme.titleMedium,
            ),
            isExpanded: true,
            value: Provider.of<SelectLanguage>(context).appLanguage,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              fillColor: AppColors.whiteColor,
              filled: true,
              enabled: false,
            ),
          );
  }
}
