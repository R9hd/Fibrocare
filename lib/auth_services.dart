// in this file exist all auth services
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

// Sign Up method
  Future<User?> SignupWithEmailandPass(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        Fluttertoast.showToast(
          msg: "البريد الإلكتروني مستخدم بالفعل",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 3,
          fontSize: 16,
        );
      } else {
        Fluttertoast.showToast(
          msg: "حدث خطأ ما: ${e.code}",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 3,
          fontSize: 16,
        );
      }
    }
    return null;
  }

  // Sign In method
  Future<User?> SigninWithEmailandPass(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print("حدث خطأ");
    }
    return null;
  }
}
