import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petitpotopro/common/helpers/style.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';
import 'package:petitpotopro/core/di/service_locator.dart';
import 'package:petitpotopro/features/coupons/domain/entities/coupon_leg.dart';
import 'package:petitpotopro/features/coupons/domain/entities/user_coupon.dart';
import 'package:petitpotopro/features/matchs/domain/entities/match_entity.dart';
import 'package:petitpotopro/features/matchs/presentation/cubit/match_cubit.dart';
import 'package:petitpotopro/features/matchs/presentation/cubit/match_state.dart';

class CouponDetailScreen extends StatelessWidget {
  const CouponDetailScreen({
    super.key,
    required this.coupon,
    required this.tournoiId,
  });

  final UserCoupon coupon;
  final String tournoiId;

  @override
  Widget build(BuildContext context) => BlocProvider<MatchCubit>(
    create: (_) => sl<MatchCubit>()..getAll(tournoiId),
    child: _CouponDetailView(coupon: coupon),
  );
}

class _CouponDetailView extends StatelessWidget {
  const _CouponDetailView({required this.coupon});

  final UserCoupon coupon;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Détail du coupon')),
    body: BlocBuilder<MatchCubit, MatchState>(
      builder: (context, matchState) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _CouponSummary(coupon: coupon),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text('Détail des paris', style: StyleText().subtitle),
              ),
              Text(
                '${coupon.legs.length} ${coupon.legs.length == 1 ? 'pari' : 'paris'}',
                style: StyleText().caption,
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (coupon.legs.isEmpty)
            const _DetailMessage(
              message:
                  'Le détail des sélections n’est pas fourni par le serveur.',
            )
          else if (matchState.isLoading && matchState.matches.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            for (var index = 0; index < coupon.legs.length; index++)
              _CouponLegCard(
                index: index + 1,
                leg: coupon.legs[index],
                match: _findMatch(coupon.legs[index], matchState.matches),
              ),
        ],
      ),
    ),
  );

  MatchEntity? _findMatch(CouponLeg leg, List<MatchEntity> matches) {
    for (final match in matches) {
      if (leg.matchId != null && match.id == leg.matchId) return match;
      if (match.bets.any((bet) => bet.id == leg.betId)) return match;
    }
    return null;
  }
}

class _CouponSummary extends StatelessWidget {
  const _CouponSummary({required this.coupon});

  final UserCoupon coupon;

  @override
  Widget build(BuildContext context) => Card(
    color: AppColors.bgColor,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  coupon.kind == UserCouponKind.tournament
                      ? 'Coupon tournoi'
                      : 'Coupon matchs',
                  style: StyleText().subtitle,
                ),
              ),
              _StatusBadge(status: coupon.status),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 24,
            runSpacing: 10,
            children: [
              _SummaryValue(
                label: 'Cote totale',
                value: '${coupon.totalOdds ?? '-'}',
              ),
              _SummaryValue(label: 'Mise', value: '${coupon.amount ?? '-'}'),
              _SummaryValue(
                label: 'Gain potentiel',
                value: '${coupon.gains ?? '-'}',
              ),
            ],
          ),
          if (coupon.isPaid) ...[
            const SizedBox(height: 10),
            Text('Gain payé', style: StyleText().captionBold),
          ],
        ],
      ),
    ),
  );
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: StyleText().caption),
      const SizedBox(height: 2),
      Text(value, style: StyleText().bodyBold),
    ],
  );
}

class _CouponLegCard extends StatelessWidget {
  const _CouponLegCard({
    required this.index,
    required this.leg,
    required this.match,
  });

  final int index;
  final CouponLeg leg;
  final MatchEntity? match;

  @override
  Widget build(BuildContext context) {
    final matchTitle = match == null
        ? leg.label ??
              (leg.category == null
                  ? 'Pari tournoi'
                  : _formatCategory(leg.category!))
        : '${match!.home.name} - ${match!.away.name}';
    final category = leg.category ?? 'Sélection';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  foregroundColor: AppColors.primary,
                  child: Text('$index', style: StyleText().captionBold),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    matchTitle,
                    style: StyleText().bodyBold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _StatusBadge(status: leg.status),
              ],
            ),
            if (match != null) ...[
              const SizedBox(height: 10),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${match!.scores.home} - ${match!.scores.away}',
                    style: StyleText().bodyBold.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatCategory(category),
                          style: StyleText().caption,
                        ),
                        const SizedBox(height: 4),
                        if (leg.selectedOptions.isEmpty)
                          Text(
                            'Option indisponible',
                            style: StyleText().bodyBold,
                          )
                        else
                          ...leg.selectedOptions.entries.map(
                            (option) => Text(
                              _formatCategory(option.key),
                              style: StyleText().bodyBold,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Cote', style: StyleText().caption),
                      const SizedBox(height: 4),
                      if (leg.selectedOptions.isEmpty)
                        Text('-', style: StyleText().bodyBold)
                      else
                        ...leg.selectedOptions.values.map(
                          (odd) => Text(
                            odd.toString(),
                            style: StyleText().bodyBold.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (match != null) ...[
              const SizedBox(height: 8),
              Text(
                '${match!.type} · ${match!.lieu}',
                style: StyleText().caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    final color = normalized.contains('gagn') || normalized.contains('won')
        ? AppColors.success
        : normalized.contains('perdu') || normalized.contains('lost')
        ? AppColors.error
        : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: StyleText().captionBold.copyWith(color: color),
      ),
    );
  }
}

class _DetailMessage extends StatelessWidget {
  const _DetailMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(18),
    child: Text(message, textAlign: TextAlign.center, style: StyleText().desc),
  );
}

String _formatCategory(String value) => value
    .replaceAll('_', ' ')
    .toLowerCase()
    .split(' ')
    .where((part) => part.isNotEmpty)
    .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
    .join(' ');
