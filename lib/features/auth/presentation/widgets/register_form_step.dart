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
        Text('Vos informations', style: style.title),
        const SizedBox(height: 8),
        Text('Dernière étape avant de créer votre compte.', style: style.desc),
        const SizedBox(height: 24),
        const SizedBox(height: 24),
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
          hintText: _contact.isEmail ? 'Adresse email' : 'Adresse email (facultatif)',
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
        Text('Sexe (facultatif)', style: style.caption),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Homme'),
              selected: _gender == Gender.male,
              onSelected: (on) =>
                  setState(() => _gender = on ? Gender.male : null),
            ),
            ChoiceChip(
              label: const Text('Femme'),
              selected: _gender == Gender.female,
              onSelected: (on) =>
                  setState(() => _gender = on ? Gender.female : null),
            ),
          ],
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
        const SizedBox(height: 16),
        CustomTextField(
          controller: _confirm,
          hintText: 'Confirmer le mot de passe',
          obscureText: _obscure,
          prefixIcon: const Icon(Icons.lock_outline),
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
              : CustomButton(text: 'Créer mon compte', onPressed: _submit),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
