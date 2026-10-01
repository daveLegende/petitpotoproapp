import 'package:dio/dio.dart';
import 'package:petitpotopro/core/network/api_url.dart';
import 'package:petitpotopro/core/utils/json_utils.dart';
import 'package:petitpotopro/core/network/api_dto.dart';
import 'package:petitpotopro/features/tickets/data/models/user_ticket_model.dart';

abstract class UserTicketRemoteDataSource {
  Future<List<UserTicketModel>> getMine();
  Future<void> purchase(TicketAccountDto ticket);
}

class UserTicketRemoteDataSourceImpl implements UserTicketRemoteDataSource {
  const UserTicketRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<UserTicketModel>> getMine() async {
    final tickets = <UserTicketModel>[];
    var page = 1;
    var totalPages = 1;

    do {
      final response = await _dio.get<dynamic>(
        ApiUrl.tickets,
        queryParameters: {'page': page, 'limit': 20},
      );
      final rows = _extractRows(response.data);
      tickets.addAll(
        rows.whereType<Map>().map(
          (row) => UserTicketModel.fromJson(Map<String, dynamic>.from(row)),
        ),
      );
      totalPages = _extractTotalPages(response.data);
      if (rows.isEmpty) break;
      page++;
    } while (page <= totalPages);

    return tickets;
  }

  @override
  Future<void> purchase(TicketAccountDto ticket) async {
    await _dio.post<dynamic>(ApiUrl.tickets, data: ticket.toJson());
  }

  List<dynamic> _extractRows(dynamic body) {
    if (body is List) return body;
    final root = asMap(body);
    if (root == null) return const [];

    for (final key in ['data', 'tickets', 'items', 'results']) {
      final value = root[key];
      if (value is List) return value;
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
