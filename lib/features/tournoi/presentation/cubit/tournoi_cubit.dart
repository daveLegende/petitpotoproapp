import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petitpotopro/core/usecases/usecase.dart';
import 'package:petitpotopro/features/tournoi/domain/usecases/tournoi_usecase.dart';
import 'package:petitpotopro/features/tournoi/presentation/cubit/tournoi_state.dart';

class TournoiCubit extends Cubit<TournoiState> {
  TournoiCubit(this._getAllTournois) : super(const TournoiState());

  final TournoiUseCase _getAllTournois;

  Future<void> getAll() async {
    if (state.isLoading) return;
    emit(TournoiState(isLoading: true, tournois: state.tournois));

    final result = await _getAllTournois(const NoParams());
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        TournoiState(tournois: state.tournois, errorMessage: failure.message),
      ),
      (tournois) => emit(TournoiState(tournois: tournois)),
    );
  }
}
