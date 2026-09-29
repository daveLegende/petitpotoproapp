import 'package:petitpotopro/core/utils/json_utils.dart';
import 'package:petitpotopro/features/organization/domain/entities/organization_entity.dart';

class OrganizationModel extends OrganizationEntity {
   const OrganizationModel({
     required super.id,
     required super.name,
     required super.slug,
     required super.description,
     required super.logo,
     required super.status,
   });
   

   factory OrganizationModel.fromJson(Map<String, dynamic> json) {

    return OrganizationModel(
      id: string0(json, 'id'),
      name: string0(json, 'name'),
      slug: string0(json, 'slug'),
      description: string0(json, 'description'),
      logo: string0(json, 'logo'),
      status: string0(json, 'status'),
    );
  }

  OrganizationEntity toEntity() => OrganizationEntity(
    id: id,
    name: name,
    slug: slug,
    description: description,
    logo: logo,
    status: status,
  );
 }