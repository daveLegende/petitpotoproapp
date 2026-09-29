import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:petitpotopro/common/helpers/style.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';
import 'package:petitpotopro/core/di/service_locator.dart';
import 'package:petitpotopro/features/matchs/domain/entities/match_entity.dart';
import 'package:petitpotopro/features/matchs/presentation/cubit/match_cubit.dart';
import 'package:petitpotopro/features/matchs/presentation/cubit/match_state.dart';
import 'package:petitpotopro/features/team/domain/entities/team_entity.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key, required this.tournoiId});

  final String tournoiId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MatchCubit>(
      create: (_) => sl<MatchCubit>()..getAll(tournoiId),
      child: _MatchListView(tournoiId: tournoiId),
    );
  }
}

class _MatchListView extends StatelessWidget {
  const _MatchListView({required this.tournoiId});

  final String tournoiId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchCubit, MatchState>(
      builder: (context, state) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Matchs du tournoi', style: StyleText().headBlack),
            ),
          ),
          Expanded(child: _buildContent(context, state)),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, MatchState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.errorMessage != null) {
      return _MessageView(
        message: state.errorMessage!,
        action: TextButton.icon(
          onPressed: () => context.read<MatchCubit>().getAll(tournoiId),
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Réessayer'),
        ),
      );
    }
    if (state.matches.isEmpty) {
      return const _MessageView(message: 'Aucun match pour ce tournoi.');
    }

    return RefreshIndicator(
      onRefresh: () => context.read<MatchCubit>().getAll(tournoiId),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: state.matches.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) =>
            _MatchCard(match: state.matches[index]),
      ),
    );
  }
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

class _MatchCard extends StatelessWidget {
  const _MatchCard({required this.match});

  final MatchEntity match;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd/MM/yyyy - HH:mm').format(match.date.toLocal());
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
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
                Text(match.etat, style: StyleText().caption),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _TeamLabel(team: match.home)),
                Text(
                  '${match.scores.home} - ${match.scores.away}',
                  style: StyleText().headBlack,
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
            if (match.bets.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                '${match.bets.where((bet) => bet.isActive).length} paris disponibles',
                style: StyleText().captionBold.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
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
      if (!trailing) _TeamLogo(url: team.logo),
      if (!trailing) const SizedBox(width: 8),
      Flexible(
        child: Text(
          team.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: trailing ? TextAlign.right : TextAlign.left,
          style: StyleText().captionBold,
        ),
      ),
      if (trailing) const SizedBox(width: 8),
      if (trailing) _TeamLogo(url: team.logo),
    ],
  );
}

class _TeamLogo extends StatelessWidget {
  const _TeamLogo({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final imageUrl = url;
    if (imageUrl == null || imageUrl.isEmpty) return _fallback();
    return SizedBox(
      width: 28,
      height: 28,
      child: SvgPicture.network(
        imageUrl,
        placeholderBuilder: (_) => _fallback(),
        errorBuilder: (_, _, _) => _fallback(),
      ),
    );
  }

  Widget _fallback() =>
      const Icon(Icons.shield_outlined, color: AppColors.primary);
}
