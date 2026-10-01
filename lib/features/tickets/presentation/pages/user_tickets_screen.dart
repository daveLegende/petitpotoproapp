import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:petitpotopro/core/di/service_locator.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:petitpotopro/features/matchs/presentation/cubit/match_cubit.dart';
import 'package:petitpotopro/features/matchs/presentation/cubit/match_state.dart';
import 'package:petitpotopro/features/tickets/domain/entities/ticket_purchase.dart';
import 'package:petitpotopro/features/tickets/domain/entities/user_ticket.dart';
import 'package:petitpotopro/features/tickets/presentation/cubit/user_tickets_cubit.dart';

class UserTicketsScreen extends StatelessWidget {
  const UserTicketsScreen({super.key, required this.tournoiId});

  final String tournoiId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UserTicketsCubit>()..load(),
      child: _UserTicketsView(tournoiId: tournoiId),
    );
  }
}

class _UserTicketsView extends StatefulWidget {
  const _UserTicketsView({required this.tournoiId});

  final String tournoiId;

  @override
  State<_UserTicketsView> createState() => _UserTicketsViewState();
}

class _UserTicketsViewState extends State<_UserTicketsView> {
  int _filter = 0;

  String _bucket(UserTicket ticket) {
    final status = ticket.status.toLowerCase();
    if (status.contains('utilis') || status.contains('used')) return 'Utilisés';
    if (status.contains('expir') || status.contains('expired')) {
      return 'Expirés';
    }
    return 'Actifs';
  }

  Future<void> _purchase(BuildContext context) async {
    final userId = sl<AuthBloc>().state.user?.id;
    if (userId == null || userId.isEmpty) return;

    final request = await showDialog<TicketPurchase>(
      context: context,
      builder: (_) => BlocProvider<MatchCubit>(
        create: (_) => sl<MatchCubit>()..getAll(widget.tournoiId),
        child: _TicketPurchaseDialog(
          tournoiId: widget.tournoiId,
          userId: userId,
        ),
      ),
    );
    if (request == null || !context.mounted) return;

    final succeeded = await context.read<UserTicketsCubit>().purchase(request);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          succeeded ? 'Ticket acheté.' : 'Achat impossible. Réessayez.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes tickets'),
        actions: [
          IconButton(
            tooltip: 'Acheter un ticket',
            onPressed: () => _purchase(context),
            icon: const Icon(Icons.add_card_outlined),
          ),
        ],
      ),
      body: BlocBuilder<UserTicketsCubit, UserTicketsState>(
        builder: (context, state) {
          if (state.isLoading && state.tickets.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null && state.tickets.isEmpty) {
            return _TicketMessage(
              message: state.errorMessage!,
              action: TextButton.icon(
                onPressed: () => context.read<UserTicketsCubit>().load(),
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            );
          }
          if (state.tickets.isEmpty) {
            return const _TicketMessage(
              message: 'Vous n’avez pas encore de ticket.',
            );
          }

          const labels = ['Actifs', 'Utilisés', 'Expirés'];
          final tickets = state.tickets
              .where((ticket) => _bucket(ticket) == labels[_filter])
              .toList(growable: false);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: SegmentedButton<int>(
                  segments: [
                    for (var i = 0; i < labels.length; i++)
                      ButtonSegment(value: i, label: Text(labels[i])),
                  ],
                  selected: {_filter},
                  onSelectionChanged: (value) =>
                      setState(() => _filter = value.first),
                ),
              ),
              Expanded(
                child: tickets.isEmpty
                    ? const _TicketMessage(
                        message: 'Aucun ticket dans cette catégorie.',
                      )
                    : RefreshIndicator(
                        onRefresh: () =>
                            context.read<UserTicketsCubit>().load(),
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16),
                          itemCount: tickets.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) =>
                              _TicketTile(ticket: tickets[index]),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TicketPurchaseDialog extends StatefulWidget {
  const _TicketPurchaseDialog({required this.tournoiId, required this.userId});

  final String tournoiId;
  final String userId;

  @override
  State<_TicketPurchaseDialog> createState() => _TicketPurchaseDialogState();
}

class _TicketPurchaseDialogState extends State<_TicketPurchaseDialog> {
  final _amountController = TextEditingController();
  final _selectedMatchIds = <String>{};
  String _type = 'STANDARD';
  String _duration = 'SIMPLE';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    final amount = num.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0 || _selectedMatchIds.isEmpty) return;
    Navigator.of(context).pop(
      TicketPurchase(
        userId: widget.userId,
        type: _type,
        duration: _duration,
        amount: amount,
        matchIds: _selectedMatchIds.toList(growable: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Acheter un ticket'),
    content: SizedBox(
      width: 420,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _type,
            decoration: const InputDecoration(labelText: 'Type'),
            items: const [
              DropdownMenuItem(value: 'STANDARD', child: Text('Standard')),
              DropdownMenuItem(value: 'VIP', child: Text('VIP')),
              DropdownMenuItem(value: 'RECRUTEUR', child: Text('Recruteur')),
            ],
            onChanged: (value) => setState(() => _type = value ?? _type),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _duration,
            decoration: const InputDecoration(labelText: 'Durée'),
            items: const [
              DropdownMenuItem(value: 'SIMPLE', child: Text('Match choisi')),
              DropdownMenuItem(
                value: 'PHASE DE POULE',
                child: Text('Phase de poules'),
              ),
              DropdownMenuItem(
                value: 'TOURNOI COMPLET',
                child: Text('Tournoi complet'),
              ),
            ],
            onChanged: (value) =>
                setState(() => _duration = value ?? _duration),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Montant',
              prefixIcon: Icon(Icons.payments_outlined),
            ),
          ),
          const SizedBox(height: 12),
          Text('Matchs inclus', style: Theme.of(context).textTheme.titleSmall),
          SizedBox(
            height: 180,
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
                    return CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: _selectedMatchIds.contains(match.id),
                      title: Text('${match.home.name} - ${match.away.name}'),
                      onChanged: (selected) => setState(() {
                        if (selected == true) {
                          _selectedMatchIds.add(match.id);
                        } else {
                          _selectedMatchIds.remove(match.id);
                        }
                      }),
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
      FilledButton(onPressed: _submit, child: const Text('Acheter')),
    ],
  );
}

class _TicketTile extends StatelessWidget {
  const _TicketTile({required this.ticket});

  final UserTicket ticket;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final date = ticket.date;
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          foregroundColor: theme.colorScheme.primary,
          child: const Icon(Icons.confirmation_number_outlined),
        ),
        title: Text(ticket.type, style: theme.textTheme.titleMedium),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            [
              if (ticket.duration.isNotEmpty) ticket.duration,
              if (ticket.matchCount > 0)
                '${ticket.matchCount} match${ticket.matchCount > 1 ? 's' : ''}',
              if (date != null) DateFormat('dd/MM/yyyy').format(date.toLocal()),
            ].join(' · '),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(ticket.status, style: theme.textTheme.labelMedium),
            if (ticket.amount != null)
              Text('${ticket.amount}', style: theme.textTheme.bodySmall),
          ],
        ),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => TicketDetailScreen(ticket: ticket),
          ),
        ),
      ),
    );
  }
}

class TicketDetailScreen extends StatelessWidget {
  const TicketDetailScreen({super.key, required this.ticket});

  final UserTicket ticket;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Détail du ticket')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        QrImageView(
                          data: ticket.id,
                          version: QrVersions.auto,
                          size: 240,
                          backgroundColor: Colors.white,
                          semanticsLabel: 'QR code du ticket ${ticket.id}',
                        ),
                        const SizedBox(height: 12),
                        Text(ticket.type, style: theme.textTheme.titleLarge),
                        const SizedBox(height: 6),
                        Text(ticket.status, style: theme.textTheme.labelLarge),
                        if (ticket.position.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text('Place ${ticket.position}'),
                        ],
                        if (ticket.date != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('dd/MM/yyyy')
                                .format(ticket.date!.toLocal()),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SelectableText('Référence : ${ticket.id}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TicketMessage extends StatelessWidget {
  const _TicketMessage({required this.message, this.action});

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
