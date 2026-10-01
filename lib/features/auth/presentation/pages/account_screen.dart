import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petitpotopro/common/helpers/style.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_event.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_state.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Mon compte')),
    body: BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state.user;
        if (user == null) {
          return const Center(child: Text('Aucun compte connecté.'));
        }
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: ClipOval(
                child: SizedBox.square(
                  dimension: 104,
                  child: user.avatar == null || user.avatar!.isEmpty
                      ? const ColoredBox(
                          color: AppColors.bgColor,
                          child: Icon(
                            Icons.person_outline_rounded,
                            size: 52,
                            color: AppColors.primary,
                          ),
                        )
                      : Image.network(
                          user.avatar!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const ColoredBox(
                            color: AppColors.bgColor,
                            child: Icon(
                              Icons.person_outline_rounded,
                              size: 52,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(child: Text(user.fullName, style: StyleText().title)),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  if (user.email?.isNotEmpty == true)
                    ListTile(
                      leading: const Icon(Icons.email_outlined),
                      title: Text(user.email!, style: StyleText().body),
                    ),
                  if (user.phone?.isNotEmpty == true)
                    ListTile(
                      leading: const Icon(Icons.phone_outlined),
                      title: Text(user.phone!, style: StyleText().body),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () =>
                  context.read<AuthBloc>().add(AuthLogoutRequested()),
              icon: const Icon(Icons.logout_rounded),
              label: Text('Se déconnecter', style: StyleText().link),
            ),
          ],
        );
      },
    ),
  );
}
