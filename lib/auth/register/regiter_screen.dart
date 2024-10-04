import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/auth/costume_text_form_field.dart';
import 'package:todo_app/auth/register/register_navigator.dart';
import 'package:todo_app/auth/register/register_screen_view_model.dart';
import 'package:todo_app/dialog_utils.dart';
import 'package:todo_app/home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register_screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    implements RegisterNavigator {
  TextEditingController nameController = TextEditingController(text: 'yousef');

  TextEditingController emailController =
      TextEditingController(text: 'yaso.kan@gmail.com');

  TextEditingController passwordController =
      TextEditingController(text: '123456');

  TextEditingController confirmPasswordController =
      TextEditingController(text: '123456');

  var formKey = GlobalKey<FormState>();

  RegisterScreenViewModel viewModel = RegisterScreenViewModel();

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
      child: Stack(children: [
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
            title: Text('Create Account',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.whiteColor,
                    )),
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                      CostumeTextFormField(
                        label: 'User name',
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'please enter userName';
                          }
                          return null;
                        },
                        controller: nameController,
                      ),
                      CostumeTextFormField(
                        label: 'Email',
                        controller: emailController,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'please enter your email';
                          }
                          final bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(text);
                          if (!emailValid) {
                            return 'please enter a valid email';
                          }
                          return null;
                        },
                        keyboaredType: TextInputType.emailAddress,
                      ),
                      CostumeTextFormField(
                        label: 'Password',
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'please enter your password';
                          }
                          if (text.length < 8) {
                            return 'passwoerd should be at laest 8 chars';
                          }
                          return null;
                        },
                        controller: passwordController,
                        keyboaredType: TextInputType.visiblePassword,
                        obscureText: true,
                      ),
                      CostumeTextFormField(
                        label: 'Confirm password',
                        controller: confirmPasswordController,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'please enter your paswword again';
                          }
                          if (text != passwordController.text) {
                            return "'confirm password dosen't match'";
                          }
                          return null;
                        },
                        keyboaredType: TextInputType.visiblePassword,
                        obscureText: true,
                      ),
                      Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  elevation: WidgetStatePropertyAll(10),
                                  padding:
                                      WidgetStatePropertyAll(EdgeInsets.all(8)),
                                  backgroundColor: WidgetStatePropertyAll(
                                      AppColors.primaryColor)),
                              onPressed: () {
                                viewModel.register(emailController.text,
                                    passwordController.text, context);
                              },
                              child: Text(
                                'Create Account',
                                style: Theme.of(context).textTheme.titleLarge,
                              ))),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }

  void register() async {
    if (formKey.currentState?.validate() == true) {}
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
        context: context,
        content: 'Acc Registered successfully',
        title: 'Success',
        posActionName: 'Ok',
        posAction: () {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        });
  }
}
