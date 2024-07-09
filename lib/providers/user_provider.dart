import 'package:flutter/foundation.dart';
import 'package:personal_expense_tracker/models/user_model.dart';
import 'package:personal_expense_tracker/models/user_model.dart'as model;
import 'package:personal_expense_tracker/resources/auth_methods.dart';

// class UserProvider with ChangeNotifier {
//   User? _user;
//
//   final AuthMethod _authMethods = AuthMethod();
//
//   User? get getUser => _user;
//
//   Future<void> refreshUser() async {
//
//     User user = await _authMethods.getUserDetails();
//
//     _user = user;
//
//     notifyListeners();
//   }
//
//   Future<void> addUserDetails(User user) async {
//     await _authMethods.addUserDetails(user);
//     refreshUser(); // Optionally refresh user after adding details
//   }
// }


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
    refreshUser(); // Optionally refresh user after adding details
  }

  // New function to refresh home screen data
  Future<void> refreshHomeScreen() async {
    await refreshUser();  // Refresh user data first
    // You can add additional logic if needed for home screen refresh
    notifyListeners();  // Notify listeners to rebuild the home screen
  }
}



// class TransactionProvider extends ChangeNotifier {
//   List<model.User> transactions = [];
//
//   void addTransaction(model.User newTransaction) {
//     transactions.add(newTransaction);
//     notifyListeners(); // Notify listeners about the change
//   }
// }

///cubit
///hive
///محمد نبيل
///