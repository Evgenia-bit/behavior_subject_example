import 'package:behavior_subject_example/domain/entity/profile_entity.dart';

/// Интерфейс репозитория для работы с профилем.
// ignore: one_member_abstracts
abstract interface class IProfileRepository {
  /// Получение профиля.
  Future<ProfileEntity> fetchProfile();
}
