import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:petitpotopro/common/helpers/style.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';
import 'package:petitpotopro/features/tournoi/domain/entities/tournoi_entity.dart';
import 'package:petitpotopro/features/tournoi/presentation/pages/tournament_transition_screen.dart';

class TournamentCard extends StatelessWidget {
  final TournoiEntity tournament;

  const TournamentCard({super.key, required this.tournament});

  static const _textDark = Color(0xFF14201B);
  static const _textGrey = Color(0xFF5F6B66);
  static const _green = Color(0xFF0E7C4A);
  static const _liveRed = Color(0xFFD32F2F);

  // Le status reste un String : on l'affiche tel quel.
  // On s'en sert uniquement pour choisir la couleur/l'icône du badge.
  bool get _isLive {
    final s = tournament.status.toLowerCase();
    return s.contains('cours') || s.contains('live') || s.contains('ongoing');
  }

  bool get _isFinished {
    final s = tournament.status.toLowerCase();
    return s.contains('termin') || s.contains('finish') || s.contains('ended');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.push(
              TournamentTransitionScreen.route,
              extra: tournament,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              tournament.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: StyleText().title.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: _textDark,
                                height: 1.2,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: _textGrey,
                          ),
                        ],
                      ),
                      if (tournament.editionName.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          tournament.editionName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: StyleText().desc.copyWith(
                            fontSize: 14,
                            color: _textGrey,
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      _InfoRow(
                        icon: Icons.apartment_rounded,
                        text:
                            tournament.organization?.name ??
                            'Édition ${tournament.edition}',
                        iconColor: AppColors.primary,
                        bg: const Color(0xFFE6F0EC),
                      ),
                      const SizedBox(height: 10),
                      _InfoRow(
                        icon: Icons.calendar_month_outlined,
                        text: 'Saison ${tournament.annee.year}',
                        iconColor: const Color(0xFFB8621B),
                        bg: const Color(0xFFFFEFDC),
                      ),
                      _buildFooter(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ───────────── Image + badges ─────────────
  Widget _buildImage() {
    final logo = tournament.organization?.logo;
    return SizedBox(
      height: 156,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0B5D3B), Color(0xFF1E8A5A)],
              ),
            ),
            child: logo == null || logo.isEmpty
                ? const _LogoFallback()
                : Padding(
                    padding: const EdgeInsets.all(28),
                    child: SvgPicture.network(
                      logo,
                      fit: BoxFit.contain,
                      placeholderBuilder: (_) => const _LogoFallback(),
                      errorBuilder: (_, __, ___) => const _LogoFallback(),
                    ),
                  ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
          Positioned(top: 12, right: 12, child: _buildStatusBadge()),
          Positioned(
            left: 12,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.emoji_events_outlined,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Édition ${tournament.edition} • ${tournament.annee.year}',
                    style: StyleText().captionBold.copyWith(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    final Color color = _isLive
        ? _liveRed
        : _isFinished
        ? _textGrey
        : const Color(0xFF8A4B00);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isLive)
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            )
          else
            Icon(
              _isFinished
                  ? Icons.check_circle_outline_rounded
                  : Icons.schedule_rounded,
              size: 14,
              color: color,
            ),
          const SizedBox(width: 6),
          Text(
            tournament.status.toUpperCase(),
            style: StyleText().captionBold.copyWith(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  // ───────────── Footer ─────────────
  Widget _buildFooter() {
    if (_isFinished) {
      return Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Archives & Statistiques',
              style: StyleText().caption.copyWith(
                color: _textGrey,
                fontSize: 13.5,
              ),
            ),
            Text(
              'CONSULTER LE TABLEAU',
              style: StyleText().captionBold.copyWith(
                color: _textGrey,
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      );
    }

    if (!tournament.ticketsEnabled && !tournament.bettingEnabled) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        children: [
          if (tournament.ticketsEnabled)
            const _FeaturePill(
              icon: Icons.confirmation_number_outlined,
              label: 'Billetterie ouverte',
            ),
          if (tournament.ticketsEnabled && tournament.bettingEnabled)
            const SizedBox(width: 8),
          if (tournament.bettingEnabled)
            const _FeaturePill(
              icon: Icons.sports_score_rounded,
              label: 'Paris ouverts',
            ),
        ],
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  const _FeaturePill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F0EC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: TournamentCard._green),
          const SizedBox(width: 6),
          Text(
            label,
            style: StyleText().captionBold.copyWith(
              color: TournamentCard._green,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
    required this.iconColor,
    required this.bg,
  });

  final IconData icon;
  final String text;
  final Color iconColor;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, size: 17, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StyleText().body.copyWith(
              fontSize: 15,
              color: Color(0xFF2A3833),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _LogoFallback extends StatelessWidget {
  const _LogoFallback();

  @override
  Widget build(BuildContext context) => Center(
    child: Icon(
      Icons.emoji_events_rounded,
      size: 64,
      color: AppColors.white.withValues(alpha: 0.75),
    ),
  );
}
