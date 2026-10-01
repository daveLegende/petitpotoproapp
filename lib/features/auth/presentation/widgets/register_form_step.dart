import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petitpotopro/common/helpers/style.dart';
import 'package:petitpotopro/common/widgets/button/button.dart';
import 'package:petitpotopro/common/widgets/fields/textfiel.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';
import 'package:petitpotopro/core/utils/validators.dart';
import 'package:petitpotopro/features/auth/domain/entities/otp_contact.dart';
import 'package:petitpotopro/features/auth/domain/entities/register_data.dart';
import 'package:petitpotopro/features/auth/presentation/cubit/register_cubit.dart';
import 'package:petitpotopro/features/auth/presentation/cubit/register_state.dart';
import 'package:petitpotopro/features/auth/presentation/widgets/auth_ui.dart';

/// Étape 3 : formulaire d'inscription.
/// Le contact déjà vérifié (téléphone OU email) est affiché verrouillé ;
/// l'autre est à saisir (téléphone obligatoire, email facultatif).
class RegisterFormStep extends StatefulWidget {
  const RegisterFormStep({super.key});

  @override
  State<RegisterFormStep> createState() => _RegisterFormStepState();
}

class _RegisterFormStepState extends State<RegisterFormStep> {
  final _firstname = TextEditingController();
  final _lastname = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _country = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  // Toujours non null ici : on n'arrive à cette étape qu'après un code validé.
  late final OtpContact _contact;

  Gender? _gender;
  bool _obscure = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _contact = context.read<RegisterCubit>().state.contact!;
    if (_contact.isEmail) {
      _email.text = _contact.value;
    } else {
      _phone.text = _contact.value;
    }
  }

  @override
  void dispose() {
    for (final c in [
      _firstname,
      _lastname,
      _phone,
      _email,
      _country,
      _password,
      _confirm,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Renvoie le premier message d'erreur, ou null si tout est bon.
  String? _validate() {
    if (_firstname.text.trim().isEmpty) return 'Le prénom est obligatoire.';
    if (_lastname.text.trim().isEmpty) return 'Le nom est obligatoire.';

    if (_contact.isEmail) {
      final phoneError = Validators.phone(_phone.text);
      if (phoneError != null) return phoneError;
    } else if (_email.text.trim().isNotEmpty) {
      final emailError = Validators.email(_email.text);
      if (emailError != null) return emailError;
    }

    if (_country.text.trim().isEmpty) return 'Le pays est obligatoire.';

    final passwordError = Validators.password(_password.text);
    if (passwordError != null) return passwordError;
    if (_password.text != _confirm.text) {
      return 'Les mots de passe ne correspondent pas.';
    }
    return null;
  }

  void _submit() {
    final error = _validate();
    setState(() => _error = error);
    if (error != null) return;

    FocusScope.of(context).unfocus();
    final email = _email.text.trim();

    context.read<RegisterCubit>().submit(
      RegisterData(
        firstname: _firstname.text.trim(),
        lastname: _lastname.text.trim(),
        phone: Validators.normalizePhone(_phone.text),
        email: email.isEmpty ? null : email,
        country: _country.text.trim(),
        gender: _gender,
        password: _password.text,
      ),
    );
  }

  Widget _verifiedIcon() =>
      const Icon(Icons.verified, color: AppColors.success);

  @override
  Widget build(BuildContext context) {
    final style = StyleText();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const AuthHeader(
          icon: Icons.badge_outlined,
          title: 'Vos informations',
          subtitle: 'Dernière étape avant de créer votre compte.',
        ),
        const SizedBox(height: 28),

        const AuthSectionLabel('Identité'),
        CustomTextField(
          controller: _firstname,
          hintText: 'Prénom',
          textCapitalization: TextCapitalization.words,
          prefixIcon: const Icon(Icons.person_outline),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _lastname,
          hintText: 'Nom',
          textCapitalization: TextCapitalization.words,
          prefixIcon: const Icon(Icons.person_outline),
        ),
        const SizedBox(height: 16),
        Text('Sexe (facultatif)', style: style.caption),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<Gender>(
            emptySelectionAllowed: true,
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: Gender.male, label: Text('Homme')),
              ButtonSegment(value: Gender.female, label: Text('Femme')),
            ],
            selected: {if (_gender != null) _gender!},
            onSelectionChanged: (s) =>
                setState(() => _gender = s.isEmpty ? null : s.first),
          ),
        ),

        const SizedBox(height: 16),
        const AuthSectionLabel('Contact'),
        CustomTextField(
          controller: _phone,
          hintText: 'Téléphone (avec indicatif)',
          keyboardType: TextInputType.phone,
          enabled: _contact.isEmail, // verrouillé s'il vient d'être vérifié
          prefixIcon: const Icon(Icons.phone_outlined),
          suffixIcon: _contact.isEmail ? null : _verifiedIcon(),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _email,
          hintText: _contact.isEmail
              ? 'Adresse email'
              : 'Adresse email (facultatif)',
          keyboardType: TextInputType.emailAddress,
          enabled: !_contact.isEmail,
          prefixIcon: const Icon(Icons.email_outlined),
          suffixIcon: _contact.isEmail ? _verifiedIcon() : null,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _country,
          hintText: 'Pays',
          textCapitalization: TextCapitalization.words,
          prefixIcon: const Icon(Icons.flag_outlined),
        ),

        const SizedBox(height: 16),
        const AuthSectionLabel('Sécurité'),
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
        _PasswordStrength(controller: _password),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _confirm,
          hintText: 'Confirmer le mot de passe',
          obscureText: _obscure,
          prefixIcon: const Icon(Icons.lock_outline),
        ),

        AuthErrorBanner(message: _error),
        const SizedBox(height: 24),
        BlocSelector<RegisterCubit, RegisterState, bool>(
          selector: (state) => state.isLoading,
          builder: (context, loading) => loading
              ? const LoadingButton()
              : CustomButton(text: 'Créer mon compte', onPressed: _submit),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

/// Indicateur visuel de robustesse. Purement informatif : la validation
/// reste celle de [Validators.password].
class _PasswordStrength extends StatelessWidget {
  const _PasswordStrength({required this.controller});

  final TextEditingController controller;

  int _score(String value) {
    var score = 0;
    if (value.length >= 8) score++;
    if (RegExp(r'[a-z]').hasMatch(value) && RegExp(r'[A-Z]').hasMatch(value)) {
      score++;
    }
    if (RegExp(r'\d').hasMatch(value)) score++;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, __) {
        if (value.text.isEmpty) return const SizedBox.shrink();

        final score = _score(value.text);
        final (label, color) = switch (score) {
          <= 1 => ('Faible', AppColors.error),
          2 => ('Moyen', Colors.orange),
          _ => ('Fort', AppColors.success),
        };

        return Padding(
          padding: const EdgeInsets.only(top: 10, left: 2),
          child: Row(
            children: [
              for (var i = 0; i < 3; i++) ...[
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 4,
                    decoration: BoxDecoration(
                      color: i < (score == 0 ? 1 : score)
                          ? color
                          : color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (i < 2) const SizedBox(width: 6),
              ],
              const SizedBox(width: 12),
              Text(label, style: StyleText().caption.copyWith(color: color)),
            ],
          ),
        );
      },
    );
  }
}