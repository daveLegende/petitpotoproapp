import 'package:flutter/material.dart';
import 'package:petitpotopro/common/helpers/style.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';
import 'package:petitpotopro/features/matchs/presentation/pages/match_screen.dart';

class NavigationWidget extends StatefulWidget {
  static const route = '/navigation';

  final String tournoiId;

  const NavigationWidget({super.key, required this.tournoiId});

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  int _currentIndex = 0;

  late final _pages = [
    MatchScreen(tournoiId: widget.tournoiId),
    _NavigationPlaceholder(
      title: 'Mes paris',
      icon: Icons.sports_soccer_rounded,
    ),
    _NavigationPlaceholder(
      title: 'Mes tickets',
      icon: Icons.confirmation_number_outlined,
    ),
    _NavigationPlaceholder(title: 'Profil', icon: Icons.person_outline_rounded),
  ];

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
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: _showEvents,
        tooltip: 'Choisir un événement',
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 4,
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 76,
        color: AppColors.white,
        elevation: 10,
        shape: const _NavigationNotch(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavigationItem(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home_rounded,
              label: 'Matchs',
              selected: _currentIndex == 0,
              onPressed: () => setState(() => _currentIndex = 0),
            ),
            _NavigationItem(
              icon: Icons.sports_soccer_outlined,
              selectedIcon: Icons.sports_soccer_rounded,
              label: 'Mes paris',
              selected: _currentIndex == 1,
              onPressed: () => setState(() => _currentIndex = 1),
            ),
            const SizedBox(width: 64),
            _NavigationItem(
              icon: Icons.confirmation_number_outlined,
              selectedIcon: Icons.confirmation_number,
              label: 'Mes tickets',
              selected: _currentIndex == 2,
              onPressed: () => setState(() => _currentIndex = 2),
            ),
            _NavigationItem(
              icon: Icons.person_outline_rounded,
              selectedIcon: Icons.person_rounded,
              label: 'Profil',
              selected: _currentIndex == 3,
              onPressed: () => setState(() => _currentIndex = 3),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  const _NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

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
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 64,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(selected ? selectedIcon : icon, color: color, size: 23),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: StyleText().captionBold.copyWith(
                    color: color,
                    fontSize: 10,
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

class _NavigationNotch extends NotchedShape {
  const _NavigationNotch();

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null || !guest.overlaps(host)) {
      return Path()..addRect(host);
    }

    final notchLeft = guest.center.dx - 38;
    final notchRight = guest.center.dx + 38;
    final path = Path()..moveTo(host.left, host.top);
    path.lineTo(notchLeft, host.top);
    path.quadraticBezierTo(
      guest.center.dx,
      host.top + 30,
      notchRight,
      host.top,
    );
    path.lineTo(host.right, host.top);
    path.lineTo(host.right, host.bottom);
    path.lineTo(host.left, host.bottom);
    path.close();
    return path;
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

class _NavigationPlaceholder extends StatelessWidget {
  final String title;
  final IconData icon;

  const _NavigationPlaceholder({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(title, style: StyleText().headBlack),
          ],
        ),
      ),
    );
  }
}
