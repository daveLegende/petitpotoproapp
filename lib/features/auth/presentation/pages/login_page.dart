import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:petitpotopro/common/widgets/button/button.dart';
import 'package:petitpotopro/common/widgets/fields/textfiel.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_event.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_state.dart';
import 'package:petitpotopro/features/auth/presentation/pages/register_page.dart';
import 'package:petitpotopro/features/auth/presentation/widgets/auth_ui.dart';

class LoginPage extends StatefulWidget {
  static const route = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  String? _localError;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    final identifier = _identifier.text.trim();
    final password = _password.text;

    if (identifier.isEmpty || password.isEmpty) {
      setState(
        () => _localError =
            'Veuillez renseigner votre identifiant et votre mot de passe.',
      );
      return;
    }

    setState(() => _localError = null);
    FocusScope.of(context).unfocus();
    context.read<AuthBloc>().add(
      AuthLoginSubmitted(identifier: identifier, password: password),
    );
    // Pas de navigation ici : le routeur redirige dès que l'état devient "authenticated".
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status && curr.status == AuthStatus.failure,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(state.errorMessage ?? 'Une erreur est survenue.'),
              backgroundColor: AppColors.error,
            ),
          );
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: kAuthMaxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AuthHeader(
                      icon: Icons.sports_soccer_rounded,
                      title: 'Connexion',
                      subtitle:
                          'Connectez-vous avec votre email ou votre numéro de téléphone.',
                    ),
                    const SizedBox(height: 32),
                    CustomTextField(
                      controller: _identifier,
                      hintText: 'Email ou téléphone',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _password,
                      hintText: 'Mot de passe',
                      obscureText: _obscure,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        tooltip: _obscure
                            ? 'Afficher le mot de passe'
                            : 'Masquer le mot de passe',
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    AuthErrorBanner(message: _localError),
                    const SizedBox(height: 24),
                    // Seul le bouton se reconstruit quand le statut change.
                    BlocSelector<AuthBloc, AuthState, bool>(
                      selector: (state) => state.status == AuthStatus.loading,
                      builder: (context, loading) => loading
                          ? const LoadingButton()
                          : CustomButton(
                              text: 'Se connecter',
                              onPressed: _submit,
                            ),
                    ),
                    const SizedBox(height: 24),
                    AuthLinkRow(
                      text: 'Pas encore de compte ?',
                      action: 'Créer un compte',
                      onTap: () => context.push(RegisterPage.route),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}