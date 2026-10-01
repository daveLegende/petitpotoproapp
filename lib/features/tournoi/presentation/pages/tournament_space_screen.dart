import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petitpotopro/common/helpers/style.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';
import 'package:petitpotopro/core/di/service_locator.dart';
import 'package:petitpotopro/features/matchs/presentation/pages/calendar_matches_screen.dart';
import 'package:petitpotopro/features/tournoi/domain/entities/tournoi_entity.dart';
import 'package:petitpotopro/features/tournoi/presentation/cubit/tournoi_cubit.dart';
import 'package:petitpotopro/features/tournoi/presentation/cubit/tournoi_state.dart';

class TournamentSpaceScreen extends StatelessWidget {
  const TournamentSpaceScreen({super.key, required this.tournoiId});

  final String tournoiId;

  @override
  Widget build(BuildContext context) => BlocProvider<TournoiCubit>(
    create: (_) => sl<TournoiCubit>()..getAll(),
    child: _TournamentSpaceView(tournoiId: tournoiId),
  );
}

class _TournamentSpaceView extends StatelessWidget {
  const _TournamentSpaceView({required this.tournoiId});

  final String tournoiId;

  @override
  Widget build(BuildContext context) => BlocBuilder<TournoiCubit, TournoiState>(
    builder: (context, state) {
      TournoiEntity? tournament;
      for (final item in state.tournois) {
        if (item.id == tournoiId) {
          tournament = item;
          break;
        }
      }

      final title = tournament?.name ?? 'Espace tournoi';
      return Scaffold(
        appBar: AppBar(
          title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        body: state.isLoading && tournament == null
            ? const Center(child: CircularProgressIndicator())
            : state.errorMessage != null && tournament == null
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.errorMessage!, textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: context.read<TournoiCubit>().getAll,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Réessayer'),
                    ),
                  ],
                ),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  if (tournament != null) ...[
                    Text(
                      tournament.editionName,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${tournament.status} · ${tournament.annee.year}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                  ],
                  ..._sections.map(
                    (section) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: Icon(section.icon, color: AppColors.primary),
                        title: Text(section.title),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () {
                          if (section.title == 'Calendrier des matchs') {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    CalendarMatchesScreen(tournoiId: tournoiId),
                              ),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => _TournamentSectionPage(
                                  title: section.title,
                                  tournament: tournament,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
      );
    },
  );
}

const _sections = [
  (title: 'Infos du tournoi', icon: Icons.info_outline_rounded),
  (title: 'Poules', icon: Icons.table_chart_outlined),
  (title: 'Meilleur buteur', icon: Icons.sports_soccer_rounded),
  (title: 'Meilleur joueur', icon: Icons.star_outline_rounded),
  (title: 'Meilleure équipe', icon: Icons.shield_outlined),
  (title: 'Calendrier des matchs', icon: Icons.calendar_month_outlined),
  (title: 'Calendrier complet', icon: Icons.account_tree_outlined),
];

class _TournamentSectionPage extends StatelessWidget {
  const _TournamentSectionPage({required this.title, required this.tournament});

  final String title;
  final TournoiEntity? tournament;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: switch (title) {
        'Infos du tournoi' => _TournamentInfo(tournament: tournament),
        'Poules' => const _GroupStandings(),
        'Meilleur buteur' => const _Ranking(title: 'Buteurs', rows: _scorers),
        'Meilleur joueur' => const _Ranking(title: 'Joueurs', rows: _players),
        'Meilleure équipe' => const _Ranking(title: 'Équipes', rows: _teams),
        'Calendrier complet' => const _KnockoutBracket(),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

class _TournamentInfo extends StatelessWidget {
  const _TournamentInfo({required this.tournament});

  final TournoiEntity? tournament;

  @override
  Widget build(BuildContext context) {
    final data = tournament;
    if (data == null) {
      return const Center(child: Text('Informations indisponibles.'));
    }
    final details = <String, String>{
      'Édition': data.editionName,
      'Année': '${data.annee.year}',
      'Organisation': data.organization?.name ?? 'Non renseignée',
      'Statut': data.status,
      'Tickets': data.ticketsEnabled ? 'Disponibles' : 'Indisponibles',
      'Paris': data.bettingEnabled ? 'Disponibles' : 'Indisponibles',
    };
    return ListView(
      padding: const EdgeInsets.all(20),
      children: details.entries
          .map(
            (entry) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(entry.key),
              trailing: Text(
                entry.value,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          )
          .toList(),
    );
  }
}

class _GroupStandings extends StatelessWidget {
  const _GroupStandings();

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: const [
      _StandingsTable(group: 'Groupe A'),
      SizedBox(height: 20),
      _StandingsTable(group: 'Groupe B'),
    ],
  );
}

class _StandingsTable extends StatelessWidget {
  const _StandingsTable({required this.group});

  final String group;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(group, style: Theme.of(context).textTheme.titleMedium),
      const SizedBox(height: 8),
      Table(
        columnWidths: const {0: FlexColumnWidth(2.8)},
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          _tableRow([
            'Équipe',
            'J',
            'G',
            'N',
            'P',
            'Diff',
            'Pts',
          ], header: true),
          _tableRow(['Union FC', '3', '2', '1', '0', '+4', '7']),
          _tableRow(['Racing Club', '3', '2', '0', '1', '+2', '6']),
          _tableRow(['Étoile Sport', '3', '1', '0', '2', '-1', '3']),
          _tableRow(['AS Locale', '3', '0', '1', '2', '-5', '1']),
        ],
      ),
    ],
  );
}

TableRow _tableRow(List<String> cells, {bool header = false}) => TableRow(
  decoration: BoxDecoration(color: header ? AppColors.lightBackground : null),
  children: cells
      .map(
        (cell) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
          child: Text(
            cell,
            textAlign: cell == cells.first ? TextAlign.left : TextAlign.center,
            style: (header ? StyleText().captionBold : StyleText().caption)
                .copyWith(fontSize: 11),
          ),
        ),
      )
      .toList(),
);

const _scorers = [
  ('Moussa Diallo', 'Union FC', '5 buts'),
  ('Karim Traoré', 'Racing Club', '4 buts'),
  ('Issa Koné', 'Étoile Sport', '3 buts'),
];
const _players = [
  ('Moussa Diallo', 'Union FC', '8.7'),
  ('Karim Traoré', 'Racing Club', '8.4'),
  ('Amadou Sissoko', 'AS Locale', '8.1'),
];
const _teams = [
  ('Union FC', '7 pts', '1er'),
  ('Racing Club', '6 pts', '2e'),
  ('Étoile Sport', '3 pts', '3e'),
];

class _Ranking extends StatelessWidget {
  const _Ranking({required this.title, required this.rows});

  final String title;
  final List<(String, String, String)> rows;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Text(title, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 12),
      ...rows.indexed.map(
        (entry) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(child: Text('${entry.$1 + 1}')),
            title: Text(entry.$2.$1),
            subtitle: Text(entry.$2.$2),
            trailing: Text(
              entry.$2.$3,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
      ),
    ],
  );
}

class _KnockoutBracket extends StatelessWidget {
  const _KnockoutBracket();

  static const _rounds = [
    ('Huitièmes', ['Union FC', 'Racing Club', 'Étoile Sport', 'AS Locale']),
    ('Quarts', ['Union FC', 'Racing Club']),
    ('Demi-finales', ['À déterminer']),
    ('Finale', ['À déterminer']),
  ];

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: _rounds
          .map(
            (round) => SizedBox(
              width: 190,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      round.$1,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 20),
                    ...round.$2.map(
                      (team) => Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          dense: true,
                          title: Text(team),
                          subtitle: const Text('À jouer'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    ),
  );
}
