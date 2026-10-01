import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:petitpotopro/common/helpers/helper.dart';
import 'package:petitpotopro/common/helpers/style.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';
import 'package:petitpotopro/core/di/service_locator.dart';
import 'package:petitpotopro/features/coupons/domain/entities/coupon_draft.dart';
import 'package:petitpotopro/features/matchs/domain/entities/match_entity.dart';
import 'package:petitpotopro/features/matchs/presentation/cubit/match_cubit.dart';
import 'package:petitpotopro/features/matchs/presentation/cubit/match_state.dart';
import 'package:petitpotopro/features/matchs/presentation/pages/match_detail_screen.dart';
import 'package:petitpotopro/features/team/domain/entities/team_entity.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_state.dart';
import 'package:petitpotopro/features/tournoi/presentation/cubit/tournoi_cubit.dart';
import 'package:petitpotopro/features/tournoi/presentation/cubit/tournoi_state.dart';

/// Barème du classement.
const int _winPoints = 3;
const int _drawPoints = 1;

const _weekdays = [
  'Lundi',
  'Mardi',
  'Mercredi',
  'Jeudi',
  'Vendredi',
  'Samedi',
  'Dimanche',
];
const _months = [
  'janvier',
  'février',
  'mars',
  'avril',
  'mai',
  'juin',
  'juillet',
  'août',
  'septembre',
  'octobre',
  'novembre',
  'décembre',
];

/// « Samedi 10 septembre » (avec l'année si ce n'est pas l'année en cours).
String _longDate(DateTime d) {
  final day = d.day == 1 ? '1er' : '${d.day}';
  final base = '${_weekdays[d.weekday - 1]} $day ${_months[d.month - 1]}';
  return d.year == DateTime.now().year ? base : '$base ${d.year}';
}

/// Poule d'un match, ou null si ce n'est pas un match de poule.
///
/// À ADAPTER à ton entité (ex. `match.poule?.name`). En attendant, on
/// considère qu'un match dont le type contient « poule » est un match de poule
/// et que le type sert de nom (ex. « Poule A »).
String? _poolOf(MatchEntity match) {
  final type = match.type.toString().trim();
  return type.toLowerCase().contains('poule') ? type : null;
}

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key, required this.tournoiId});

  final String tournoiId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MatchCubit>(
          create: (_) => sl<MatchCubit>()..getAll(tournoiId),
        ),
        BlocProvider<TournoiCubit>(create: (_) => sl<TournoiCubit>()..getAll()),
      ],
      child: _MatchListView(tournoiId: tournoiId),
    );
  }
}

/// Les « pages » de l'écran : on change d'onglet sans changer d'écran.
enum _MatchTab { live, calendar, standings }

class _MatchListView extends StatefulWidget {
  const _MatchListView({required this.tournoiId});

  final String tournoiId;

  @override
  State<_MatchListView> createState() => _MatchListViewState();
}

class _MatchListViewState extends State<_MatchListView> {
  _MatchTab _tab = _MatchTab.live;
  final Map<String, _MatchBetSelection> _selections = {};

  /// Jours repliés dans le calendrier (clé « yyyy-MM-dd »). Conservés quand on
  /// change d'onglet ou qu'on rafraîchit.
  final Set<String> _collapsedDays = {};

  String get _tournoiId => widget.tournoiId;

  void _select(_MatchTab tab) => setState(() => _tab = tab);

  Future<void> _addSelection(
    MatchEntity match,
    String betId,
    String category,
    String option,
    double odd,
  ) async {
    final selectionKey = _matchBetSelectionKey(match, category);
    final currentSelection = _selections[selectionKey]?.selection;
    if (currentSelection?.option == option) return;

    if (currentSelection != null) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Modifier la sélection ?'),
          content: Text(
            'Remplacer ${currentSelection.option} '
            '(${currentSelection.odd}) par $option ($odd) pour '
            '${match.home.name} - ${match.away.name} ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Confirmer'),
            ),
          ],
        ),
      );
      if (!mounted || confirmed != true) return;
    }

    final selection = CouponSelection(betId: betId, option: option, odd: odd);
    setState(() {
      _selections[selectionKey] = _MatchBetSelection(
        selection: selection,
        matchLabel: '${match.home.name} - ${match.away.name}',
      );
    });

    final totalOdds = _selections.values.fold<double>(
      1,
      (total, selected) => total * selected.selection.odd.toDouble(),
    );
    final lastSelection = _selections[selectionKey]!;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Helpers().mySnackbar(
      context: context,
      message:
          '${_selections.length} sélection${_selections.length > 1 ? 's' : ''} • '
          'Cote totale ${totalOdds.toStringAsFixed(2)}\n'
          '${lastSelection.matchLabel} • '
          '$option (${odd.toStringAsFixed(2)})',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchCubit, MatchState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroHeader(tournoiId: _tournoiId),
              const Expanded(child: Center(child: CircularProgressIndicator())),
            ],
          );
        }
        if (state.errorMessage != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroHeader(tournoiId: _tournoiId),
              Expanded(
                child: _MessageView(
                  message: state.errorMessage!,
                  action: TextButton.icon(
                    onPressed: () =>
                        context.read<MatchCubit>().getAll(_tournoiId),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Réessayer'),
                  ),
                ),
              ),
            ],
          );
        }
        return _buildLoaded(context, state);
      },
    );
  }

  Widget _buildLoaded(BuildContext context, MatchState state) {
    final summary = _TournamentSummary.from(state.matches);
    final live = state.matches.where(_isLive).toList();
    final upcoming = state.matches.where(_isComming).toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final children = switch (_tab) {
      _MatchTab.live => _liveTab(live, upcoming),
      _MatchTab.calendar => _calendarTab(upcoming),
      _MatchTab.standings => _standingsTab(summary),
    };

    return RefreshIndicator(
      onRefresh: () => context.read<MatchCubit>().getAll(_tournoiId),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _HeroHeader(tournoiId: _tournoiId, summary: summary),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _PinnedBarDelegate(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: _TabBar(
                selected: _tab,
                hasLive: live.isNotEmpty,
                labelFor: (tab) => switch (tab) {
                  _MatchTab.live => 'En direct',
                  _MatchTab.calendar => 'Calendrier matchs',
                  _MatchTab.standings =>
                    summary.hasPools ? 'Poules' : 'Classement',
                },
                onSelected: _select,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 74),
            sliver: SliverList(delegate: SliverChildListDelegate(children)),
          ),
        ],
      ),
    );
  }

  // ── Contenu des onglets ────────────────────────────────────────────────

  /// Matchs en cours + les 2 prochains matchs.
  List<Widget> _liveTab(List<MatchEntity> live, List<MatchEntity> upcoming) {
    if (live.isEmpty && upcoming.isEmpty) {
      return const [
        _EmptyCard(message: 'Aucun match en direct ni à venir pour le moment.'),
      ];
    }
    return [
      if (live.isNotEmpty) ...[
        const _SectionHeader(title: 'En direct', isLive: true),
        ..._cards(live, _MatchKind.live),
      ],
      if (upcoming.isNotEmpty) ...[
        _SectionHeader(
          title: 'Prochains matchs',
          actionLabel: 'Voir plus',
          onAction: () => _select(_MatchTab.calendar),
        ),
        ..._cards(upcoming.take(2).toList(), _MatchKind.upcoming),
      ],
    ];
  }

  /// Matchs à venir regroupés par date, chaque jour est repliable.
  List<Widget> _calendarTab(List<MatchEntity> upcoming) {
    if (upcoming.isEmpty) {
      return const [_EmptyCard(message: 'Aucun match à venir pour le moment.')];
    }

    // `upcoming` est déjà trié : l'ordre d'insertion = ordre chronologique.
    final groups = <String, List<MatchEntity>>{};
    for (final match in upcoming) {
      final key = DateFormat('yyyy-MM-dd').format(match.date.toLocal());
      groups.putIfAbsent(key, () => []).add(match);
    }

    return [
      for (final entry in groups.entries) ...[
        _DateGroupCard(
          key: ValueKey(entry.key),
          date: entry.value.first.date.toLocal(),
          matches: entry.value,
          tournoiId: _tournoiId,
          selections: _selections,
          onOutcomeLongPress: _addSelection,
          expanded: !_collapsedDays.contains(entry.key),
          onToggle: () => setState(() {
            if (!_collapsedDays.remove(entry.key)) {
              _collapsedDays.add(entry.key);
            }
          }),
        ),
        const SizedBox(height: 12),
      ],
    ];
  }

  /// Un classement par poule s'il y a des poules, sinon le classement unique.
  List<Widget> _standingsTab(_TournamentSummary summary) {
    if (summary.hasPools) {
      return [
        for (final entry in summary.pools.entries) ...[
          _SectionHeader(title: entry.key),
          _StandingsCard(standings: entry.value),
          const SizedBox(height: 12),
        ],
      ];
    }
    if (summary.standings.length < 2) {
      return const [
        _EmptyCard(message: 'Le classement sera disponible bientôt.'),
      ];
    }
    return [_StandingsCard(standings: summary.standings)];
  }

  List<Widget> _cards(List<MatchEntity> matches, _MatchKind kind) => [
    for (final match in matches) ...[
      _MatchCard(
        match: match,
        kind: kind,
        tournoiId: _tournoiId,
        selections: _selections,
        onOutcomeLongPress: _addSelection,
      ),
      const SizedBox(height: 12),
    ],
  ];
}

class _MatchBetSelection {
  const _MatchBetSelection({required this.selection, required this.matchLabel});

  final CouponSelection selection;
  final String matchLabel;
}

String _matchBetSelectionKey(MatchEntity match, String category) {
  final normalizedCategory = category
      .trim()
      .replaceAll(RegExp(r'[\s-]+'), '_')
      .toUpperCase();
  return '${match.id}:$normalizedCategory';
}

bool _isLive(MatchEntity match) {
  final status = match.etat.toLowerCase();
  return status.contains('en_cours');
}

bool _isComming(MatchEntity match) {
  final status = match.etat.toLowerCase();
  return status.contains('a_venir');
}

bool _isEnd(MatchEntity match) {
  final status = match.etat.toLowerCase();
  return status.contains('terminer');
}

enum _MatchKind { live, upcoming, finished }

enum _TournamentStatus { upcoming, ongoing, finished }

String _statusLabel(_TournamentStatus status) => switch (status) {
  _TournamentStatus.upcoming => 'À venir',
  _TournamentStatus.ongoing => 'En cours',
  _TournamentStatus.finished => 'Terminé',
};

// ─────────────────────────────────────────────────────────────────────────
// Données dérivées des matchs (aucun appel réseau supplémentaire)
// ─────────────────────────────────────────────────────────────────────────

class _Standing {
  _Standing(this.team);

  final TeamEntity team;
  int played = 0;
  int won = 0;
  int drawn = 0;
  int lost = 0;
  int goalsFor = 0;
  int goalsAgainst = 0;

  int get points => won * _winPoints + drawn * _drawPoints;
  int get diff => goalsFor - goalsAgainst;

  void record(int gf, int ga) {
    played++;
    goalsFor += gf;
    goalsAgainst += ga;
    if (gf > ga) {
      won++;
    } else if (gf == ga) {
      drawn++;
    } else {
      lost++;
    }
  }
}

/// Classement calculé à partir d'une liste de matchs.
/// Les équipes sont identifiées par leur nom.
List<_Standing> _buildStandings(List<MatchEntity> matches) {
  final table = <String, _Standing>{};
  for (final m in matches) {
    table.putIfAbsent(m.home.name, () => _Standing(m.home));
    table.putIfAbsent(m.away.name, () => _Standing(m.away));
  }
  for (final m in matches.where(_isEnd)) {
    final h = m.scores.home.toInt();
    final a = m.scores.away.toInt();
    table[m.home.name]!.record(h, a);
    table[m.away.name]!.record(a, h);
  }
  return table.values.toList()..sort((a, b) {
    final byPoints = b.points.compareTo(a.points);
    if (byPoints != 0) return byPoints;
    final byDiff = b.diff.compareTo(a.diff);
    if (byDiff != 0) return byDiff;
    final byGoals = b.goalsFor.compareTo(a.goalsFor);
    if (byGoals != 0) return byGoals;
    return a.team.name.compareTo(b.team.name);
  });
}

class _TournamentSummary {
  const _TournamentSummary._({
    required this.status,
    required this.standings,
    required this.pools,
    required this.venues,
    this.start,
    this.end,
    this.next,
  });

  factory _TournamentSummary.from(List<MatchEntity> matches) {
    final played = matches.where(_isEnd).length;

    final byPool = <String, List<MatchEntity>>{};
    for (final m in matches) {
      final pool = _poolOf(m);
      if (pool != null) byPool.putIfAbsent(pool, () => []).add(m);
    }
    final poolNames = byPool.keys.toList()..sort();

    final dates = matches.map((m) => m.date.toLocal()).toList()..sort();
    final upcoming = matches.where(_isComming).toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final venues = <String>{
      for (final m in matches)
        if (m.lieu.trim().isNotEmpty) m.lieu.trim(),
    };

    final _TournamentStatus status;
    if (matches.any(_isLive)) {
      status = _TournamentStatus.ongoing;
    } else if (played > 0 && played == matches.length) {
      status = _TournamentStatus.finished;
    } else if (played > 0) {
      status = _TournamentStatus.ongoing;
    } else {
      status = _TournamentStatus.upcoming;
    }

    return _TournamentSummary._(
      status: status,
      standings: _buildStandings(matches),
      pools: {
        for (final name in poolNames) name: _buildStandings(byPool[name]!),
      },
      venues: venues.toList(),
      start: dates.isEmpty ? null : dates.first,
      end: dates.isEmpty ? null : dates.last,
      next: upcoming.isEmpty ? null : upcoming.first.date.toLocal(),
    );
  }

  final _TournamentStatus status;

  /// Classement général (utilisé quand il n'y a pas de poules).
  final List<_Standing> standings;

  /// Nom de poule → classement de la poule.
  final Map<String, List<_Standing>> pools;

  final List<String> venues;
  final DateTime? start;
  final DateTime? end;
  final DateTime? next;

  /// Au moins 2 poules : sinon on garde le classement unique.
  bool get hasPools => pools.length >= 2;

  String? get periodLabel {
    final s = start;
    final e = end;
    if (s == null || e == null) return null;
    final f = DateFormat('dd/MM/yyyy');
    final a = f.format(s);
    final b = f.format(e);
    return a == b ? a : '$a → $b';
  }

  String? get venueLabel {
    if (venues.isEmpty) return null;
    if (venues.length == 1) return venues.first;
    return '${venues.length} lieux';
  }
}

// ─────────────────────────────────────────────────────────────────────────
// En-tête : bienvenue + infos du tournoi
// ─────────────────────────────────────────────────────────────────────────

String _countdown(DateTime date) {
  final diff = date.difference(DateTime.now());
  if (diff.isNegative) return 'Prochain match : bientôt';
  final days = diff.inDays;
  final hours = diff.inHours % 24;
  final minutes = diff.inMinutes % 60;
  if (days > 0) return 'Prochain match dans $days j $hours h';
  if (diff.inHours > 0) {
    return 'Prochain match dans ${diff.inHours} h $minutes min';
  }
  return 'Prochain match dans ${diff.inMinutes} min';
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.tournoiId, this.summary});

  final String tournoiId;

  /// Null pendant le chargement : on n'affiche alors que le titre.
  final _TournamentSummary? summary;

  @override
  Widget build(BuildContext context) {
    final tournamentName = context.select<TournoiCubit, String>((cubit) {
      for (final t in cubit.state.tournois) {
        if (t.id == tournoiId) return t.name;
      }
      return 'votre tournoi';
    });
    final userName = context.select<AuthBloc, String?>(
      (bloc) => bloc.state.user?.firstname,
    );

    final s = summary;
    final period = s?.periodLabel;
    final venue = s?.venueLabel;
    final next = s?.next;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.78),
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName == null || userName.isEmpty
                    ? 'Bienvenue'
                    : 'Bienvenue $userName',
                style: StyleText().desc.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                tournamentName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: StyleText().headBlack.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              if (s != null) ...[
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _HeaderPill(
                      icon: Icons.flag_rounded,
                      text: _statusLabel(s.status),
                    ),
                    _HeaderPill(
                      icon: Icons.event_rounded,
                      text: period ?? 'Calendrier bientôt disponible',
                    ),
                    if (venue != null)
                      _HeaderPill(
                        icon: Icons.location_on_outlined,
                        text: venue,
                      ),
                    if (next != null && s.status != _TournamentStatus.finished)
                      _HeaderPill(
                        icon: Icons.timer_outlined,
                        text: _countdown(next),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  const _HeaderPill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StyleText().caption.copyWith(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────
// Barre de chips épinglée
// ─────────────────────────────────────────────────────────────────────────

class _PinnedBarDelegate extends SliverPersistentHeaderDelegate {
  const _PinnedBarDelegate({required this.child, required this.color});

  final Widget child;
  final Color color;

  @override
  double get minExtent => 56;

  @override
  double get maxExtent => 56;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => Container(color: color, alignment: Alignment.center, child: child);

  // Le chip sélectionné change : on doit toujours reconstruire.
  @override
  bool shouldRebuild(covariant _PinnedBarDelegate oldDelegate) => true;
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.selected,
    required this.hasLive,
    required this.labelFor,
    required this.onSelected,
  });

  final _MatchTab selected;
  final bool hasLive;
  final String Function(_MatchTab tab) labelFor;
  final ValueChanged<_MatchTab> onSelected;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 38,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _MatchTab.values.length,
      separatorBuilder: (_, _) => const SizedBox(width: 8),
      itemBuilder: (_, index) {
        final tab = _MatchTab.values[index];
        return _TabChip(
          label: labelFor(tab),
          selected: tab == selected,
          // Rouge + point qui pulse seulement s'il y a un match en cours.
          isLive: tab == _MatchTab.live && hasLive,
          onTap: () => onSelected(tab),
        );
      },
    ),
  );
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.isLive = false,
  });

  final String label;
  final bool selected;
  final bool isLive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isLive ? AppColors.error : AppColors.primary;
    return Material(
      color: selected ? color : color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLive) ...[
                selected
                    ? Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      )
                    : const _PulsingDot(),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: StyleText().captionBold.copyWith(
                  color: selected ? Colors.white : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Calendrier : groupe de matchs d'un jour (repliable)
// ─────────────────────────────────────────────────────────────────────────

class _DateGroupCard extends StatelessWidget {
  const _DateGroupCard({
    super.key,
    required this.date,
    required this.matches,
    required this.tournoiId,
    required this.selections,
    required this.onOutcomeLongPress,
    required this.expanded,
    required this.onToggle,
  });

  final DateTime date;
  final List<MatchEntity> matches;
  final String tournoiId;
  final Map<String, _MatchBetSelection> selections;
  final Future<void> Function(MatchEntity, String, String, String, double)
  onOutcomeLongPress;
  final bool expanded;
  final VoidCallback onToggle;

  static const _duration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    final count = matches.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Barre de date : seule à porter le fond vert.
        Material(
          color: AppColors.success.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onToggle,
            child: SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _longDate(date),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: StyleText().captionBold,
                      ),
                    ),
                    Text(
                      '$count match${count > 1 ? 's' : ''}',
                      style: StyleText().caption,
                    ),
                    const SizedBox(width: 6),
                    AnimatedRotation(
                      turns: expanded ? 0.5 : 0,
                      duration: _duration,
                      child: const Icon(Icons.keyboard_arrow_down_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Les cartes de match sont en dessous, hors de la barre.
        // Replié : il ne reste que la barre.
        AnimatedSize(
          duration: _duration,
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: expanded
              ? Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    children: [
                      for (var i = 0; i < matches.length; i++) ...[
                        _MatchCard(
                          match: matches[i],
                          kind: _MatchKind.upcoming,
                          tournoiId: tournoiId,
                          selections: selections,
                          onOutcomeLongPress: onOutcomeLongPress,
                        ),
                        if (i < matches.length - 1) const SizedBox(height: 12),
                      ],
                    ],
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Classement
// ─────────────────────────────────────────────────────────────────────────

class _StandingsCard extends StatelessWidget {
  const _StandingsCard({required this.standings});

  final List<_Standing> standings;

  Widget _cell(
    String text,
    double width, {
    bool bold = false,
    TextAlign align = TextAlign.center,
  }) => SizedBox(
    width: width,
    child: Text(
      text,
      textAlign: align,
      style: bold ? StyleText().captionBold : StyleText().caption,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Row(
              children: [
                _cell('#', 24, bold: true, align: TextAlign.left),
                Expanded(child: Text('Équipe', style: StyleText().captionBold)),
                _cell('J', 28, bold: true),
                _cell('Diff', 36, bold: true),
                _cell('Pts', 32, bold: true),
              ],
            ),
            const Divider(height: 20),
            for (var i = 0; i < standings.length; i++) ...[
              Row(
                children: [
                  _cell('${i + 1}', 24, align: TextAlign.left),
                  Expanded(
                    child: Row(
                      children: [
                        _TeamLogo(url: standings[i].team.logo, size: 22),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            standings[i].team.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: StyleText().captionBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _cell('${standings[i].played}', 28),
                  _cell(
                    standings[i].diff > 0
                        ? '+${standings[i].diff}'
                        : '${standings[i].diff}',
                    36,
                  ),
                  _cell('${standings[i].points}', 32, bold: true),
                ],
              ),
              if (i < standings.length - 1) const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Sections et états
// ─────────────────────────────────────────────────────────────────────────

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.sports_soccer_rounded, size: 32),
            const SizedBox(height: 10),
            Text(message, textAlign: TextAlign.center, style: StyleText().desc),
          ],
        ),
      ),
    ),
  );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.isLive = false,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final bool isLive;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 8, 0, 8),
    child: Row(
      children: [
        if (isLive) ...[const _PulsingDot(), const SizedBox(width: 8)],
        Expanded(
          child: Text(
            title,
            style: StyleText().subtitle.copyWith(fontSize: 16),
          ),
        ),
        if (actionLabel != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    ),
  );
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: Tween<double>(begin: 0.3, end: 1).animate(_controller),
    child: Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        color: AppColors.error,
        shape: BoxShape.circle,
      ),
    ),
  );
}

class _MessageView extends StatelessWidget {
  const _MessageView({required this.message, this.action});

  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message, style: StyleText().desc, textAlign: TextAlign.center),
        if (action != null) ...[const SizedBox(height: 8), action!],
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────
// Cartes de match
// ─────────────────────────────────────────────────────────────────────────

String _relativeDay(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(date.year, date.month, date.day);
  final diff = day.difference(today).inDays;
  if (diff == 0) return "Aujourd'hui";
  if (diff == 1) return 'Demain';
  return DateFormat('dd/MM/yyyy').format(date);
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({
    required this.match,
    required this.kind,
    required this.tournoiId,
    required this.selections,
    required this.onOutcomeLongPress,
  });

  final MatchEntity match;
  final _MatchKind kind;
  final String tournoiId;
  final Map<String, _MatchBetSelection> selections;
  final Future<void> Function(MatchEntity, String, String, String, double)
  onOutcomeLongPress;

  @override
  Widget build(BuildContext context) {
    final local = match.date.toLocal();
    final hour = DateFormat('HH:mm').format(local);
    final date = kind == _MatchKind.upcoming
        ? '${_relativeDay(local)} - $hour'
        : '${DateFormat('dd/MM/yyyy').format(local)} - $hour';
    final isLive = kind == _MatchKind.live;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isLive
            ? BorderSide(color: AppColors.error.withValues(alpha: 0.5))
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) =>
                MatchDetailScreen(match: match, tournoiId: tournoiId),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${match.type} - Journée ${match.journee}',
                      style: StyleText().captionBold,
                    ),
                  ),
                  if (isLive)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'LIVE',
                        style: StyleText().captionBold.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  else
                    Text(match.etat, style: StyleText().caption),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: _TeamLabel(team: match.home)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      kind == _MatchKind.upcoming
                          ? 'VS'
                          : '${match.scores.home} - ${match.scores.away}',
                      style: StyleText().headBlack,
                    ),
                  ),
                  Expanded(child: _TeamLabel(team: match.away, trailing: true)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.schedule_rounded, size: 16),
                  const SizedBox(width: 6),
                  Expanded(child: Text(date, style: StyleText().caption)),
                  const Icon(Icons.location_on_outlined, size: 16),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      match.lieu,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: StyleText().caption,
                    ),
                  ),
                ],
              ),
              if (kind == _MatchKind.upcoming) ..._betsInfo(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _betsInfo() {
    final matchResultBet = match.bets.where((bet) {
      final category = bet.category
          .trim()
          .replaceAll(RegExp(r'[\s-]+'), '_')
          .toUpperCase();
      return bet.isActive && category == 'MATCH_RESULT';
    }).firstOrNull;
    if (matchResultBet == null) return const [];

    const outcomes = ['V1', 'X', 'V2'];
    return [
      const SizedBox(height: 12),
      Text(
        'Maintenez une cote pour la sélectionner',
        style: StyleText().caption.copyWith(color: AppColors.grey),
      ),
      const SizedBox(height: 6),
      Row(
        children: [
          for (var i = 0; i < outcomes.length; i++) ...[
            if (i > 0) const SizedBox(width: 10),
            Expanded(
              child: _BetOdd(
                outcome: outcomes[i],
                odd: matchResultBet.odds[outcomes[i]],
                selected:
                    selections[_matchBetSelectionKey(
                          match,
                          matchResultBet.category,
                        )]
                        ?.selection
                        .option ==
                    outcomes[i],
                onLongPress: () {
                  final odd = matchResultBet.odds[outcomes[i]];
                  if (odd != null) {
                    onOutcomeLongPress(
                      match,
                      matchResultBet.id,
                      matchResultBet.category,
                      outcomes[i],
                      odd,
                    );
                  }
                },
              ),
            ),
          ],
        ],
      ),
    ];
  }
}

class _BetOdd extends StatelessWidget {
  const _BetOdd({
    required this.outcome,
    required this.odd,
    required this.selected,
    required this.onLongPress,
  });

  final String outcome;
  final double? odd;
  final bool selected;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onLongPress: selected || odd == null ? null : onLongPress,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary
            : AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: selected ? Border.all(color: AppColors.primaryDark) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            outcome,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StyleText().caption.copyWith(
              color: selected ? Colors.white : AppColors.primaryDark,
            ),
          ),
          Text(
            odd?.toString() ?? '—',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StyleText().captionBold.copyWith(
              color: selected ? Colors.white : AppColors.primaryDark,
            ),
          ),
        ],
      ),
    ),
  );
}

class _TeamLabel extends StatelessWidget {
  const _TeamLabel({required this.team, this.trailing = false});

  final TeamEntity team;
  final bool trailing;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: trailing
        ? MainAxisAlignment.end
        : MainAxisAlignment.start,
    children: [
      if (!trailing) ...[_TeamLogo(url: team.logo), const SizedBox(width: 8)],
      Flexible(
        child: Text(
          team.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: trailing ? TextAlign.right : TextAlign.left,
          style: StyleText().captionBold,
        ),
      ),
      if (trailing) ...[const SizedBox(width: 8), _TeamLogo(url: team.logo)],
    ],
  );
}

class _TeamLogo extends StatelessWidget {
  const _TeamLogo({this.url, this.size = 28});

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final imageUrl = url;
    if (imageUrl == null || imageUrl.isEmpty) return _fallback();
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: SvgPicture.network(
          imageUrl,
          placeholderBuilder: (_) => _fallback(),
          errorBuilder: (_, _, _) => _fallback(),
        ),
      ),
    );
  }

  Widget _fallback() =>
      Icon(Icons.shield_outlined, color: AppColors.primary, size: size);
}
