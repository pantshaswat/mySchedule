import 'package:myschedule/services/auth/authProvider.dart';
import 'package:myschedule/services/auth/authUser.dart';
import 'package:myschedule/services/auth/firebaseAuthProvider.dart';

class authService implements authProvider {
  final authProvider provider;
  const authService(this.provider);
  factory authService.firebase() => authService(firebaseAuthProvider());

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<authUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(email: email, password: password);

  @override
  authUser? get currentUser => provider.currentUser;

  @override
  Future<authUser> login({
    required String email,
    required String password,
  }) =>
      provider.login(email: email, password: password);

  @override
  Future<void> logout() => provider.logout();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
}
