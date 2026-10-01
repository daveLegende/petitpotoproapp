import 'package:dio/dio.dart';
import 'package:petitpotopro/core/network/api_dto.dart';
import 'package:petitpotopro/core/network/api_url.dart';

class CouponManagementRemoteDataSource {
  const CouponManagementRemoteDataSource(this._dio);

  final Dio _dio;

  Future<dynamic> createCoupon(CouponAccountDto coupon) async =>
      (await _dio.post<dynamic>(ApiUrl.coupons, data: coupon.toJson())).data;

  Future<dynamic> updateCoupon(UpdateCouponDto coupon) async =>
      (await _dio.patch<dynamic>(ApiUrl.coupons, data: coupon.toJson())).data;

  Future<dynamic> createCouponBet(CouponBetAccountDto bet) async =>
      (await _dio.post<dynamic>(ApiUrl.couponBets, data: bet.toJson())).data;

  Future<dynamic> updateCouponBet(UpdateCouponBetDto bet) async =>
      (await _dio.patch<dynamic>(ApiUrl.couponBets, data: bet.toJson())).data;

  Future<dynamic> createTournamentCoupon(
    TournoiCouponAccountDto coupon,
  ) async => (await _dio.post<dynamic>(
    ApiUrl.tournoiCoupons,
    data: coupon.toJson(),
  )).data;

  Future<dynamic> updateTournamentCoupon(UpdateTournoiCouponDto coupon) async =>
      (await _dio.patch<dynamic>(
        ApiUrl.tournoiCoupons,
        data: coupon.toJson(),
      )).data;

  Future<dynamic> createTournamentCouponBet(
    TournoiCouponBetAccountDto bet,
  ) async => (await _dio.post<dynamic>(
    ApiUrl.tournoiCouponBets,
    data: bet.toJson(),
  )).data;

  Future<dynamic> updateTournamentCouponBet(
    UpdateTournoiCouponBetDto bet,
  ) async => (await _dio.patch<dynamic>(
    ApiUrl.tournoiCouponBets,
    data: bet.toJson(),
  )).data;
}
