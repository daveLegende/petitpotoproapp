import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';
import 'package:petitpotopro/core/di/service_locator.dart';
import 'package:petitpotopro/core/storage/secure_storage.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_event.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_state.dart';
import 'package:petitpotopro/features/home/home.dart';
import 'package:petitpotopro/features/onboard/page/onboard.dart';

class SplashScreen extends StatefulWidget {
  static const route = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /// Durée minimale d'affichage du logo (avant : 3 s fixes).
  static const _minDuration = Duration(milliseconds: 1500);

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    final bloc = context.read<AuthBloc>();
    final minDelay = Future<void>.delayed(_minDuration);

    // Restauration de session 100 % locale : aucun appel réseau au démarrage.
    if (bloc.state.status == AuthStatus.unknown) {
      bloc.add(const AuthStarted());
      await bloc.stream.firstWhere((s) => s.status != AuthStatus.unknown);
    }
    await minDelay;

    if (!mounted) return;
    final hasSeenOnboarding = await sl<SecureStorage>().hasSeenOnboarding();
    if (!mounted) return;
    context.go(hasSeenOnboarding ? HomeScreen.route : OnboardingScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Image.asset(
          'assets/images/logo/logo.png',
          width: 180,
          height: 180,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
