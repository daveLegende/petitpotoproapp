import 'package:equatable/equatable.dart';
import 'package:petitpotopro/features/organization/domain/entities/organization_entity.dart';

class TournoiEntity extends Equatable {
  const TournoiEntity({
    required this.id,
    required this.name,
    required this.editionName,
    required this.edition,
    required this.annee,
    required this.status,
    required this.slug,
    required this.ticketsEnabled,
    required this.bettingEnabled,
    required this.organization,
  });

  final String id;
  final String name;
  final String editionName;
  final int edition;
  final DateTime annee;
  final String status;

  final String slug;
  final bool ticketsEnabled, bettingEnabled;
  final OrganizationEntity? organization;

  @override
  List<Object?> get props => [
    id,
    name,
    editionName,
    edition,
    annee,
    status,
    slug,
    ticketsEnabled,
    bettingEnabled,
    organization,
  ];
}
