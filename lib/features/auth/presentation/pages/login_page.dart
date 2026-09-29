import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:petitpotopro/common/helpers/style.dart';
import 'package:petitpotopro/common/widgets/button/button.dart';
import 'package:petitpotopro/common/widgets/fields/textfiel.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_event.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_state.dart';
import 'package:petitpotopro/features/auth/presentation/pages/register_page.dart';

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
      setState(() => _localError =
          'Veuillez renseigner votre identifiant et votre mot de passe.');
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
    final style = StyleText();

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status && curr.status == AuthStatus.failure,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Une erreur est survenue.'),
              backgroundColor: AppColors.error,
            ),
          );
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                Text('Connexion', style: style.title),
                const SizedBox(height: 8),
                Text(
                  'Connectez-vous avec votre email ou votre numéro de téléphone.',
                  style: style.desc,
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
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                if (_localError != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _localError!,
                    style: style.caption.copyWith(color: AppColors.error),
                  ),
                ],
                const SizedBox(height: 24),
                // Seul le bouton se reconstruit quand le statut change.
                BlocSelector<AuthBloc, AuthState, bool>(
                  selector: (state) => state.status == AuthStatus.loading,
                  builder: (context, loading) => loading
                      ? const LoadingButton()
                      : CustomButton(text: 'Se connecter', onPressed: _submit),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => context.push(RegisterPage.route),
                    child: Text(
                      'Pas encore de compte ? Créer un compte',
                      style: style.link,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
