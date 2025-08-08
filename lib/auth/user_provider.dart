import 'package:flutter/material.dart';

import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? currentUser;

  void updateUser(UserModel? user) {
    currentUser = user;
    notifyListeners();
  }
}
