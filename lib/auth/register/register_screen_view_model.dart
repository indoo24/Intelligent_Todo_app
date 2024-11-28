import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/auth/register/register_navigator.dart';
import 'package:todo_app/home/firebase_utils.dart';
import 'package:todo_app/model/my_user.dart';
import 'package:todo_app/provider/user_provider.dart';

class RegisterScreenViewModel extends ChangeNotifier {
  //todo: hold data - handle logic
  late RegisterNavigator navigator;
  var emailController = TextEditingController(text: 'yaso.kan@gmail.com');
  var passwordController = TextEditingController(text: '123456');
  var nameController = TextEditingController(text: 'yousef');

  void register(String email, String password, context) async {
    //todo: show loading
    navigator.showMyLoading('Loading...');
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      MyUser myUser = MyUser(
          id: credential.user?.uid ?? '',
          name: nameController.text,
          email: emailController.text);
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateUser(myUser);
      await FirebaseUtils.addUserToFireStore(myUser);
      //todo: hide loading
      navigator.hideMyLoading();
      //todo: show Message
      navigator.showMyMessage('Register Successfully.');
      print('register successfully');
      print(credential.user?.uid ?? "");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        //todo: hide loading
        navigator.hideMyLoading();
        //todo: show Message
        navigator.showMyMessage('The password provided is too weak.');
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        //todo: hide loading
        navigator.hideMyLoading();
        //todo: show Message
        navigator.showMyMessage('The account already exists for that email.');
        print('The account already exists for that email.');
      } else if (e.code == 'network-request-failed') {
        //todo: hide loading
        navigator.hideMyLoading();
        //todo: show Message
        navigator.showMyMessage(
            'A network error (such as timeout, interrupted connection or unreachable host)'
            ' has occurred.');
        print('The account already exists for that email.');
      }
    } catch (e) {
      //todo: hide loading
      navigator.hideMyLoading();
      //todo: show Message
      navigator.showMyMessage(e.toString());
      //todo: hide loading
      print(e);
    }
  }
}
