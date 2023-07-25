import 'package:myschedule/services/auth/authUser.dart';

//creating an abstract authProvider (general)class that can be
//used for different kind of user authentication types.

abstract class authProvider {
  Future<void> initialize();

  authUser? get currentUser; //getter to get current user
  //for login
  Future<authUser> login({
    required String email,
    required String password,
  });

//creating a user
  Future<authUser> createUser({
    required String email,
    required String password,
  });
  //logout
  Future<void> logout();
  //verification email
  Future<void> sendEmailVerification();
}
