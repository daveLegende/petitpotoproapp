import 'package:dio/dio.dart';
import 'package:petitpotopro/core/network/api_url.dart';
import 'package:petitpotopro/core/utils/json_utils.dart';

class MatchEventRemoteDataSource {
  const MatchEventRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<Map<String, dynamic>>> getForMatch({
    required String matchId,
    required String tournoiId,
  }) async {
    final response = await _dio.get<dynamic>(
      '${ApiUrl.matchEvents}/$matchId',
      queryParameters: {'tournoiId': tournoiId},
    );
    return _extractRows(response.data);
  }

  Future<dynamic> updateForMatch({
    required String matchId,
    required String tournoiId,
    required List<Map<String, dynamic>> events,
  }) async =>
      (await _dio.patch<dynamic>(
        '${ApiUrl.matchEvents}/$matchId',
        data: {'id': matchId, 'tournoiId': tournoiId, 'events': events},
      )).data;

  List<Map<String, dynamic>> _extractRows(dynamic body) {
    if (body is List) {
      return body.whereType<Map>().map(Map<String, dynamic>.from).toList();
    }
    final root = asMap(body);
    if (root == null) return const [];

    for (final key in ['data', 'events', 'items', 'results']) {
      final value = root[key];
      if (value is List) {
        return value.whereType<Map>().map(Map<String, dynamic>.from).toList();
      }
      if (value is Map) {
        final rows = _extractRows(value);
        if (rows.isNotEmpty) return rows;
      }
    }
    return const [];
  }
}