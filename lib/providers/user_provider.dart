import 'package:flutter/foundation.dart';
import 'package:personal_expense_tracker/models/user_model.dart';
import 'package:personal_expense_tracker/models/user_model.dart'as model;
import 'package:personal_expense_tracker/resources/auth_methods.dart';


class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethod _authMethods = AuthMethod();

  User? get getUser => _user;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

  Future<void> addUserDetails(User user) async {
    await _authMethods.addUserDetails(user);
    refreshUser();
  }

  Future<void> refreshHomeScreen() async {
    await refreshUser();
    notifyListeners();
  }
}



