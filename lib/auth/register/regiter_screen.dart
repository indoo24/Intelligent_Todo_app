import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/app_colors.dart';
import 'package:todo_app/auth/costume_text_form_field.dart';
import 'package:todo_app/dialog_utils.dart';
import 'package:todo_app/home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register_screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
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
          title: Text('create account'),
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
                          onPressed: () {
                            register();
                          },
                          child: Text('Create account')),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    ]);
  }

  void register() async {
    if (formKey.currentState?.validate() == true) {
      // todo: show loading
      DialogUtils.showLoading(context, 'loading');
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        //todo: hide loading
        DialogUtils.hideLoading(context);
        //todo: show message
        DialogUtils.showMessage(
            context: context,
            content: 'register succsessfully',
            button: 'ok',
            title: 'Sucsess',
            function: () {
              Navigator.of(context).pushNamed(HomeScreen.routeName);
            });
        print('register succsessfully');
        print(credential.user?.uid ?? "");
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          //todo: hide loading
          DialogUtils.hideLoading(context);
          //todo: show message
          DialogUtils.showMessage(
              context: context,
              content: 'The password provided is too weak.',
              button: 'ok',
              title: 'Error',
              function: () {
                Navigator.of(context).pop();
              });
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          //todo: hide loading
          DialogUtils.hideLoading(context);
          //todo: show message
          DialogUtils.showMessage(
              context: context,
              content: 'The account already exists for that email. ',
              button: 'ok',
              title: 'Error',
              function: () {
                Navigator.of(context).pop();
              });
          print('The account already exists for that email.');
        }
      } catch (e) {
        //todo: hide loading
        DialogUtils.hideLoading(context);
        //todo: show message
        DialogUtils.showMessage(
            context: context,
            content: e.toString(),
            button: 'ok',
            function: () {
              Navigator.of(context).pop();
            });
        print(e);
      }
    }
  }
}
