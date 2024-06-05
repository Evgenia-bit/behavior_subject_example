import 'package:behavior_subject_example/api/auth_client.dart';
import 'package:behavior_subject_example/app.dart';
import 'package:behavior_subject_example/data/repository/auth_repository.dart';
import 'package:behavior_subject_example/data/repository/profile_repository.dart';
import 'package:behavior_subject_example/persistance/tokens_storage.dart';
import 'package:flutter/material.dart';

void main() {
  final authRepository = AuthRepository(
    TokensStorage(),
    AuthClient(),
  );
  final profileRepository = ProfileRepository();

  authRepository.init();

  runApp(App(
    authRepository: authRepository,
    profileRepository: profileRepository,
  ));
}
