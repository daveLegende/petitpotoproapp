import 'package:dio/dio.dart';
import 'package:petitpotopro/core/network/api_dto.dart';
import 'package:petitpotopro/core/network/api_url.dart';
import 'package:petitpotopro/core/utils/json_utils.dart';

class PouleRemoteDataSource {
  const PouleRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<Map<String, dynamic>>> getAll({String? tournoiId}) async {
    final poules = <Map<String, dynamic>>[];
    var page = 1;
    var totalPages = 1;

    do {
      final response = await _dio.get<dynamic>(
        ApiUrl.poules,
        queryParameters: {
          'page': page,
          'limit': 20,
          ...?tournoiId == null ? null : {'tournoiId': tournoiId},
        },
      );
      final rows = _extractRows(response.data);
      poules.addAll(rows);
      totalPages = _extractTotalPages(response.data);
      if (rows.isEmpty) break;
      page++;
    } while (page <= totalPages);

    return poules;
  }

  Future<dynamic> create(PouleAccountDto poule) async =>
      (await _dio.post<dynamic>(ApiUrl.poules, data: poule.toJson())).data;

  Future<dynamic> update(UpdatePouleDto poule) async =>
      (await _dio.patch<dynamic>(ApiUrl.poules, data: poule.toJson())).data;

  List<Map<String, dynamic>> _extractRows(dynamic body) {
    if (body is List) {
      return body.whereType<Map>().map(Map<String, dynamic>.from).toList();
    }
    final root = asMap(body);
    if (root == null) return const [];

    for (final key in ['data', 'poules', 'items', 'results']) {
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

  int _extractTotalPages(dynamic body) {
    final root = asMap(body);
    if (root == null) return 1;
    final totalPages = root['totalPages'];
    if (totalPages is num && totalPages > 0) return totalPages.toInt();
    final nested = root['data'];
    return nested is Map ? _extractTotalPages(nested) : 1;
  }
}