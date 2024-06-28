import 'package:behavior_subject_example/domain/entity/auth_state.dart';
import 'package:rxdart/streams.dart';

/// Интерфейс репозитория для работы с авторизацией.
abstract interface class IAuthRepository {
  /// Поток состояния авторизации.
  /// При подписке на поток подписчик сразу получит последнее значение.
  ValueStream<AuthState> get authState;

  /// Инициализация репозитория.
  Future<void> init();

  /// Вход в аккаунт.
  Future<void> logIn();

  /// Выход из аккаунта.
  Future<void> logOut();

  /// Освобождение ресурсов.
  void dispose();
}
