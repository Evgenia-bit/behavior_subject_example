import 'package:behavior_subject_example/domain/entity/profile_entity.dart';

abstract interface class IProfileRepository {
  Future<ProfileEntity> fetchProfile();
}
