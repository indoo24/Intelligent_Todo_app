import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/auth/login/login_screen.dart';
import 'package:todo_app/home/settings/settings_tab.dart';
import 'package:todo_app/home/task_list/add_task_bottom_sheet.dart';
import 'package:todo_app/home/task_list/task_list_tab.dart';
import 'package:todo_app/provider/list_provider.dart';
import 'package:todo_app/provider/user_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    var listProvider = Provider.of<ListProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            selectedIndex == 0
                ? 'To Do List <[${userProvider.currentUser!.name}]>'
                : 'Settings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  listProvider.tasksList = [];
                  // userProvider.currentUser = null ;
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                },
                icon: Icon(Icons.logout))
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 11,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.backgroundLightColor),
            ),
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (index) {
                selectedIndex = index;
                setState(() {});
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.list,
                      size: 20,
                    ),
                    label: AppLocalizations.of(context)!.task_list),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.settings,
                      size: 20,
                    ),
                    label: AppLocalizations.of(context)!.settings),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addTaskBottomSheet();
          },
          child: Icon(
            Icons.add,
            size: 30,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Column(
          children: [
            Container(
              color: AppColors.primaryColor,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Expanded(child: tabs[selectedIndex]),
          ],
        ));
  }

  List<Widget> tabs = [TaskListTab(), SettingsTab()];

  void addTaskBottomSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => AddTaskBottomSheet());
  }
}