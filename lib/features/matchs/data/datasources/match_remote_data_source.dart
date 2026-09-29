import 'package:dio/dio.dart';
import 'package:petitpotopro/core/network/api_url.dart';
import 'package:petitpotopro/features/matchs/data/models/match_model.dart';

abstract class MatchRemoteDataSource {
  Future<List<MatchModel>> getAll(String tournoiId);
}

class MatchRemoteDataSourceImpl implements MatchRemoteDataSource {
  const MatchRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<MatchModel>> getAll(String tournoiId) async {
    final matches = <MatchModel>[];
    var page = 1;

    while (true) {
      final response = await _dio.get<dynamic>(
        ApiUrl.matchs,
        queryParameters: {'tournoiId': tournoiId, 'page': page},
      );
      final result = MatchPageModel.fromBody(response.data);
      matches.addAll(result.data);

      if (result.data.isEmpty || page >= result.totalPages) break;
      page++;
    }

    return matches;
  }
}
