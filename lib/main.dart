import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/tabs/settings/settings_provider.dart';
import 'package:todo_app/tabs/tasks/edit_task_screen.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';

import 'app_theme.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';
import 'auth/user_provider.dart';
import 'home_screen.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyBRzESOQPsNYH1rc-5G2jEBXFRhBsvHnvg',
              appId: '1:583743039074:android:30a671560edfa44226933b',
              messagingSenderId: '583743039074',
              projectId: 'todo-app-36d7d'))
      : await Firebase.initializeApp();
  await FirebaseFirestore.instance.disableNetwork();
  var settingsProvider = SettingsProvider();
  await settingsProvider.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TasksProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => settingsProvider,
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: const TodoApp(),
    ),
  );
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Consumer<SettingsProvider>(
        builder: (BuildContext context, dynamic provider, Widget? child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          HomeScreen.routename: (_) => const HomeScreen(),
          EditTaskScreen.routename: (_) => const EditTaskScreen(),
          RegisterScreen.routeName: (_) => const RegisterScreen(),
          LoginScreen.routeName: (_) => const LoginScreen(),
        },
        initialRoute: LoginScreen.routeName,
        darkTheme: AppTheme.darkTheme,
        themeMode: SettingsProvider.themeMode,
        theme: AppTheme.lighTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale(settingsProvider.language),
      );
    });
  }
}
