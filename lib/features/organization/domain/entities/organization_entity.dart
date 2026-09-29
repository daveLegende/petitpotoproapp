import 'package:equatable/equatable.dart';

class OrganizationEntity extends Equatable {
   const OrganizationEntity({
     required this.id,
     required this.name,
     required this.slug,
     required this.description,
     required this.logo,
     required this.status,
   });

   final String id;
   final String name;
   final String description;
   final String logo;
    final String slug;
    final String status;

   @override
   List<Object?> get props => [id, name, description, logo, slug, status];
 }