import 'package:myschedule/services/auth/authUser.dart';
import 'package:myschedule/services/auth/authProvider.dart';
import 'package:myschedule/services/auth/authException.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

class firebaseAuthProvider implements authProvider {
  @override
  Future<void> initialize() async {
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    //bring Firebase_options from firebase cli
  }

  @override
  Future<authUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw userNotFoundAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw emailAlreadyInUseException();
      }
      if (e.code == 'weak-password') {
        throw weakPasswordAuthException();
      }
      if (e.code == 'invalid-email') {
        throw invalidEmailAuthExcpetion();
      } else {
        throw genericAuthExcpetion();
      }
    } catch (_) {
      throw genericAuthExcpetion();
    }
  }

  @override
  authUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return authUser.fromFirebase(user);
    } else
      return null;
  }

  @override
  Future<authUser> login(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw userNotFoundAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw userNotFoundAuthException();
      }
      if (e.code == 'wrong-password') {
        throw wrongPasswordAuthException();
      } else {
        throw genericAuthExcpetion();
      }
    } catch (_) {
      throw genericAuthExcpetion();
    }
  }

  @override
  Future<void> logout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw userNotLoggedInAuthExcpetion();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }
    throw userNotLoggedInAuthExcpetion();
  }
}
