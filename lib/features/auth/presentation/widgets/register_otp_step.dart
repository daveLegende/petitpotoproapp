import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petitpotopro/common/helpers/style.dart';
import 'package:petitpotopro/common/widgets/button/button.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';
import 'package:petitpotopro/features/auth/presentation/cubit/register_cubit.dart';
import 'package:petitpotopro/features/auth/presentation/cubit/register_state.dart';
import 'package:petitpotopro/features/auth/presentation/widgets/auth_ui.dart';

/// Étape 2 : saisie du code reçu.
class RegisterOtpStep extends StatefulWidget {
  const RegisterOtpStep({super.key});

  @override
  State<RegisterOtpStep> createState() => _RegisterOtpStepState();
}

class _RegisterOtpStepState extends State<RegisterOtpStep> {
  /// Longueur minimale acceptée côté client (le serveur reste juge du code).
  static const _minLength = 4;
  static const _maxLength = 6;

  final _code = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _submit() {
    final code = _code.text.trim();
    if (code.length < _minLength) {
      setState(() => _error = 'Saisissez le code reçu.');
      return;
    }
    setState(() => _error = null);
    FocusScope.of(context).unfocus();
    context.read<RegisterCubit>().verifyCode(code);
  }

  String _formatSeconds(int seconds) =>
      '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final style = StyleText();
    final contact = context.read<RegisterCubit>().state.contact;
    final isEmail = contact?.isEmail ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        AuthHeader(
          icon: isEmail
              ? Icons.mark_email_read_outlined
              : Icons.sms_outlined,
          title: 'Vérification',
          subtitle: 'Un code a été envoyé à ${contact?.value ?? ''}.',
          subtitleSpan: TextSpan(
            children: [
              const TextSpan(text: 'Saisissez le code envoyé à '),
              TextSpan(
                text: contact?.value ?? '',
                style: style.desc.copyWith(fontWeight: FontWeight.w700),
              ),
              const TextSpan(text: '.'),
            ],
          ),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: _code,
          autofocus: true,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: _maxLength,
          autofillHints: const [AutofillHints.oneTimeCode],
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: style.headBlack.copyWith(fontSize: 28, letterSpacing: 12),
          onChanged: (_) {
            if (_error != null) setState(() => _error = null);
          },
          onSubmitted: (_) => _submit(),
          decoration: InputDecoration(
            counterText: '',
            hintText: '······',
            filled: true,
            fillColor: AppColors.lightBackground,
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
        AuthErrorBanner(message: _error),
        const SizedBox(height: 24),
        BlocSelector<RegisterCubit, RegisterState, bool>(
          selector: (state) => state.isLoading,
          builder: (context, loading) => loading
              ? const LoadingButton()
              : CustomButton(text: 'Vérifier', onPressed: _submit),
        ),
        const SizedBox(height: 16),
        // Seul ce bloc se reconstruit à chaque seconde du compte à rebours.
        Center(
          child: BlocSelector<RegisterCubit, RegisterState, int>(
            selector: (state) => state.resendIn,
            builder: (context, seconds) => seconds > 0
                ? Text(
                    'Renvoyer le code dans ${_formatSeconds(seconds)}',
                    style: style.caption,
                  )
                : AuthLinkRow(
                    text: 'Vous n\'avez rien reçu ?',
                    action: 'Renvoyer le code',
                    onTap: () => context.read<RegisterCubit>().resendCode(),
                  ),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () => context.read<RegisterCubit>().backToContact(),
            child: Text(
              isEmail ? 'Modifier l\'adresse email' : 'Modifier le numéro',
              style: style.link,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}