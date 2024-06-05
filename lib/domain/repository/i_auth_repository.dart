import 'package:behavior_subject_example/domain/entity/auth_state.dart';

abstract interface class IAuthRepository {
  Stream<AuthState> get authState;
  Future<void> init();
  Future<void> logIn();
  Future<void> logOut();
  void dispose();
}
