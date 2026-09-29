import 'package:equatable/equatable.dart';
import 'package:petitpotopro/features/matchs/domain/entities/match_entity.dart';

class MatchState extends Equatable {
  const MatchState({
    this.isLoading = false,
    this.matches = const [],
    this.errorMessage,
  });

  final bool isLoading;
  final List<MatchEntity> matches;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, matches, errorMessage];
}
