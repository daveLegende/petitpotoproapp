import 'package:equatable/equatable.dart';

class PlayerEntity extends Equatable {
  const PlayerEntity({
    required this.id,
    required this.name,
    this.age,
    this.phone,
    this.avatar,
  });

  final String id;
  final String name;
  final int? age;
  final String? phone;
  final String? avatar;

  @override
  List<Object?> get props => [id, name, age, phone, avatar];
}

class PlayerRegistrationEntity extends Equatable {
  const PlayerRegistrationEntity({
    required this.id,
    required this.numeroMaillot,
    required this.poste,
    required this.buts,
    required this.passes,
    required this.statut,
    required this.player,
  });

  final String id;
  final int numeroMaillot;
  final String poste;
  final int buts;
  final int passes;
  final String statut;
  final PlayerEntity player;

  @override
  List<Object?> get props => [
    id,
    numeroMaillot,
    poste,
    buts,
    passes,
    statut,
    player,
  ];
}
