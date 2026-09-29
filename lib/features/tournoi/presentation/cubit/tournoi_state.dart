import 'package:equatable/equatable.dart';
import 'package:petitpotopro/features/tournoi/domain/entities/tournoi_entity.dart';

class TournoiState extends Equatable {
  const TournoiState({
    this.isLoading = false,
    this.tournois = const [],
    this.errorMessage,
  });

  final bool isLoading;
  final List<TournoiEntity> tournois;
  final String? errorMessage;

  @override
  List<Object?> get props => [isLoading, tournois, errorMessage];
}
