import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/auth/costume_text_form_field.dart';
import 'package:todo_app/auth/register/regiter_screen.dart';
import 'package:todo_app/dialog_utils.dart';
import 'package:todo_app/home/home_screen.dart';

class LoginScreen extends StatefulWidget {

  static const String routeName = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(
            color: AppColors.backgroundLightColor,
            child: Image.asset('assets/images/background.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),


          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text('Login'),
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.3,),
                        Padding(padding: EdgeInsets.all(8.0),
                          child: Text('Welcome Back!',
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleMedium,
                          ),
                        ),
                        CostumeTextFormField(label: 'Email',
                          controller: emailController,
                          validator: (text) {
                            if (text == null || text
                                .trim()
                                .isEmpty) {
                              return 'please enter your email';
                            }
                            final bool emailValid =
                            RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(text);
                            if (!emailValid) {
                              return 'please enter a valid email';
                            }
                            return null;
                          },
                          keyboaredType: TextInputType.emailAddress,
                        ),

                        CostumeTextFormField(label: 'Password',
                          validator: (text) {
                            if (text == null || text
                                .trim()
                                .isEmpty) {
                              return 'please enter your password';
                            }
                            return null;
                          },
                          controller: passwordController,
                          keyboaredType: TextInputType.visiblePassword,
                          obscureText: true,
                        ),

                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                login();
                              },
                              child: Text('Login',
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.white),
                              )),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  RegisterScreen.routeName);
                            },
                            child: Text('Or create account'))
                      ],
                    ),

                  )
                ],
              ),
            ),
          )
        ]);
  }

  void login() async {
    if (formKey.currentState?.validate() == true) {
      //todo: show loading
      DialogUtils.showLoading(context, 'loading');
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text
        );
        //todo: hide loading
        DialogUtils.hideLoading(context);
        //todo: show message
        DialogUtils.showMessage(
            context: context,
            content: 'Login succsessfully',
            button: 'ok',
            function: () {
              Navigator.of(context).pushNamed(HomeScreen.routeName);
            }
        );
        print('Login succsessfully');
        print(credential.user?.uid ?? "");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          //todo: hide loading
          DialogUtils.hideLoading(context);
          //todo: show message
          DialogUtils.showMessage(
              context: context,
              content: 'user not found',
              button: 'ok',
              title: 'Error');
          function:
              () {
            Navigator.of(context).pop();
          }
          print('No user found for that email.');
        } else if (e.code == 'RecaptchaAction)') {
          //todo: hide loading
          DialogUtils.hideLoading(context);
          //todo: show message
          DialogUtils.showMessage(
              context: context,
              content: 'Wrong password',
              button: 'ok',
              title: 'Error',
              function: () {
                Navigator.of(context).pop();
              }
          );
          print('Wrong password provided for that user.');
        }
      }
      catch (e) {
        //todo: hide loading
        DialogUtils.hideLoading(context);
        //todo: show message
        DialogUtils.showMessage(
            context: context,
            content: e.toString(),
            button: 'ok',
            title: 'Error',
            function: () {
              Navigator.of(context).pop();
            }
        );
        print(e);
      }
    }
  }
}
