import 'package:behavior_subject_example/domain/entity/auth_state.dart';
import 'package:behavior_subject_example/domain/entity/profile_entity.dart';
import 'package:behavior_subject_example/domain/repository/i_auth_repository.dart';
import 'package:behavior_subject_example/domain/repository/i_profile_repository.dart';
import 'package:flutter/material.dart';

/// Виджет экрана профиля.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.authRepository,
    required this.profileRepository,
  });

  final IAuthRepository authRepository;
  final IProfileRepository profileRepository;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileEntity? profile;

  @override
  void initState() {
    // Подписываемся на stream с состоянием авторизации.
    widget.authRepository.authState.listen(_listenAuthState);
    super.initState();
  }

  /// Функция срабатывает каждый раз, когда меняется состояние авторизации.
  void _listenAuthState(AuthState state) {
    switch (state) {
      case AuthState.authenticated:
        // Загружаем профиль, если пользователь авторизован.
        _loadProfile();
      case AuthState.unauthenticated:
        profile = null;
    }
  }

  Future<void> _loadProfile() async {
    profile = await widget.profileRepository.fetchProfile();
  }

  /// Обработчик нажатия на кнопку "Войти".
  void _onLoginButtonPressed() {
    widget.authRepository.logIn().then(
          (_) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Вы успешно авторизовались'),
            ),
          ),
        );
  }

  /// Обработчик нажатия на кнопку "Выйти".
  void _onLogoutButtonPressed() {
    widget.authRepository.logOut().then(
          (_) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Вы успешно вышли'),
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: SafeArea(
        /// StreamBuilder позволяет автоматически обновлять виджет при изменении данных.
        /// Функция builder вызывается каждый раз, когда меняется состояние авторизации.
        child: StreamBuilder(
          stream: widget.authRepository.authState,
          builder: (_, snapshot) {
            return switch (snapshot.data) {
              AuthState.authenticated => _AuthenticatedStateWidget(
                  profile: profile,
                  onLogoutButtonPressed: _onLogoutButtonPressed,
                ),
              AuthState.unauthenticated => _UnauthenticatedStateWidget(
                  onAuthButtonPressed: _onLoginButtonPressed,
                ),
              _ => const Center(child: CircularProgressIndicator()),
            };
          },
        ),
      ),
    );
  }
}

class _AuthenticatedStateWidget extends StatelessWidget {
  const _AuthenticatedStateWidget({
    required this.profile,
    required this.onLogoutButtonPressed,
  });

  final ProfileEntity? profile;
  final VoidCallback onLogoutButtonPressed;

  @override
  Widget build(BuildContext context) {
    if (profile == null) {
      return const Center(
        child: Text('Профиль не загружен'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          const CircleAvatar(
            radius: 50,
            child: Icon(
              Icons.person_outlined,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile!.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(profile!.email),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onLogoutButtonPressed,
              child: const Text('Выйти'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _UnauthenticatedStateWidget extends StatelessWidget {
  const _UnauthenticatedStateWidget({
    required this.onAuthButtonPressed,
  });

  final VoidCallback onAuthButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Expanded(
            child: Center(child: Text('Авторизуйтесь, чтобы увидеть профиль')),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAuthButtonPressed,
              child: const Text('Войти'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
