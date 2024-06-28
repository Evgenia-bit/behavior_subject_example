/// Класс для работы с токенами.
class TokensStorage {
  Future<String?> get accessToken async {
    // Имитируем получение access-токена.
    return null;
  }

  Future<String?> get refreshToken async {
    // Имитируем получение refresh-токена.
    return null;
  }

  Future<void> saveTokens() async {
    // Имитируем сохранение токенов.
    return Future.delayed(Duration.zero);
  }

  Future<void> clear() async {
    // Имитируем удаление токенов.
    return Future.delayed(Duration.zero);
  }
}
