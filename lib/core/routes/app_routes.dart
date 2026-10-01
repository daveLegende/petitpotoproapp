import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:petitpotopro/app.dart';
import 'package:petitpotopro/common/widgets/navigation/navigation_widget.dart';
import 'package:petitpotopro/core/di/service_locator.dart';
import 'package:petitpotopro/core/routes/auth_router_refresh.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:petitpotopro/features/auth/presentation/pages/login_page.dart';
import 'package:petitpotopro/features/auth/presentation/pages/register_page.dart';
import 'package:petitpotopro/features/home/home.dart';
import 'package:petitpotopro/features/onboard/page/onboard.dart';
import 'package:petitpotopro/features/splash/splash.dart';
import 'package:petitpotopro/features/tournoi/domain/entities/tournoi_entity.dart';
import 'package:petitpotopro/features/tournoi/presentation/pages/tournoi_screen.dart';
import 'package:petitpotopro/features/tournoi/presentation/pages/tournament_transition_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Routes accessibles sans être connecté, dont la consultation des tournois.
  static const _publicPaths = {
    SplashScreen.route,
    OnboardingScreen.route,
    LoginPage.route,
    RegisterPage.route,
    HomeScreen.route,
    NavigationWidget.route,
    TournamentTransitionScreen.route,
    TournoiScreen.route,
  };

  static final _auth = sl<AuthBloc>();

  static final router = GoRouter(
    initialLocation: SplashScreen.route,
    navigatorKey: PetitpotoApp.navigatorKey,
    refreshListenable: AuthRouterRefresh(
      _auth.stream.map((state) => state.status).distinct(),
    ),
    redirect: (context, state) {
      final location = state.matchedLocation;

      // Le splash décide seul de sa sortie (durée minimale + restauration de session).
      if (location == SplashScreen.route) return null;

      final isAuthenticated = _auth.state.isAuthenticated;

      if (!isAuthenticated && !_publicPaths.contains(location)) {
        return Uri(
          path: LoginPage.route,
          queryParameters: {'redirect': state.uri.toString()},
        ).toString();
      }
      if (isAuthenticated &&
          (location == LoginPage.route ||
              location == RegisterPage.route ||
              location == OnboardingScreen.route)) {
        final destination = state.uri.queryParameters['redirect'];
        if (destination != null &&
            destination.startsWith('/') &&
            !destination.startsWith('//')) {
          return destination;
        }
        return HomeScreen.route;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: SplashScreen.route,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: OnboardingScreen.route,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: LoginPage.route,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RegisterPage.route,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: HomeScreen.route,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: NavigationWidget.route,
        builder: (context, state) {
          final extraTournamentId = state.extra;
          final tournoiId = extraTournamentId is String
              ? extraTournamentId
              : state.uri.queryParameters['tournoiId'];
          if (tournoiId == null || tournoiId.isEmpty) {
            return const TournoiScreen();
          }
          final initialTab = int.tryParse(
            state.uri.queryParameters['tab'] ?? '',
          );
          return NavigationWidget(
            tournoiId: tournoiId,
            initialTab: initialTab ?? 0,
          );
        },
      ),
      GoRoute(
        path: TournamentTransitionScreen.route,
        builder: (context, state) {
          final tournament = state.extra;
          if (tournament is! TournoiEntity) {
            return const TournoiScreen();
          }
          return TournamentTransitionScreen(tournament: tournament);
        },
      ),
      GoRoute(
        path: TournoiScreen.route,
        builder: (context, state) => const TournoiScreen(),
      ),
    ],
  );
}
