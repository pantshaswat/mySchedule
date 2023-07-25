import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';
//only gets User class from firebase_auth

@immutable //this class and its subclasses are not changable
class authUser {
  final bool isEmailVerified;

  const authUser({required this.isEmailVerified});
  factory authUser.fromFirebase(User user) =>
      authUser(isEmailVerified: user.emailVerified);
  //factory initializer
}
