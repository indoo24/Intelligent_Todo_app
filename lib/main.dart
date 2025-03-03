import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/auth/login/login_screen.dart';
import 'package:todo_app/home/home_screen.dart';
import 'package:todo_app/provider/firbase_provider.dart';
import 'package:todo_app/provider/list_provider.dart';
import 'package:todo_app/provider/select_language.dart';
import 'package:todo_app/provider/select_theme.dart';
import 'package:todo_app/provider/user_provider.dart';
import 'package:todo_app/style/my_theme_data.dart';

import 'auth/register/register_screen.dart';

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

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ListProvider()),
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => SelectLanguage()),
      ChangeNotifierProvider(create: (context) => SelectTheme()),
      ChangeNotifierProvider(create: (context) => FireBaseProvider()),
    ],
    child: myApp(),
  ));
}

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ListProvider>(context);
    var languageProvider = Provider.of<SelectLanguage>(context);
    var themeProvider = Provider.of<SelectTheme>(context);
    return MaterialApp(
      theme: MyThemeData.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.routeName,
      routes: {
        RegisterScreen.routeName: (context) => RegisterScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
      },
      themeMode: themeProvider.themeState,
      darkTheme: MyThemeData.darkTheme,
      locale: Locale(languageProvider.appLanguage),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
