import 'package:behavior_subject_example/api/auth_client.dart';
import 'package:behavior_subject_example/data/repository/auth_repository.dart';
import 'package:behavior_subject_example/domain/entity/auth_state.dart';
import 'package:behavior_subject_example/persistance/tokens_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

/// Создаем моки для зависимостей класса [AuthRepository].
class MockTokensStorage extends Mock implements TokensStorage {}

class MockAuthClient extends Mock implements AuthClient {}

void main() {
  final mockTokensStorage = MockTokensStorage();
  final mockAuthClient = MockAuthClient();
  late AuthRepository authRepository;

  setUpAll(() {
    // Мокируем методы клиента и хранилища, которые вызывает authRepository.
    when(mockAuthClient.logIn).thenAnswer((_) async {});
    when(mockAuthClient.logOut).thenAnswer((_) async {});
    when(mockTokensStorage.saveTokens).thenAnswer((_) async {});
    when(mockTokensStorage.clear).thenAnswer((_) async {});
  });

  // Инициализируем репозиторий перед каждым тестом, чтобы тесты были независимы друг от друга.
  setUp(() {
    authRepository = AuthRepository(mockTokensStorage, mockAuthClient);
  });

  tearDown(() {
    authRepository.dispose();
  });

  group('Тест метода init().', () {
    test(
      'Если токен сохранен, init() установит состояние авторизации в AuthState.authenticated.',
      () async {
        // Мокируем метод accessToken так, чтобы он возвращал строкой. Имитируем наличие токена.
        when(() => mockTokensStorage.accessToken).thenAnswer((_) async => 'token');

        // Делаем вызов тестируемого метода.
        await authRepository.init();

        // Проверяем результат вызова. authState должен иметь значение AuthState.authenticated.
        expect(authRepository.authState.value, AuthState.authenticated);
      },
    );
    test(
      'Если токен отсутствует, init() установит состояние авторизации в AuthState.unauthenticated.',
      () async {
        // Мокируем метод accessToken так, чтобы он был null. Имитируем отсутствие токена.
        when(() => mockTokensStorage.accessToken).thenAnswer((_) async => null);

        // Делаем вызов тестируемого метода.
        await authRepository.init();

        // Проверяем результат вызова. authState должен иметь значение AuthState.unauthenticated.
        expect(authRepository.authState.value, AuthState.unauthenticated);
      },
    );

    test(
      'В случае исключения, ошибка запишется в authState.',
      () async {
        final exception = Exception('Произошла ошибка при получении токена');

        // Мокируем метод accessToken так, чтобы он выбрасывал исключение.
        when(() => mockTokensStorage.accessToken).thenThrow(exception);

        // Делаем вызов тестируемого метода.
        await authRepository.init();

        // Проверяем результат вызова. authState должен содержать ошибку.
        expect(authRepository.authState, emitsError(exception));
      },
    );
  });

  test(
    'Метод logIn() должен сохранить токены, отправить запрос на сервер и установить состояние авторизации в AuthState.unauthenticated.',
    () async {
      // Делаем вызов тестируемого метода.
      await authRepository.logIn();

      // Проверяем результаты вызова.

      // authState должен иметь значение AuthState.authenticated.
      expect(authRepository.authState.value, AuthState.authenticated);

      // Методы logIn() и saveTokens() должны быть вызваны по одному разу.
      verify(mockAuthClient.logIn).called(1);
      verify(mockTokensStorage.saveTokens).called(1);
    },
  );

  test(
    'Метод logOut() должен удалить токены, отправить запрос на сервер и установить состояние авторизации в AuthState.unauthenticated.',
    () async {
      // Делаем вызов тестируемого метода.
      await authRepository.logOut();

      // Проверяем результаты вызова.

      // authState должен иметь значение AuthState.unauthenticated.
      expect(authRepository.authState.value, AuthState.unauthenticated);

      // Методы logOut() и clear() должны быть вызваны по одному разу.
      verify(mockAuthClient.logOut).called(1);
      verify(mockTokensStorage.clear).called(1);
    },
  );
}
