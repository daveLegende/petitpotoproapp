import 'package:petitpotopro/core/utils/json_utils.dart';
import 'package:petitpotopro/features/organization/data/models/organization_model.dart';
import 'package:petitpotopro/features/tournoi/domain/entities/tournoi_entity.dart';

class TournoiModel extends TournoiEntity{
  const TournoiModel({
    required super.id,
    required super.name,
    required super.editionName,
    required super.edition,
    required super.annee,
    required super.status,
    required super.slug,
    required super.ticketsEnabled,
    required super.bettingEnabled,
    required super.organization,
  });

  factory TournoiModel.fromJson(Map<String, dynamic> json) {
    final rawOrganization = json['organization'];
    final organization = rawOrganization is Map
        ? OrganizationModel.fromJson(Map<String, dynamic>.from(rawOrganization))
        : null;

    return TournoiModel(
      id: string0(json, 'id'),
      name: string0(json, 'name'),
      editionName: string0(json, 'editionName'),
      edition: integer0(json, 'edition'),
      annee: date0(json, 'annee'),
      status: string0(json, 'status'),
      slug: string0(json, 'slug'),
      ticketsEnabled: boolean0(json, 'ticketsEnabled'),
      bettingEnabled: boolean0(json, 'bettingEnabled'),
      organization: organization,
    );
  }

  TournoiEntity toEntity() => TournoiEntity(
    id: id,
    name: name,
    editionName: editionName,
    edition: edition,
    annee: annee,
    status: status,
    slug: slug,
    ticketsEnabled: ticketsEnabled,
    bettingEnabled: bettingEnabled,
    organization: organization,
  );

  
}

class TournoiPageModel {
  const TournoiPageModel({
    required this.data,
    required this.page,
    required this.totalPages,
  });

  final List<TournoiModel> data;
  final int page;
  final int totalPages;

  factory TournoiPageModel.fromBody(dynamic body) {
    if (body is! Map) {
      throw const FormatException('Réponse tournoi invalide.');
    }
    final json = Map<String, dynamic>.from(body);
    final rawData = json['data'];
    if (rawData is! List) {
      throw const FormatException('Liste des tournois introuvable.');
    }

    return TournoiPageModel(
      data: rawData
          .map((item) {
            if (item is! Map) {
              throw const FormatException('Tournoi invalide dans la réponse.');
            }
            return TournoiModel.fromJson(Map<String, dynamic>.from(item));
          })
          .toList(growable: false),
      page: _pageNumber(json['page'], fallback: 1),
      totalPages: _pageNumber(json['totalPages'], fallback: 1),
    );
  }

  static int _pageNumber(dynamic value, {required int fallback}) => value is int
      ? value
      : value is num
      ? value.toInt()
      : fallback;
}
