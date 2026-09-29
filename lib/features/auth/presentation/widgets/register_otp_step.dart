import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petitpotopro/common/helpers/style.dart';
import 'package:petitpotopro/common/widgets/button/button.dart';
import 'package:petitpotopro/common/widgets/fields/textfiel.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';
import 'package:petitpotopro/features/auth/presentation/cubit/register_cubit.dart';
import 'package:petitpotopro/features/auth/presentation/cubit/register_state.dart';

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

  @override
  Widget build(BuildContext context) {
    final style = StyleText();
    final contact = context.read<RegisterCubit>().state.contact;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Text('Vérification', style: style.title),
        const SizedBox(height: 8),
        Text(
          'Un code a été envoyé à ${contact?.value ?? ''}.',
          style: style.desc,
        ),
        const SizedBox(height: 24),
        CustomTextField(
          controller: _code,
          hintText: 'Code',
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: _maxLength,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          prefixIcon: const Icon(Icons.pin_outlined),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(_error!, style: style.caption.copyWith(color: AppColors.error)),
        ],
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
                ? Text('Renvoyer le code dans ${seconds}s', style: style.caption)
                : TextButton(
                    onPressed: () => context.read<RegisterCubit>().resendCode(),
                    child: Text('Renvoyer le code', style: style.link),
                  ),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () => context.read<RegisterCubit>().backToContact(),
            child: Text(
              contact != null && contact.isEmail
                  ? 'Modifier l\'adresse email'
                  : 'Modifier le numéro',
              style: style.link,
            ),
          ),
        ),
      ],
    );
  }
}
