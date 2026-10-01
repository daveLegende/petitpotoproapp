import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petitpotopro/common/helpers/constant.dart';
import 'package:petitpotopro/common/helpers/style.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';
import 'package:petitpotopro/core/di/service_locator.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_state.dart';
import 'package:petitpotopro/features/auth/presentation/pages/account_screen.dart';
import 'package:petitpotopro/features/tournoi/presentation/cubit/tournoi_cubit.dart';
import 'package:petitpotopro/features/tournoi/presentation/cubit/tournoi_state.dart';
import 'package:petitpotopro/features/tournoi/presentation/widgets/tournament_card.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _adController = PageController(viewportFraction: 0.92);
  Timer? _searchDebounce;
  Timer? _adTimer;
  String _query = '';
  int _adIndex = 0;

  static const _ads = [
    ('Vivez chaque match', 'Suivez les scores et les temps forts en direct.'),
    ('Le tournoi continue ici', 'Retrouvez calendrier, équipes et classement.'),
    ('Tous ensemble au stade', 'Préparez votre prochaine journée de football.'),
  ];

  @override
  void initState() {
    super.initState();
    _adTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_adController.hasClients) return;
      final next = (_adIndex + 1) % _ads.length;
      _adController.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _adTimer?.cancel();
    _adController.dispose();
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
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, authState) => Row(
                          children: [
                            // Container(
                            //   width: 45,
                            //   height: 45,
                            //   padding: const EdgeInsets.all(9),
                            //   decoration: BoxDecoration(
                            //     color: AppColors.white,
                            //     borderRadius: BorderRadius.circular(10),
                            //     border: Border.all(
                            //       color: AppColors.primary,
                            //       width: 1.5,
                            //     ),
                            //   ),
                            //   child: Image.asset(
                            //     'assets/images/logo/logo.png',
                            //     fit: BoxFit.contain,
                            //   ),
                            // ),
                            // const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Retrouvez vos tournois favoris ici',
                                    style: StyleText().caption,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Bienvenue sur Petitpoto.pro',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: StyleText().subtitle.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (authState.isAuthenticated &&
                                authState.user != null) ...[
                              const SizedBox(width: 8),
                              _BalanceButton(balance: authState.user!.balance),
                              const SizedBox(width: 8),
                              _AccountAvatar(
                                imageUrl: authState.user!.avatar,
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const AccountScreen(),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
                    sliver: SliverToBoxAdapter(
                      child: TextField(
                        controller: _searchController,
                        style: StyleText().body,
                        onChanged: (value) {
                          _searchDebounce?.cancel();
                          _searchDebounce = Timer(
                            const Duration(milliseconds: 300),
                            () {
                              if (mounted) {
                                setState(() => _query = value.trim());
                              }
                            },
                          );
                        },
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: 'Rechercher un tournoi',
                          hintStyle: StyleText().body.copyWith(
                            color: AppColors.neutral.withValues(alpha: 0.5),
                          ),
                          prefixIcon: Icon(Icons.search_rounded),
                          suffixIcon: Icon(Icons.tune_rounded),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 142,
                            child: PageView.builder(
                              controller: _adController,
                              itemCount: _ads.length,
                              onPageChanged: (index) =>
                                  setState(() => _adIndex = index),
                              itemBuilder: (context, index) => AdBanner(
                                title: _ads[index].$1,
                                description: _ads[index].$2,
                                index: index,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _ads.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                width: _adIndex == index ? 18 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: _adIndex == index
                                      ? AppColors.primary
                                      : AppColors.grey.withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ],
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
                            style: StyleText().title.copyWith(fontSize: 18),
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
                              label: Text(
                                'Réessayer',
                                style: StyleText().button,
                              ),
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
                        itemBuilder: (context, index) {
                          final tournament = filteredTournaments[index];
                          return TournamentCard(tournament: tournament);
                        },
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

class AdBanner extends StatelessWidget {
  const AdBanner({
    super.key,
    required this.title,
    required this.description,
    required this.index,
  });

  final String title;
  final String description;
  final int index;

  static const _colors = [
    Color(0xFF174D3B),
    Color(0xFF245D73),
    Color(0xFF9A542B),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _colors[index % _colors.length],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: StyleText().headWhite.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: StyleText().body.copyWith(
                    color: mwhite.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.sports_soccer_rounded,
            color: Colors.white,
            size: 42,
          ),
        ],
      ),
    );
  }
}

class _BalanceButton extends StatelessWidget {
  const _BalanceButton({required this.balance});

  final num? balance;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(10, 6, 7, 6),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(color: AppColors.primary),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          balance == null ? '0 cfa' : "$balance cfa",
          style: StyleText().captionBold,
        ),
        const SizedBox(width: 7),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary),
          ),
          child: const Icon(
            Icons.add_rounded,
            color: AppColors.primary,
            size: 18,
          ),
        ),
      ],
    ),
  );
}

class _AccountAvatar extends StatelessWidget {
  const _AccountAvatar({required this.imageUrl, required this.onPressed});

  final String? imageUrl;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed,
    tooltip: 'Mon compte',
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints.tightFor(width: 42, height: 42),
    icon: ClipOval(
      child: SizedBox.square(
        dimension: 38,
        child: imageUrl == null || imageUrl!.isEmpty
            ? const ColoredBox(
                color: AppColors.bgColor,
                child: Icon(Icons.person_rounded, color: AppColors.primary),
              )
            : Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const ColoredBox(
                  color: AppColors.bgColor,
                  child: Icon(Icons.person_rounded, color: AppColors.primary),
                ),
              ),
      ),
    ),
  );
}
