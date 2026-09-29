import 'package:equatable/equatable.dart';

class ScoreEntity extends Equatable {
  const ScoreEntity({required this.home, required this.away});

  final int home;
  final int away;

  @override
  List<Object?> get props => [home, away];
}
