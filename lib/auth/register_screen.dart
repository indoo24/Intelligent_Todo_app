import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/auth/user_provider.dart';
import 'package:todo_app/models/user_model.dart';
import '../app_theme.dart';
import '../home_screen.dart';
import '../l10n/app_localizations.dart';
import '../tabs/settings/settings_provider.dart';
import '../tabs/tasks/default_elevated_button.dart';
import '../tabs/tasks/default_text_form_field.dart';
import '../tabs/tasks/firebase_functions.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SettingsProvider().isDark
          ? AppTheme.backGroundDark
          : AppTheme.backGroundLight,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          AppLocalizations.of(context)!.createAccount,
          style: const TextStyle(
            color: AppTheme.primary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DefaultTextFormField(
                controller: nameController,
                hintText: AppLocalizations.of(context)!.name,
                validator: (value) {
                  if (value == null || value.trim().length < 3) {
                    return AppLocalizations.of(context)!.nameval;
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              DefaultTextFormField(
                controller: emailController,
                hintText: AppLocalizations.of(context)!.email,
                validator: (value) {
                  if (value == null || value.trim().length < 5) {
                    return AppLocalizations.of(context)!.emailval;
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              DefaultTextFormField(
                controller: passwordController,
                hintText: AppLocalizations.of(context)!.password,
                validator: (value) {
                  if (value == null || value.trim().length < 8) {
                    return AppLocalizations.of(context)!.paswwordval;
                  }
                  return null;
                },
                isPassword: true,
              ),
              const SizedBox(
                height: 32,
              ),
              DefaultElevatedButton(
                label: AppLocalizations.of(context)!.createAccount,
                onPressed: () {
                  register();
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                },
                child: Text(AppLocalizations.of(context)!.alreadyHaveAccount),
              )
            ],
          ),
        ),
      ),
    );
  }

  void register() {
    if (formKey.currentState!.validate()) {
      FirebaseFunctions.register(
              name: nameController.text,
              email: emailController.text,
              password: passwordController.text)
          .then((user) {
        Provider.of<UserProvider>(context, listen: false)
            .updateUser(user as UserModel?);
        Navigator.of(context).pushReplacementNamed(HomeScreen.routename);
      }).catchError(
        (error) {
          String? message;
          if (error is FirebaseAuthException) {
            message = error.message;
          }
          Fluttertoast.showToast(
              msg: message ?? "Something Went Wrong!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 5,
              backgroundColor: AppTheme.red,
              textColor: Colors.white,
              fontSize: 16.0);
        },
      );
    }
  }
}
