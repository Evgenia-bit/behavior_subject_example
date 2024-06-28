import 'package:behavior_subject_example/domain/entity/profile_entity.dart';
import 'package:behavior_subject_example/domain/repository/i_profile_repository.dart';

/// Репозиторий для работы с профилем.
class ProfileRepository implements IProfileRepository {
  @override
  Future<ProfileEntity> fetchProfile() {
    // Имитируем загрузку профиля.
    return Future.delayed(
      const Duration(seconds: 1),
      () => const ProfileEntity(
        id: 1,
        name: 'Иван Иванов',
        email: 'ivan@gmail.com',
      ),
    );
  }
}
