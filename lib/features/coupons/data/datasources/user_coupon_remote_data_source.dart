import 'package:dio/dio.dart';
import 'package:petitpotopro/core/network/api_url.dart';
import 'package:petitpotopro/core/utils/json_utils.dart';
import 'package:petitpotopro/features/coupons/data/models/user_coupon_model.dart';
import 'package:petitpotopro/features/coupons/domain/entities/user_coupon.dart';

abstract class UserCouponRemoteDataSource {
  Future<List<UserCouponModel>> getMine();
}

class UserCouponRemoteDataSourceImpl implements UserCouponRemoteDataSource {
  const UserCouponRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<UserCouponModel>> getMine() async {
    final responses = await Future.wait([
      _getAll(ApiUrl.coupons, UserCouponKind.match),
      _getAll(ApiUrl.tournoiCoupons, UserCouponKind.tournament),
    ]);
    return [...responses[0], ...responses[1]];
  }

  Future<List<UserCouponModel>> _getAll(
    String path,
    UserCouponKind kind,
  ) async {
    final coupons = <UserCouponModel>[];
    var page = 1;
    var totalPages = 1;

    do {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: {'page': page, 'limit': 20},
      );
      final rows = _extractRows(response.data);
      coupons.addAll(
        rows.map((row) => UserCouponModel.fromJson(row, kind: kind)),
      );
      totalPages = _extractTotalPages(response.data);
      if (rows.isEmpty) break;
      page++;
    } while (page <= totalPages);

    return coupons;
  }

  List<Map<String, dynamic>> _extractRows(dynamic body) {
    if (body is List) {
      return body.whereType<Map>().map(Map<String, dynamic>.from).toList();
    }
    final root = asMap(body);
    if (root == null) return const [];

    for (final key in ['data', 'coupons', 'items', 'results']) {
      final value = root[key];
      if (value is List) {
        return value.whereType<Map>().map(Map<String, dynamic>.from).toList();
      }
      final nested = asMap(value);
      if (nested != null) {
        final rows = _extractRows(nested);
        if (rows.isNotEmpty) return rows;
      }
    }
    return const [];
  }

  int _extractTotalPages(dynamic body) {
    final root = asMap(body);
    if (root == null) return 1;
    final value = root['totalPages'];
    if (value is num && value > 0) return value.toInt();
    final nested = root['data'];
    return nested is Map ? _extractTotalPages(nested) : 1;
  }
}
