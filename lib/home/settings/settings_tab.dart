import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/home/settings/language_bottom_sheet.dart';

class SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 30, 0, 15),
          child: Text(
            AppLocalizations.of(context)!.language,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        InkWell(
          onTap: () {
            showLanguageBottomSheet(context);
          },
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 30,
            ),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.english),
                Icon(
                  Icons.arrow_drop_down,
                  size: 35,
                )
              ],
            ),
          ),
        ),

        //---------------------------------------------------------------//

        Padding(
          padding: const EdgeInsets.fromLTRB(25, 30, 0, 15),
          child: Text(
            AppLocalizations.of(context)!.theme,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        InkWell(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 30,
            ),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.english),
                Icon(
                  Icons.arrow_drop_down,
                  size: 35,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context, builder: (context) => LanguageBottomSheet());
  }
}
