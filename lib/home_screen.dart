import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/tabs/settings/settings_provider.dart';
import 'package:todo_app/tabs/settings/settings_tab.dart';
import 'package:todo_app/tabs/tasks/add_task_bottom_sheet.dart';
import 'package:todo_app/tabs/tasks/tasks_tab.dart';

import 'app_theme.dart';
import 'l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  static const String routename = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTabIndex = 0;
  List<Widget> tabs = [
    const TasksTab(),
    const SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    TextStyle? titleMediumStyle = Theme.of(context).textTheme.titleMedium;
    SettingsProvider settingsProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: settingsProvider.isDark
          ? AppTheme.backGroundDark
          : AppTheme.backGroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primary,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.todoList,
          style: settingsProvider.isDark
              ? titleMediumStyle?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                )
              : titleMediumStyle?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.white,
                ),
        ),
        elevation: 0,
      ),
      body: tabs[currentTabIndex],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        padding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: BottomNavigationBar(
          currentIndex: currentTabIndex,
          onTap: (index) {
            setState(() {
              currentTabIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              label: 'Tasks',
              icon: Icon(
                Icons.list,
                size: 32,
              ),
            ),
            BottomNavigationBarItem(
                label: 'Settings',
                icon: Icon(
                  Icons.settings_outlined,
                  size: 32,
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) => const AddTaskBottomSheet(),
        ),
        child: const Icon(
          Icons.add,
          size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
