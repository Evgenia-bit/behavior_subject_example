import 'package:behavior_subject_example/domain/repository/i_auth_repository.dart';
import 'package:behavior_subject_example/domain/repository/i_profile_repository.dart';
import 'package:behavior_subject_example/presentation/profile_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.authRepository,
    required this.profileRepository,
  });

  final IAuthRepository authRepository;
  final IProfileRepository profileRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileScreen(
        authRepository: authRepository,
        profileRepository: profileRepository,
      ),
    );
  }
}
