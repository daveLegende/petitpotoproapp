import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petitpotopro/core/di/service_locator.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:petitpotopro/features/coupons/domain/entities/coupon_draft.dart';
import 'package:petitpotopro/features/coupons/domain/entities/user_coupon.dart';
import 'package:petitpotopro/features/coupons/presentation/cubit/user_coupons_cubit.dart';
import 'package:petitpotopro/features/coupons/presentation/pages/coupon_detail_screen.dart';
import 'package:petitpotopro/features/matchs/presentation/cubit/match_cubit.dart';
import 'package:petitpotopro/features/matchs/presentation/cubit/match_state.dart';

class UserCouponsScreen extends StatelessWidget {
  const UserCouponsScreen({super.key, required this.tournoiId});

  final String tournoiId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UserCouponsCubit>()..load(),
      child: _UserCouponsView(tournoiId: tournoiId),
    );
  }
}

class _UserCouponsView extends StatefulWidget {
  const _UserCouponsView({required this.tournoiId});

  final String tournoiId;

  @override
  State<_UserCouponsView> createState() => _UserCouponsViewState();
}

class _UserCouponsViewState extends State<_UserCouponsView> {
  Future<void> _createCoupon(
    BuildContext context, {
    required bool tournament,
  }) async {
    final userId = sl<AuthBloc>().state.user?.id;
    if (userId == null || userId.isEmpty) return;

    final draft = await showDialog<CouponDraft>(
      context: context,
      builder: (_) => BlocProvider<MatchCubit>(
        create: (_) => sl<MatchCubit>()..getAll(widget.tournoiId),
        child: _CouponCreationDialog(
          tournoiId: widget.tournoiId,
          userId: userId,
          tournament: tournament,
        ),
      ),
    );
    if (draft == null || !context.mounted) return;

    final succeeded = await context.read<UserCouponsCubit>().create(
      draft,
      tournament: tournament,
    );
    if (!context.mounted) return;
    if (succeeded) await context.read<UserCouponsCubit>().load();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          succeeded ? 'Coupon créé.' : 'Création impossible. Réessayez.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes coupons'),
        actions: [
          PopupMenuButton<bool>(
            tooltip: 'Créer un coupon',
            icon: const Icon(Icons.add),
            onSelected: (tournament) =>
                _createCoupon(context, tournament: tournament),
            itemBuilder: (_) => const [
              PopupMenuItem(value: false, child: Text('Coupon matchs')),
              PopupMenuItem(value: true, child: Text('Coupon tournoi')),
            ],
          ),
        ],
      ),
      body: BlocBuilder<UserCouponsCubit, UserCouponsState>(
        builder: (context, state) {
          if (state.isLoading && state.coupons.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null && state.coupons.isEmpty) {
            return _CouponMessage(
              message: state.errorMessage!,
              action: TextButton.icon(
                onPressed: () => context.read<UserCouponsCubit>().load(),
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            );
          }
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: 'Coupons simples'),
                    Tab(text: 'Coupons tournoi'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _CouponList(
                        tournoiId: widget.tournoiId,
                        coupons: state.coupons
                            .where(
                              (coupon) => coupon.kind == UserCouponKind.match,
                            )
                            .toList(growable: false),
                      ),
                      _CouponList(
                        tournoiId: widget.tournoiId,
                        coupons: state.coupons
                            .where(
                              (coupon) =>
                                  coupon.kind == UserCouponKind.tournament,
                            )
                            .toList(growable: false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CouponList extends StatefulWidget {
  const _CouponList({required this.coupons, required this.tournoiId});

  final List<UserCoupon> coupons;
  final String tournoiId;

  @override
  State<_CouponList> createState() => _CouponListState();
}

class _CouponListState extends State<_CouponList> {
  int _statusFilter = 0;

  String _bucket(UserCoupon coupon) {
    final status = coupon.status.toLowerCase();
    if (status.contains('gagn') ||
        status.contains('won') ||
        status.contains('win')) {
      return 'gagnés';
    }
    if (status.contains('perdu') ||
        status.contains('lost') ||
        status.contains('lose')) {
      return 'perdus';
    }
    return 'en cours';
  }

  @override
  Widget build(BuildContext context) {
    final labels = ['En cours', 'Gagnés', 'Perdus'];
    final filtered = widget.coupons
        .where(
          (coupon) => _bucket(coupon) == labels[_statusFilter].toLowerCase(),
        )
        .toList(growable: false);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: SegmentedButton<int>(
            segments: [
              for (var i = 0; i < labels.length; i++)
                ButtonSegment(value: i, label: Text(labels[i])),
            ],
            selected: {_statusFilter},
            onSelectionChanged: (selection) =>
                setState(() => _statusFilter = selection.first),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const _CouponMessage(
                  message: 'Aucun coupon dans cette catégorie.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => _CouponTile(
                    coupon: filtered[index],
                    tournoiId: widget.tournoiId,
                  ),
                ),
        ),
      ],
    );
  }
}

class _CouponCreationDialog extends StatefulWidget {
  const _CouponCreationDialog({
    required this.tournoiId,
    required this.userId,
    required this.tournament,
  });

  final String tournoiId;
  final String userId;
  final bool tournament;

  @override
  State<_CouponCreationDialog> createState() => _CouponCreationDialogState();
}

class _CouponCreationDialogState extends State<_CouponCreationDialog> {
  final _amountController = TextEditingController();
  final Map<String, MapEntry<String, double>> _selections = {};

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    final amount = num.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0 || _selections.isEmpty) return;

    Navigator.of(context).pop(
      CouponDraft(
        userId: widget.userId,
        selections: _selections.entries
            .map(
              (entry) => CouponSelection(
                betId: entry.key,
                option: entry.value.key,
                odd: entry.value.value,
              ),
            )
            .toList(growable: false),
        amount: amount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.tournament ? 'Coupon tournoi' : 'Coupon matchs'),
    content: SizedBox(
      width: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Mise',
              prefixIcon: Icon(Icons.payments_outlined),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Choisir les cotes',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SizedBox(
            height: 340,
            child: BlocBuilder<MatchCubit, MatchState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.errorMessage != null) {
                  return Center(child: Text(state.errorMessage!));
                }
                if (state.matches.isEmpty) {
                  return const Center(child: Text('Aucun match disponible.'));
                }
                return ListView.builder(
                  itemCount: state.matches.length,
                  itemBuilder: (context, index) {
                    final match = state.matches[index];
                    final activeBets = match.bets.where((bet) => bet.isActive);
                    if (activeBets.isEmpty) return const SizedBox.shrink();
                    return ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: Text('${match.home.name} - ${match.away.name}'),
                      children: activeBets
                          .map((bet) {
                            final selected = _selections[bet.id];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(bet.category),
                                  Wrap(
                                    spacing: 8,
                                    children: bet.odds.entries
                                        .map((odd) {
                                          final isSelected =
                                              selected?.key == odd.key;
                                          return ChoiceChip(
                                            label: Text(
                                              '${odd.key} ${odd.value}',
                                            ),
                                            selected: isSelected,
                                            onSelected: (value) => setState(() {
                                              if (value) {
                                                _selections[bet.id] = MapEntry(
                                                  odd.key,
                                                  odd.value,
                                                );
                                              } else {
                                                _selections.remove(bet.id);
                                              }
                                            }),
                                          );
                                        })
                                        .toList(growable: false),
                                  ),
                                ],
                              ),
                            );
                          })
                          .toList(growable: false),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Annuler'),
      ),
      FilledButton(onPressed: _submit, child: const Text('Créer')),
    ],
  );
}

class _CouponTile extends StatelessWidget {
  const _CouponTile({required this.coupon, required this.tournoiId});

  final UserCoupon coupon;
  final String tournoiId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTournament = coupon.kind == UserCouponKind.tournament;
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) =>
                CouponDetailScreen(coupon: coupon, tournoiId: tournoiId),
          ),
        ),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isTournament
                        ? Icons.emoji_events_outlined
                        : Icons.sports_soccer,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isTournament ? 'Coupon tournoi' : 'Coupon matchs',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  Text(coupon.status, style: theme.textTheme.labelMedium),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 20,
                runSpacing: 8,
                children: [
                  _CouponValue(label: 'Paris', value: '${coupon.betCount}'),
                  _CouponValue(
                    label: 'Cote totale',
                    value: '${coupon.totalOdds ?? '-'}',
                  ),
                  _CouponValue(label: 'Mise', value: '${coupon.amount ?? '-'}'),
                  _CouponValue(
                    label: 'Gain potentiel',
                    value: '${coupon.gains ?? '-'}',
                  ),
                ],
              ),
              if (coupon.isPaid) ...[
                const SizedBox(height: 10),
                Text('Gain payé', style: theme.textTheme.labelMedium),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CouponValue extends StatelessWidget {
  const _CouponValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: Theme.of(context).textTheme.labelSmall),
      Text(value, style: Theme.of(context).textTheme.bodyMedium),
    ],
  );
}

class _CouponMessage extends StatelessWidget {
  const _CouponMessage({required this.message, this.action});

  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          if (action != null) ...[const SizedBox(height: 8), action!],
        ],
      ),
    ),
  );
}
