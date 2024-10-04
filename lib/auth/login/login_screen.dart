import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/auth/costume_text_form_field.dart';
import 'package:todo_app/auth/login/login_navigator.dart';
import 'package:todo_app/auth/login/login_screen_view_model.dart';
import 'package:todo_app/auth/register/regiter_screen.dart';
import 'package:todo_app/dialog_utils.dart';
import 'package:todo_app/home/home_screen.dart';

class LoginScreen extends StatefulWidget {

  static const String routeName = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> implements LoginNavigator {
  LoginScreenViewModel viewModel = LoginScreenViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel.navigator = this;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Stack(
        children: [
          Container(
            color: AppColors.backgroundLightColor,
            child: Image.asset(
              'assets/images/background.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                'Login',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.whiteColor,
                    ),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                      key: viewModel.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 30, left: 15, bottom: 5),
                            child: Text(
                              'Welcome Back!',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          CostumeTextFormField(
                            keyboaredType: TextInputType.emailAddress,
                            label: 'Email',
                            controller: viewModel.emailController,
                            validator: (text) {
                              if (text == null || text.trim().isEmpty) {
                                return 'Please enter Email.';
                              }
                              final bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(text);
                              if (!emailValid) {
                                return 'Please enter valid email.';
                              }
                              return null;
                            },
                          ),
                          CostumeTextFormField(
                            keyboaredType: TextInputType.number,
                            label: 'Password',
                            controller: viewModel.passwordController,
                            obscureText: true,
                            validator: (text) {
                              if (text == null || text.trim().isEmpty) {
                                return 'Please enter Password.';
                              }
                              if (text.length < 6) {
                                return 'Password should be at least 6 chars.';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    elevation: WidgetStatePropertyAll(10),
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.all(8)),
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppColors.primaryColor)),
                                onPressed: () {
                                  viewModel.login(context);
                                },
                                child: Text(
                                  'Login',
                                  style: Theme.of(context).textTheme.titleLarge,
                                )),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(RegisterScreen.routeName);
                              },
                              child: Text("OR Create Account"))
                        ],
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void hideMyLoading() {
    DialogUtils.hideLoading(context);
  }

  @override
  void showMyLoading(String message) {
    DialogUtils.showLoading(context: context, message: message);
  }

  @override
  void showMyMessage(String message) {
    DialogUtils.showMessage(
        title: 'Login',
        context: context,
        content: 'Login Success',
        posActionName: 'Ok',
        posAction: () {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        });
  }
}
