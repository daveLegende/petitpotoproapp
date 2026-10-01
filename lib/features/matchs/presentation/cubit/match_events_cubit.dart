import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petitpotopro/features/matchs/domain/usecases/get_match_events_usecase.dart';
import 'package:petitpotopro/features/matchs/presentation/cubit/match_events_state.dart';

class MatchEventsCubit extends Cubit<MatchEventsState> {
  MatchEventsCubit(this._getMatchEvents) : super(const MatchEventsState());

  final GetMatchEventsUseCase _getMatchEvents;

  Future<void> load({
    required String matchId,
    required String tournoiId,
  }) async {
    emit(MatchEventsState(events: state.events, isLoading: true));
    final result = await _getMatchEvents(
      MatchEventsParams(matchId: matchId, tournoiId: tournoiId),
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        MatchEventsState(events: state.events, errorMessage: failure.message),
      ),
      (events) => emit(MatchEventsState(events: events)),
    );
  }
}
