import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';
import 'package:petitpotopro/core/di/service_locator.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_event.dart';
import 'package:petitpotopro/features/auth/presentation/cubit/register_cubit.dart';
import 'package:petitpotopro/features/auth/presentation/cubit/register_state.dart';
import 'package:petitpotopro/features/auth/presentation/pages/login_page.dart';
import 'package:petitpotopro/features/auth/presentation/widgets/register_contact_step.dart';
import 'package:petitpotopro/features/auth/presentation/widgets/register_form_step.dart';
import 'package:petitpotopro/features/auth/presentation/widgets/register_otp_step.dart';

/// Une seule route, trois étapes : le RegisterCubit décide laquelle afficher.
class RegisterPage extends StatelessWidget {
  static const route = '/register';

  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: (_) => sl<RegisterCubit>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatelessWidget {
  const _RegisterView();

  void _snack(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  void _onState(BuildContext context, RegisterState state) {
    final message = state.errorMessage;
    if (message != null) _snack(context, message, AppColors.error);

    if (state.outcome == RegisterOutcome.signedIn) {
      // Session déjà enregistrée : AuthStarted la relit, puis le routeur
      // redirige tout seul vers l'accueil.
      context.read<AuthBloc>().add(const AuthStarted());
    } else if (state.outcome == RegisterOutcome.needsLogin) {
      _snack(
        context,
        'Compte créé. Connectez-vous pour continuer.',
        AppColors.success,
      );
      context.go(LoginPage.route);
    }
  }

  Widget _stepFor(RegisterStep step) => switch (step) {
        RegisterStep.contact =>
          const RegisterContactStep(key: ValueKey('contact')),
        RegisterStep.otp => const RegisterOtpStep(key: ValueKey('otp')),
        RegisterStep.form => const RegisterFormStep(key: ValueKey('form')),
      };

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listenWhen: (prev, curr) =>
          (curr.errorMessage != null &&
              prev.errorMessage != curr.errorMessage) ||
          (curr.outcome != null && prev.outcome != curr.outcome),
      listener: _onState,
      // Ne se reconstruit que quand l'étape change (pas à chaque seconde du timer).
      child: BlocBuilder<RegisterCubit, RegisterState>(
        buildWhen: (prev, curr) => prev.step != curr.step,
        builder: (context, state) => PopScope(
          // Sur l'étape "code", "retour" ramène à l'étape "contact" au lieu de quitter.
          canPop: state.step != RegisterStep.otp,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) context.read<RegisterCubit>().backToContact();
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: (state.step.index + 1) / RegisterStep.values.length,
                    color: AppColors.primary,
                    backgroundColor: AppColors.lightBackground,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: _stepFor(state.step),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
