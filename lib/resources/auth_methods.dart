import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:personal_expense_tracker/models/user_model.dart' as model;

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users')
        .doc(currentUser.uid)
        .get();

    return model.User.fromSnap(snap);
  }

  Future<void> addUserDetails(model.User user) async {
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      throw Exception('No authenticated user found');
    }

    try {
      // Add user details to Firestore
      await _firestore.collection('users').doc(currentUser.uid).set(user.toJson(), SetOptions(merge: true));
    } catch (e) {
      print("Error adding user details: $e");
      throw e; // Re-throw the error for further handling if needed
    }
  }

  ///sing up user
  Future<String> SingUpUser({
    required String email,
    required String password,
    required String username,
  }) async {
    String res = "Some error occur";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        ///register the user
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password
        );
        print(credential.user!.uid);

        model.User user = model.User(
            email: email,
            uid: credential.user!.uid,
            username: username,
        );

        /// add user to our database
        await _firestore.collection('users').doc(credential.user!.uid).set(user.toJson());

        res = 'success';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'the email is badly formatted';
      } else if (err.code == 'weak-password') {
        res = 'your password should be at last 6 characters';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> signInUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occurred';

    try {
      // Check for non-empty fields
      if (email.isNotEmpty || password.isNotEmpty) {
        // Sign in with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = 'Please enter all the fields';
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase auth exceptions
      switch (e.code) {
        case 'user-not-found':
          res = 'User not found';
          break;
        case 'wrong-password':
          res = 'The password is incorrect';
          break;
        case 'invalid-email':
          res = 'The email address is not valid';
          break;
        case 'user-disabled':
          res = 'The user account has been disabled';
          break;
        case 'too-many-requests':
          res = 'Too many requests, try again later';
          break;
        default:
          res = 'Authentication error: ${e.message}';
      }
    } catch (e) {
      // Catch any other exceptions
      res = 'An unexpected error occurred: $e';
    }

    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}