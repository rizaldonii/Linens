import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linens/features/global/toast.dart';

final _auth = FirebaseAuth.instance;

class FirebaseAuthService {
  final form = GlobalKey<FormState>();

  FirebaseAuth _auth = FirebaseAuth.instance;

  // create the user
  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'Alamat email sudah pernah digunakan.');
      } else {
        showToast(message: 'An error occured: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Alamat email atau Password salah.');
      } else {
        showToast(message: 'An error occured: ${e.code}');
      }
      ;
    }
    return null;
  }

  // var isLogin = true;
  // var enteredEmail = '';
  // var enteredPassword = '';

  // void submit() async {
  //   final _isvalid = form.currentState!.validate();

  //   if (!_isvalid) {
  //     return;
  //   }

  //   form.currentState!.save();

  //   try {
  //     if (isLogin) {
  //       final UserCredential = await _fireAuth.signInWithEmailAndPassword(
  //           email: enteredEmail, password: enteredPassword);
  //     } else {
  //       final UserCredential = await _fireAuth.createUserWithEmailAndPassword(
  //           email: enteredEmail, password: enteredPassword);
  //     }
  //   } catch (e) {
  //     if (e is FirebaseAuthException) {
  //       if (e.code == 'email-already-in-use') {
  //         print("email already in use.");
  //       }
  //     }
  //   }
}
