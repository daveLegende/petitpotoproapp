import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:petitpotopro/common/helpers/constant.dart';
import 'package:petitpotopro/common/helpers/style.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';
import 'package:petitpotopro/core/di/service_locator.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:petitpotopro/features/auth/presentation/pages/login_page.dart';
import 'package:petitpotopro/features/coupons/domain/entities/coupon_draft.dart';
import 'package:petitpotopro/features/coupons/presentation/cubit/user_coupons_cubit.dart';
import 'package:petitpotopro/features/bet/domain/entities/bet_entity.dart';
import 'package:petitpotopro/features/matchs/domain/entities/match_entity.dart';
import 'package:petitpotopro/features/matchs/domain/entities/match_event_entity.dart';
import 'package:petitpotopro/features/matchs/presentation/cubit/match_events_cubit.dart';
import 'package:petitpotopro/features/matchs/presentation/cubit/match_events_state.dart';
import 'package:petitpotopro/features/team/domain/entities/team_entity.dart';
import 'package:petitpotopro/common/widgets/navigation/navigation_widget.dart';

class MatchDetailScreen extends StatelessWidget {
  const MatchDetailScreen({
    super.key,
    required this.match,
    required this.tournoiId,
  });

  final MatchEntity match;
  final String tournoiId;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider<MatchEventsCubit>(
        create: (_) {
          final cubit = sl<MatchEventsCubit>();
          if (_isLiveOrFinished(match.etat)) {
            cubit.load(matchId: match.id, tournoiId: tournoiId);
          }
          return cubit;
        },
      ),
      BlocProvider<UserCouponsCubit>(create: (_) => sl<UserCouponsCubit>()),
    ],
    child: _MatchDetailView(match: match, tournoiId: tournoiId),
  );
}

class _MatchDetailView extends StatefulWidget {
  const _MatchDetailView({required this.match, required this.tournoiId});

  final MatchEntity match;
  final String tournoiId;

  @override
  State<_MatchDetailView> createState() => _MatchDetailViewState();
}

class _MatchDetailViewState extends State<_MatchDetailView> {
  final Map<String, CouponSelection> _selections = {};

  bool get _closed => _isLiveOrFinished(widget.match.etat);

  void _toggleSelection(String betId, String option, double odd) {
    setState(() {
      if (_selections[betId]?.option == option) {
        _selections.remove(betId);
      } else {
        _selections[betId] = CouponSelection(
          betId: betId,
          option: option,
          odd: odd,
        );
      }
    });
  }

  Future<void> _submitCoupon() async {
    final auth = context.read<AuthBloc>().state;
    final userId = auth.user?.id;
    if (!auth.isAuthenticated || userId == null || userId.isEmpty) {
      final redirect = Uri(
        path: NavigationWidget.route,
        queryParameters: {'tournoiId': widget.tournoiId, 'tab': '2'},
      ).toString();
      context.go(
        Uri(
          path: LoginPage.route,
          queryParameters: {'redirect': redirect},
        ).toString(),
      );
      return;
    }
    if (_selections.isEmpty) return;

    final amount = await showDialog<num>(
      context: context,
      builder: (_) => const _StakeDialog(),
    );
    if (amount == null || !mounted) return;

    final success = await context.read<UserCouponsCubit>().create(
      CouponDraft(
        userId: userId,
        selections: _selections.values.toList(growable: false),
        amount: amount,
      ),
      tournament: false,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Coupon créé.' : 'Création impossible. Réessayez.',
        ),
      ),
    );
    if (success) setState(_selections.clear);
  }

  @override
  Widget build(BuildContext context) {
    final match = widget.match;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: mwhite,
        title: const Text('Détail du match'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _MatchScoreboard(match: match),
          const SizedBox(height: 12),
          _MatchInformation(match: match),
          const SizedBox(height: 20),
          if (_closed) ...[
            Text('Événements du match', style: StyleText().subtitle),
            const SizedBox(height: 8),
            _MatchEvents(match: match, tournoiId: widget.tournoiId),
          ] else ...[
            Text('Paris disponibles', style: StyleText().subtitle),
            const SizedBox(height: 8),
            _BetCategories(
              match: match,
              selections: _selections,
              onSelectionChanged: _toggleSelection,
            ),
            const SizedBox(height: 50),
          ],
        ],
      ),
      bottomNavigationBar: _closed ? null : _couponBar(context),
    );
  }

  Widget _couponBar(BuildContext context) {
    final isAuthenticated = context.select<AuthBloc, bool>(
      (bloc) => bloc.state.isAuthenticated,
    );
    final totalOdds = _selections.values.fold<double>(
      1,
      (total, selection) => total * selection.odd.toDouble(),
    );
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        child: Row(
          children: [
            if (_selections.isNotEmpty) ...[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_selections.length} sélection${_selections.length > 1 ? 's' : ''}',
                      style: StyleText().caption,
                    ),
                    Text(
                      'Cote ${totalOdds.toStringAsFixed(2)}',
                      style: StyleText().captionBold,
                    ),
                  ],
                ),
              ),
            ] else
              const Expanded(child: Text('Choisissez un ou plusieurs paris')),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: isAuthenticated
                  ? (_selections.isEmpty ? null : _submitCoupon)
                  : _submitCoupon,
              icon: Icon(isAuthenticated ? Icons.add_rounded : Icons.login),
              label: Text(
                isAuthenticated ? 'Créer le coupon' : 'Se connecter',
                style: StyleText().button,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool _isLiveOrFinished(String status) {
  final normalized = status.trim().toUpperCase();
  return normalized.contains('EN_COURS') ||
      normalized.contains('TERMINER') ||
      normalized.contains('TERMINE') ||
      normalized.contains('FINISHED');
}

class _MatchScoreboard extends StatelessWidget {
  const _MatchScoreboard({required this.match});

  final MatchEntity match;

  @override
  Widget build(BuildContext context) {
    final status = match.etat.toUpperCase();
    final isLive = status.contains('EN_COURS');
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF124A35), Color(0xFF176B47)],
          ),
        ),
        child: Column(
          children: [
            Text(
              '${match.type} · Journée ${match.journee}',
              style: StyleText().caption.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _DetailTeam(team: match.home)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '${match.scores.home} - ${match.scores.away}',
                    style: StyleText().headWhite.copyWith(fontSize: 26),
                  ),
                ),
                Expanded(child: _DetailTeam(team: match.away, trailing: true)),
              ],
            ),
            const SizedBox(height: 12),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                child: Text(
                  isLive ? 'EN DIRECT' : match.etat,
                  style: StyleText().captionBold.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailTeam extends StatelessWidget {
  const _DetailTeam({required this.team, this.trailing = false});

  final TeamEntity team;
  final bool trailing;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _TeamBadge(team: team),
      const SizedBox(height: 8),
      Text(
        team.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: StyleText().captionBold.copyWith(color: Colors.white),
      ),
    ],
  );
}

class _TeamBadge extends StatelessWidget {
  const _TeamBadge({required this.team});

  final TeamEntity team;

  @override
  Widget build(BuildContext context) {
    final logo = team.logo;
    if (logo == null || logo.isEmpty) {
      return const CircleAvatar(
        radius: 25,
        backgroundColor: Colors.white24,
        child: Icon(Icons.shield_outlined, color: Colors.white, size: 28),
      );
    }
    return SizedBox(
      width: 50,
      height: 50,
      child: SvgPicture.network(
        logo,
        placeholderBuilder: (_) =>
            const Icon(Icons.shield_outlined, color: Colors.white),
        errorBuilder: (_, _, _) =>
            const Icon(Icons.shield_outlined, color: Colors.white),
      ),
    );
  }
}

class _MatchInformation extends StatelessWidget {
  const _MatchInformation({required this.match});

  final MatchEntity match;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd/MM/yyyy · HH:mm').format(match.date.toLocal());
    return Card(
      child: Column(
        children: [
          _InformationRow(
            icon: Icons.calendar_month_outlined,
            label: 'Date',
            value: date,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _InformationRow(
            icon: Icons.location_on_outlined,
            label: 'Lieu',
            value: match.lieu,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _InformationRow(
            icon: Icons.sports_outlined,
            label: 'Arbitre',
            value: match.referee?.isNotEmpty == true
                ? match.referee!
                : 'Non renseigné',
          ),
        ],
      ),
    );
  }
}

class _InformationRow extends StatelessWidget {
  const _InformationRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
    child: Row(
      children: [
        Icon(icon, size: 19, color: AppColors.primary),
        const SizedBox(width: 12),
        SizedBox(width: 66, child: Text(label, style: StyleText().caption)),
        Expanded(child: Text(value, style: StyleText().body)),
      ],
    ),
  );
}

class _MatchEvents extends StatelessWidget {
  const _MatchEvents({required this.match, required this.tournoiId});

  final MatchEntity match;
  final String tournoiId;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<MatchEventsCubit, MatchEventsState>(
        builder: (context, state) {
          if (state.isLoading && state.events.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (state.errorMessage != null && state.events.isEmpty) {
            return _InlineMessage(
              message: state.errorMessage!,
              onRetry: () => context.read<MatchEventsCubit>().load(
                matchId: match.id,
                tournoiId: tournoiId,
              ),
            );
          }
          if (state.events.isEmpty) {
            return const _InlineMessage(message: 'Aucun événement enregistré.');
          }
          final events = [...state.events]..sort(_compareEvents);
          return Column(
            children: [for (final event in events) _EventTile(event: event)],
          );
        },
      );

  int _compareEvents(MatchEventEntity a, MatchEventEntity b) {
    final minuteA = _minuteValue(a.minute);
    final minuteB = _minuteValue(b.minute);
    if (minuteA == null || minuteB == null) return 0;
    return minuteA.compareTo(minuteB);
  }

  int? _minuteValue(String? minute) {
    final match = RegExp(r'\d+').firstMatch(minute ?? '');
    return int.tryParse(match?.group(0) ?? '');
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event});

  final MatchEventEntity event;

  @override
  Widget build(BuildContext context) {
    final eventType = event.type.toLowerCase();
    final icon = eventType.contains('but') || eventType.contains('goal')
        ? Icons.sports_soccer_rounded
        : eventType.contains('carton') || eventType.contains('card')
        ? Icons.style_outlined
        : eventType.contains('remplacement') ||
              eventType.contains('substitution')
        ? Icons.swap_horiz_rounded
        : Icons.event_note_rounded;
    final subtitle = [
      event.playerName,
      event.teamName,
      event.description,
    ].whereType<String>().where((part) => part.isNotEmpty).join(' · ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.bgColor,
            foregroundColor: AppColors.primary,
            child: Icon(icon, size: 20),
          ),
          title: Text(event.type, style: StyleText().bodyBold),
          subtitle: subtitle.isEmpty
              ? null
              : Text(subtitle, style: StyleText().caption),
          trailing: event.minute == null
              ? null
              : Text('${event.minute}\'', style: StyleText().captionBold),
        ),
      ),
    );
  }
}

class _InlineMessage extends StatelessWidget {
  const _InlineMessage({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      children: [
        Text(message, textAlign: TextAlign.center, style: StyleText().desc),
        if (onRetry != null)
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Réessayer'),
          ),
      ],
    ),
  );
}

class _BetCategories extends StatelessWidget {
  const _BetCategories({
    required this.match,
    required this.selections,
    required this.onSelectionChanged,
  });

  final MatchEntity match;
  final Map<String, CouponSelection> selections;
  final void Function(String betId, String option, double odd)
  onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final bets = match.bets.where((bet) => bet.isActive).toList();
    final categories = <String, List<BetEntity>>{};
    for (final bet in bets) {
      categories.putIfAbsent(bet.category, () => []).add(bet);
    }
    if (categories.isEmpty) {
      return const _InlineMessage(
        message: 'Aucun pari disponible pour ce match.',
      );
    }

    return Column(
      children: [
        for (final entry in categories.entries)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                _formatCategory(entry.key),
                style: StyleText().bodyBold,
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                for (final bet in entry.value)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final odd in bet.odds.entries)
                          ChoiceChip(
                            label: Text(
                              '${_formatCategory(odd.key)}  ${odd.value}',
                              style: StyleText().captionBold.copyWith(
                                color: selections[bet.id]?.option == odd.key
                                    ? Colors.white
                                    : AppColors.neutral,
                              ),
                            ),
                            selected: selections[bet.id]?.option == odd.key,
                            onSelected: (_) =>
                                onSelectionChanged(bet.id, odd.key, odd.value),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

String _formatCategory(String value) => value
    .replaceAll('_', ' ')
    .toLowerCase()
    .split(' ')
    .where((part) => part.isNotEmpty)
    .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
    .join(' ');

class _StakeDialog extends StatefulWidget {
  const _StakeDialog();

  @override
  State<_StakeDialog> createState() => _StakeDialogState();
}

class _StakeDialogState extends State<_StakeDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final amount = num.tryParse(_controller.text.trim().replaceAll(',', '.'));
    if (amount == null || amount <= 0) return;
    Navigator.of(context).pop(amount);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Mise du coupon'),
    content: TextField(
      controller: _controller,
      autofocus: true,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        labelText: 'Montant',
        prefixIcon: Icon(Icons.payments_outlined),
      ),
      onSubmitted: (_) => _submit(),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Annuler'),
      ),
      FilledButton(onPressed: _submit, child: const Text('Continuer')),
    ],
  );
}
