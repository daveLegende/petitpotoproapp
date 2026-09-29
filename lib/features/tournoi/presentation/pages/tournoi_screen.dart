import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petitpotopro/common/helpers/style.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';
import 'package:petitpotopro/core/di/service_locator.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_event.dart';
import 'package:petitpotopro/features/tournoi/presentation/cubit/tournoi_cubit.dart';
import 'package:petitpotopro/features/tournoi/presentation/cubit/tournoi_state.dart';
import 'package:petitpotopro/features/tournoi/presentation/widgets/tournament_card.dart';

class TournoiScreen extends StatefulWidget {
  static const route = '/tournoi';
  const TournoiScreen({super.key});

  @override
  State<TournoiScreen> createState() => _TournoiScreenState();
}

class _TournoiScreenState extends State<TournoiScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TournoiCubit>(
      create: (_) => sl<TournoiCubit>()..getAll(),
      child: BlocBuilder<TournoiCubit, TournoiState>(
        builder: (context, state) {
          final query = _query.toLowerCase();
          final filteredTournaments = state.tournois.where((tournament) {
            return tournament.name.toLowerCase().contains(query) ||
                tournament.editionName.toLowerCase().contains(query) ||
                (tournament.organization?.name.toLowerCase().contains(query) ??
                    false) ||
                tournament.status.toLowerCase().contains(query);
          }).toList();

          return Scaffold(
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                            child: Image.asset(
                              'assets/images/logo/logo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bonjour, passionne de foot',
                                  style: StyleText().caption,
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Les tournois du moment',
                                  style: StyleText().subtitle,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                AuthLogoutRequested(),
                              );
                            },
                            tooltip: 'Notifications',
                            icon: const Icon(Icons.notifications_none_rounded),
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.white,
                              foregroundColor: AppColors.neutral,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                    sliver: SliverToBoxAdapter(
                      child: TextField(
                        controller: _searchController,
                        style: StyleText().body,
                        onChanged: (value) =>
                            setState(() => _query = value.trim()),
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: 'Rechercher un tournoi',
                          hintStyle: StyleText().body,
                          prefixIcon: Icon(Icons.search_rounded),
                          suffixIcon: Icon(Icons.tune_rounded),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tournois populaires',
                            style: StyleText().headBlack,
                          ),
                          Text(
                            state.isLoading && state.tournois.isEmpty
                                ? 'Chargement...'
                                : '${filteredTournaments.length} resultats',
                            style: StyleText().caption,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.isLoading && state.tournois.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.errorMessage != null && state.tournois.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(state.errorMessage!, style: StyleText().desc),
                            const SizedBox(height: 12),
                            TextButton.icon(
                              onPressed: context.read<TournoiCubit>().getAll,
                              icon: const Icon(Icons.refresh_rounded),
                              label: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (filteredTournaments.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'Aucun tournoi trouve',
                          style: StyleText().desc,
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      sliver: SliverList.builder(
                        itemCount: filteredTournaments.length,
                        itemBuilder: (context, index) => TournamentCard(
                          tournament: filteredTournaments[index],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
