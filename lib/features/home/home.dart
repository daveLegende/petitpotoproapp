import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:petitpotopro/common/helpers/style.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';
import 'package:petitpotopro/core/di/service_locator.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_event.dart';
import 'package:petitpotopro/features/tournoi/domain/entities/tournoi_entity.dart';
import 'package:petitpotopro/features/tournoi/presentation/cubit/tournoi_cubit.dart';
import 'package:petitpotopro/features/tournoi/presentation/cubit/tournoi_state.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                        onChanged: (value) =>
                            setState(() => _query = value.trim()),
                        textInputAction: TextInputAction.search,
                        decoration: const InputDecoration(
                          hintText: 'Rechercher un tournoi',
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
                        itemBuilder: (context, index) => _TournamentCard(
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

class _TournamentCard extends StatelessWidget {
  final TournoiEntity tournament;

  const _TournamentCard({required this.tournament});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: AppColors.neutral.withValues(alpha: 0.12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 156,
                width: double.infinity,
                child: ColoredBox(
                  color: AppColors.primary,
                  child: tournament.organization?.logo == null ? Center(
                    child: Icon(
                      Icons.emoji_events_rounded,
                      size: 72,
                      color: AppColors.white.withValues(alpha: 0.8),
                    ),
                  ) : SvgPicture.network(
                    tournament.organization?.logo ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(
                        Icons.emoji_events_rounded,
                        size: 72,
                        color: AppColors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.neutral.withValues(alpha: 0.84),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tournament.status,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tournament.name, style: StyleText().subtitle),
                const SizedBox(height: 7),
                Text(
                  tournament.editionName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: StyleText().desc,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(
                      Icons.sports_soccer_rounded,
                      size: 17,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        tournament.organization?.name ??
                            'Édition ${tournament.edition}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: StyleText().captionBold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
