import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:petitpotopro/common/helpers/style.dart';
import 'package:petitpotopro/common/widgets/navigation/navigation_widget.dart';
import 'package:petitpotopro/core/configs/theme/app_colors.dart';
import 'package:petitpotopro/features/tournoi/domain/entities/tournoi_entity.dart';

class TournamentCard extends StatelessWidget {
  final TournoiEntity tournament;

  const TournamentCard({super.key, required this.tournament});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(NavigationWidget.route, extra: tournament.id);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        shadowColor: AppColors.neutral.withValues(alpha: 0.12),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 156,
                  width: double.infinity,
                  child: ColoredBox(
                    color: AppColors.primary,
                    child: tournament.organization?.logo == null
                        ? Center(
                            child: Icon(
                              Icons.emoji_events_rounded,
                              size: 72,
                              color: AppColors.white.withValues(alpha: 0.8),
                            ),
                          )
                        : SvgPicture.network(
                            tournament.organization?.logo ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Center(
                              child: Icon(
                                Icons.emoji_events_rounded,
                                size: 72,
                                color: AppColors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.neutral.withValues(alpha: 0.84),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tournament.status,
                      style: StyleText().captionBold.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tournament.name, style: StyleText().subtitle),
                  const SizedBox(height: 7),
                  Text(
                    tournament.editionName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: StyleText().desc,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(
                        Icons.sports_soccer_rounded,
                        size: 17,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          tournament.organization?.name ??
                              'Édition ${tournament.edition}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: StyleText().captionBold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
