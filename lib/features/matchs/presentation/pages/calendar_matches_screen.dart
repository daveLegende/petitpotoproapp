import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:petitpotopro/core/di/service_locator.dart';
import 'package:petitpotopro/features/matchs/domain/entities/match_entity.dart';
import 'package:petitpotopro/features/matchs/presentation/cubit/match_cubit.dart';
import 'package:petitpotopro/features/matchs/presentation/cubit/match_state.dart';
import 'package:petitpotopro/features/matchs/presentation/pages/match_detail_screen.dart';

class CalendarMatchesScreen extends StatelessWidget {
  const CalendarMatchesScreen({super.key, required this.tournoiId});

  final String tournoiId;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => sl<MatchCubit>()..getAll(tournoiId),
    child: _CalendarMatchesView(tournoiId: tournoiId),
  );
}

class _CalendarMatchesView extends StatelessWidget {
  const _CalendarMatchesView({required this.tournoiId});

  final String tournoiId;

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Calendrier des matchs'),
        bottom: const TabBar(
          tabs: [
            Tab(text: 'À venir'),
            Tab(text: 'Terminés'),
          ],
        ),
      ),
      body: BlocBuilder<MatchCubit, MatchState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null) {
            return Center(child: Text(state.errorMessage!));
          }
          return TabBarView(
            children: [
              _MatchList(
                matches: _byDate(state.matches, upcoming: true),
                tournoiId: tournoiId,
              ),
              _MatchList(
                matches: _byDate(state.matches, upcoming: false),
                tournoiId: tournoiId,
              ),
            ],
          );
        },
      ),
    ),
  );

  List<MatchEntity> _byDate(
    List<MatchEntity> matches, {
    required bool upcoming,
  }) {
    final now = DateTime.now();
    final filtered = matches
        .where(
          (match) =>
              upcoming ? match.date.isAfter(now) : !match.date.isAfter(now),
        )
        .toList();
    filtered.sort(
      (a, b) => upcoming ? a.date.compareTo(b.date) : b.date.compareTo(a.date),
    );
    return filtered;
  }
}

class _MatchList extends StatelessWidget {
  const _MatchList({required this.matches, required this.tournoiId});

  final List<MatchEntity> matches;
  final String tournoiId;

  @override
  Widget build(BuildContext context) {
    if (matches.isEmpty) {
      return const Center(child: Text('Aucun match dans cette catégorie.'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: matches.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final match = matches[index];
        return Card(
          child: ListTile(
            title: Text(
              '${match.home.name}  ${match.scores.home} - ${match.scores.away}  ${match.away.name}',
            ),
            subtitle: Text(
              '${DateFormat('EEE d MMM · HH:mm', 'fr_FR').format(match.date.toLocal())} · ${match.lieu}',
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    MatchDetailScreen(match: match, tournoiId: tournoiId),
              ),
            ),
          ),
        );
      },
    );
  }
}
