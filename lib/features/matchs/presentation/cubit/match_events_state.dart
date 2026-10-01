import 'package:equatable/equatable.dart';
import 'package:petitpotopro/features/matchs/domain/entities/match_event_entity.dart';

class MatchEventsState extends Equatable {
  const MatchEventsState({
    this.events = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<MatchEventEntity> events;
  final bool isLoading;
  final String? errorMessage;

  @override
  List<Object?> get props => [events, isLoading, errorMessage];
}
