import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:petitpotopro/common/helpers/style.dart';
import 'package:petitpotopro/common/widgets/button/button.dart';
import 'package:petitpotopro/common/widgets/fields/textfiel.dart';
import 'package:petitpotopro/core/enum/login.dart';
import 'package:petitpotopro/core/utils/validators.dart';
import 'package:petitpotopro/features/auth/domain/entities/otp_contact.dart';
import 'package:petitpotopro/features/auth/presentation/cubit/register_cubit.dart';
import 'package:petitpotopro/features/auth/presentation/cubit/register_state.dart';
import 'package:petitpotopro/features/auth/presentation/pages/login_page.dart';
import 'package:petitpotopro/features/auth/presentation/widgets/auth_ui.dart';

/// Étape 1 : saisie du téléphone ou de l'email, puis envoi du code.
class RegisterContactStep extends StatefulWidget {
  const RegisterContactStep({super.key});

  @override
  State<RegisterContactStep> createState() => _RegisterContactStepState();
}

class _RegisterContactStepState extends State<RegisterContactStep> {
  final _input = TextEditingController();
  LoginMode _mode = LoginMode.phone;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Retour depuis l'étape "code" : on remet ce que l'utilisateur avait saisi.
    final previous = context.read<RegisterCubit>().state.contact;
    if (previous != null) {
      _mode = previous.isEmail ? LoginMode.email : LoginMode.phone;
      _input.text = previous.value;
    }
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _submit() {
    final raw = _input.text.trim();
    final isPhone = _mode == LoginMode.phone;

    final error = isPhone ? Validators.phone(raw) : Validators.email(raw);
    if (error != null) {
      setState(() => _error = error);
      return;
    }

    setState(() => _error = null);
    FocusScope.of(context).unfocus();
    context.read<RegisterCubit>().sendCode(
      isPhone
          ? OtpContact.phone(Validators.normalizePhone(raw))
          : OtpContact.email(raw),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = StyleText();
    final isPhone = _mode == LoginMode.phone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        AuthHeader(
          icon: Icons.person_add_alt_1_rounded,
          title: 'Créer un compte',
          subtitle:
              'Nous allons vous envoyer un code pour vérifier votre '
              '${isPhone ? 'numéro de téléphone' : 'adresse email'}.',
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<LoginMode>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: LoginMode.phone,
                label: Text('Téléphone'),
                icon: Icon(Icons.phone_outlined),
              ),
              ButtonSegment(
                value: LoginMode.email,
                label: Text('Email'),
                icon: Icon(Icons.email_outlined),
              ),
            ],
            selected: {_mode},
            onSelectionChanged: (selection) => setState(() {
              _mode = selection.first;
              _input.clear();
              _error = null;
            }),
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _input,
          hintText: isPhone ? 'Téléphone (avec indicatif)' : 'Adresse email',
          keyboardType: isPhone
              ? TextInputType.phone
              : TextInputType.emailAddress,
          prefixIcon: Icon(
            isPhone ? Icons.phone_outlined : Icons.email_outlined,
          ),
        ),
        if (isPhone)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text('Exemple : +228 90 12 34 56', style: style.caption),
          ),
        AuthErrorBanner(message: _error),
        const SizedBox(height: 24),
        BlocSelector<RegisterCubit, RegisterState, bool>(
          selector: (state) => state.isLoading,
          builder: (context, loading) => loading
              ? const LoadingButton()
              : CustomButton(text: 'Recevoir le code', onPressed: _submit),
        ),
        const SizedBox(height: 24),
        AuthLinkRow(
          text: 'Déjà un compte ?',
          action: 'Se connecter',
          onTap: () => context.go(LoginPage.route),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}