import 'package:behavior_subject_example/api/auth_client.dart';
import 'package:behavior_subject_example/domain/entity/auth_state.dart';
import 'package:behavior_subject_example/domain/repository/i_auth_repository.dart';
import 'package:behavior_subject_example/persistance/tokens_storage.dart';
import 'package:rxdart/subjects.dart';

class AuthRepository implements IAuthRepository {
  final TokensStorage _tokensStorage;
  final AuthClient _authClient;
  final _authSubject = BehaviorSubject<AuthState>();

  @override
  Stream<AuthState> get authState => _authSubject.stream;

  AuthRepository(this._tokensStorage, this._authClient);

  @override
  Future<void> init() async {
    try {
      final token = await _tokensStorage.accessToken;

      _authSubject.add(token != null ? AuthState.authenticated : AuthState.unauthenticated);
    } on Exception {
      _authSubject.add(AuthState.unauthenticated);
    }
  }

  @override
  Future<void> logIn() async {
    await _authClient.logIn();
    await _tokensStorage.saveTokens();
    _authSubject.add(AuthState.authenticated);
  }

  @override
  Future<void> logOut() async {
    await _authClient.logOut();
    await _tokensStorage.clear();
    _authSubject.add(AuthState.unauthenticated);
  }

  @override
  void dispose() {
    _authSubject.close();
  }
}
