import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:petitpotopro/common/helpers/style.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';
import 'package:petitpotopro/core/widgets/auth_required_view.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_state.dart';
import 'package:petitpotopro/features/auth/presentation/pages/login_page.dart';
import 'package:petitpotopro/features/coupons/presentation/pages/user_coupons_screen.dart';
import 'package:petitpotopro/features/matchs/presentation/pages/match_screen.dart';
import 'package:petitpotopro/features/tickets/presentation/pages/user_tickets_screen.dart';
import 'package:petitpotopro/features/tournoi/presentation/pages/tournament_space_screen.dart';

class NavigationWidget extends StatefulWidget {
  static const route = '/navigation';

  final String tournoiId;
  final int initialTab;

  const NavigationWidget({
    super.key,
    required this.tournoiId,
    this.initialTab = 0,
  });

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab.clamp(0, 3);
  }

  void _selectTab(int index) {
    setState(() => _currentIndex = index);
  }

  void _showEvents() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const _EventPicker(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.isAuthenticated && !current.isAuthenticated,
      listener: (context, _) => setState(() => _currentIndex = 0),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final isAuthenticated = authState.isAuthenticated;
          return Scaffold(
            extendBody: true,
            body: IndexedStack(
              index: _currentIndex,
              children: [
                MatchScreen(tournoiId: widget.tournoiId),
                isAuthenticated
                    ? UserTicketsScreen(tournoiId: widget.tournoiId)
                    : _authenticationPrompt(
                        context,
                        tab: 1,
                        message: 'Pour acheter des tickets, connectez-vous à votre compte ou créez-en un.',
                      ),
                isAuthenticated
                    ? UserCouponsScreen(tournoiId: widget.tournoiId)
                    : _authenticationPrompt(
                        context,
                        tab: 2,
                        message: 'Pour effectuer des paris, connectez-vous à votre compte ou créez-en un.',
                      ),
                TournamentSpaceScreen(tournoiId: widget.tournoiId),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: isAuthenticated
                  ? _showEvents
                  : () => _selectTab(2),
              tooltip: isAuthenticated
                  ? 'Choisir un événement'
                  : 'Se connecter pour parier',
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              child: const Icon(Icons.add_rounded, size: 28),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              height: 76,
              color: AppColors.white,
              elevation: 10,
              shape: const CircularNotchedRectangle(),
              notchMargin: 8,
              child: Row(
                children: [
                  _NavigationItem(
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home_rounded,
                    label: 'Home',
                    selected: _currentIndex == 0,
                    onPressed: () => _selectTab(0),
                  ),
                  _NavigationItem(
                    icon: Icons.confirmation_number_outlined,
                    selectedIcon: Icons.confirmation_number_rounded,
                    label: 'Tickets',
                    selected: _currentIndex == 1,
                    onPressed: () => _selectTab(1),
                  ),
                  const SizedBox(width: 64),
                  _NavigationItem(
                    icon: Icons.sports_soccer_outlined,
                    selectedIcon: Icons.sports_soccer_rounded,
                    label: 'Paris',
                    selected: _currentIndex == 2,
                    onPressed: () => _selectTab(2),
                  ),
                  _NavigationItem(
                    icon: Icons.emoji_events_outlined,
                    selectedIcon: Icons.emoji_events_rounded,
                    label: 'Espace tournoi',
                    selected: _currentIndex == 3,
                    onPressed: () => _selectTab(3),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _authenticationPrompt(
    BuildContext context, {
    required int tab,
    required String message,
  }) {
    return AuthRequiredView(
      message: message,
      onSignIn: () {
        final destination = Uri(
          path: NavigationWidget.route,
          queryParameters: {'tournoiId': widget.tournoiId, 'tab': '$tab'},
        ).toString();
        context.go(
          Uri(
            path: LoginPage.route,
            queryParameters: {'redirect': destination},
          ).toString(),
        );
      },
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.grey;
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            height: 64,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(selected ? selectedIcon : icon, color: color, size: 23),
                const SizedBox(height: 3),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: StyleText().captionBold.copyWith(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EventPicker extends StatelessWidget {
  const _EventPicker();

  static const events = [
    ('Real Madrid - Inter', 'Ce soir, 21:00'),
    ('PSG - Marseille', 'Demain, 20:45'),
    ('Liverpool - Arsenal', 'Samedi, 18:30'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choisir un événement', style: StyleText().headBlack),
            const SizedBox(height: 6),
            Text(
              'Sélectionnez le match sur lequel vous souhaitez parier.',
              style: StyleText().desc,
            ),
            const SizedBox(height: 16),
            ...events.map(
              (event) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: AppColors.bgColor,
                  child: Icon(
                    Icons.sports_soccer_rounded,
                    color: AppColors.primary,
                  ),
                ),
                title: Text(event.$1, style: StyleText().subtitle),
                subtitle: Text(event.$2, style: StyleText().caption),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.pop(context, event.$1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
