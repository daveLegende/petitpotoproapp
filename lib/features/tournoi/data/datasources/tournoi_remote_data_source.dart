import 'package:dio/dio.dart';
import 'package:petitpotopro/core/network/api_url.dart';
import 'package:petitpotopro/features/tournoi/data/models/tournoi_model.dart';

abstract class TournoiRemoteDataSource {
  Future<List<TournoiModel>> getAll();
}

class TournoiRemoteDataSourceImpl implements TournoiRemoteDataSource {
  const TournoiRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<TournoiModel>> getAll() async {
    final tournois = <TournoiModel>[];
    var page = 1;

    while (true) {
      final response = await _dio.get<dynamic>(
        ApiUrl.tournois,
        queryParameters: {'page': page},
      );
      final result = TournoiPageModel.fromBody(response.data);
      tournois.addAll(result.data);

      if (result.data.isEmpty || page >= result.totalPages) break;
      page++;
    }

    return tournois;
  }
}
