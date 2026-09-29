import 'package:petitpotopro/core/config/env.dart';

class ApiUrl {
  static const String baseURL = Env.apiBaseUrl;
  static const String files = '/files';

  static const String login = '/account/auth/login';
  static const String refreshToken = '/account/auth/refresh_token';
  static const String sendOtp = '/account/auth/sendOtp';
  static const String verifyOtp = '/account/auth/verifyOtp';
  static const String register = '/account/auth/register';

  static const String users = '/users';
  // static const String register = '$users/register';
  static const String myProfile = '$users/profile';
  static const String currentUser = '$users/current';
  static const String searchUsers = '$users/search';
  static const String updateUser = '$users/update';
  static const String userTickets = '$users/tickets';
  static const String userCoupons = '$users/coupons';
  static const String userParis = '$users/paris';
  static const String userTournoiCoupons = '$users/tournoi-coupon';
  static const String deleteUserBet = '$users/bet/delete';
  static const String deleteUserTicket = '$users/ticket/delete';

  static const String admins = '/admins';
  static const String adminLogin = '$admins/login';
  static const String adminRefreshToken = '$admins/refresh_token';
  static const String adminRegister = '$admins/register';
  static const String adminSearch = '$admins/search';
  static const String adminReport = '$admins/report';
  static const String adminChangePassword = '$admins/change-password';
  static const String adminCoupons = '$admins/coupons';
  static const String adminTournoiCoupons = '$admins/tournoi-coupons';

  static const String transactions = '/transactions';
  static const String userTransactions = '$transactions/user-transaction';

  static const String coupons = '/coupons';
  static const String pendingCoupons = '$coupons/pending-coupons';
  static const String couponStatus = '$coupons/status';

  static const String matchs = '/matchs';
  static const String matchEvents = '$matchs/events';
  static const String matchPenaltyScores = '$matchs/penalty-scores';
  static const String matchTirAuxButs = '$matchs/tir-aux-buts';

  static const String paris = '/paris';
  static const String couponBets = '/coupon-bets';
  static const String tournoiCoupons = '/tournoi-coupons';
  static const String checkTournoiCoupons =
      '$tournoiCoupons/check-tournoi-coupons';
  static const String tournoiCouponBets = '/tournoi-coupon-bets';

  static const String players = '/players';
  static const String teams = '/teams';
  static const String poules = '/poules';
  static const String arbitres = '/arbitres';
  static const String infos = '/infos';
  static const String pronos = '/pronos';
  static const String tickets = '/tickets';
  static const String scanTicket = '$tickets/scan';
  static const String bets = '/bets';

  static const String otp = '/otp';
  static const String forgotPassword = '/forgotpass';
  static const String verifyForgotPassword = '$forgotPassword/verify-code';
  static const String tournois = '/tournois';
  static const String mvps = '/mvp';
}

typedef APIURL = ApiUrl;