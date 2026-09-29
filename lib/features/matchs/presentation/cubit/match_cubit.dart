import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petitpotopro/features/matchs/domain/usecases/get_all_matches_usecase.dart';
import 'package:petitpotopro/features/matchs/presentation/cubit/match_state.dart';

class MatchCubit extends Cubit<MatchState> {
  MatchCubit(this._getAllMatches) : super(const MatchState());

  final GetAllMatchesUseCase _getAllMatches;

  Future<void> getAll(String tournoiId) async {
    if (state.isLoading) return;
    emit(const MatchState(isLoading: true));

    final result = await _getAllMatches(tournoiId);
    if (isClosed) return;

    result.fold(
      (failure) => emit(MatchState(errorMessage: failure.message)),
      (matches) => emit(MatchState(matches: matches)),
    );
  }
}
