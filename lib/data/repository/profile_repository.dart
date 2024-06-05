import 'package:behavior_subject_example/domain/entity/profile_entity.dart';
import 'package:behavior_subject_example/domain/repository/i_profile_repository.dart';

class ProfileRepository implements IProfileRepository {
  @override
  Future<ProfileEntity> fetchProfile() {
    // Имитируем загрузку профиля.
    return Future.value(
      const ProfileEntity(
        id: 1,
        name: 'Иван Иванов',
        email: 'ivan@gmail.com',
      ),
    );
  }
}
