import 'package:behavior_subject_example/domain/entity/auth_state.dart';
import 'package:behavior_subject_example/domain/repository/i_auth_repository.dart';
import 'package:behavior_subject_example/domain/repository/i_profile_repository.dart';
import 'package:flutter/material.dart';

/// Виджет экрана профиля.
class ProfileScreen extends StatefulWidget {
  final IAuthRepository authRepository;
  final IProfileRepository profileRepository;

  const ProfileScreen({
    required this.authRepository,
    required this.profileRepository,
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                  profileRepository: widget.profileRepository,
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

class _AuthenticatedStateWidget extends StatefulWidget {
  final IProfileRepository profileRepository;
  final VoidCallback onLogoutButtonPressed;

  const _AuthenticatedStateWidget({
    required this.profileRepository,
    required this.onLogoutButtonPressed,
  });

  @override
  State<_AuthenticatedStateWidget> createState() => _AuthenticatedStateWidgetState();
}

class _AuthenticatedStateWidgetState extends State<_AuthenticatedStateWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FutureBuilder(
        future: widget.profileRepository.fetchProfile(),
        builder: (context, snapshot) {
          final profile = snapshot.data;

          if (profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                profile.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(profile.email),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onLogoutButtonPressed,
                  child: const Text('Выйти'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}

class _UnauthenticatedStateWidget extends StatelessWidget {
  final VoidCallback onAuthButtonPressed;

  const _UnauthenticatedStateWidget({
    required this.onAuthButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
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
