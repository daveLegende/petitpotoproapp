import 'package:equatable/equatable.dart';

class MatchEventEntity extends Equatable {
  const MatchEventEntity({
    required this.type,
    this.minute,
    this.description,
    this.playerName,
    this.teamName,
  });

  final String type;
  final String? minute;
  final String? description;
  final String? playerName;
  final String? teamName;

  @override
  List<Object?> get props => [type, minute, description, playerName, teamName];
}
