import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:petitpotopro/common/widgets/navigation/navigation_widget.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';
import 'package:petitpotopro/features/tournoi/domain/entities/tournoi_entity.dart';

class TournamentTransitionScreen extends StatefulWidget {
  static const route = '/tournament-transition';

  const TournamentTransitionScreen({super.key, required this.tournament});

  final TournoiEntity tournament;

  @override
  State<TournamentTransitionScreen> createState() =>
      _TournamentTransitionScreenState();
}

class _TournamentTransitionScreenState
    extends State<TournamentTransitionScreen> {
  @override
  void initState() {
    super.initState();
    _continueToTournament();
  }

  Future<void> _continueToTournament() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    context.replace(
      NavigationWidget.route,
      extra: widget.tournament.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final logo = widget.tournament.organization?.logo;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 180,
                height: 180,
                child: logo == null || logo.isEmpty
                    ? Image.asset(
                        'assets/images/logo/logo.png',
                        fit: BoxFit.contain,
                      )
                    : SvgPicture.network(
                        logo,
                        fit: BoxFit.contain,
                        placeholderBuilder: (_) => Image.asset(
                          'assets/images/logo/logo.png',
                          fit: BoxFit.contain,
                        ),
                        errorBuilder: (_, __, ___) => Image.asset(
                          'assets/images/logo/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
              ),
              const SizedBox(height: 24),
              Text(
                widget.tournament.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.neutral,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (widget.tournament.editionName.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  widget.tournament.editionName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkGrey,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
