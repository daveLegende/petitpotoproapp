import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:toastification/toastification.dart';
import 'package:petitpotopro/core/configs/theme/app_theme.dart';
import 'package:petitpotopro/core/di/service_locator.dart';
import 'package:petitpotopro/core/routes/app_routes.dart';
import 'package:petitpotopro/features/auth/presentation/bloc/auth_bloc.dart';

class PetitpotoApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const PetitpotoApp({super.key});

  static const _designSize = Size(375, 812);
  @override
  Widget build(BuildContext context) {
    // .value : l'AuthBloc est un singleton GetIt, il ne doit pas être fermé par le provider.
    return BlocProvider<AuthBloc>.value(
      value: sl<AuthBloc>(),
      child: ScreenUtilPlusInit(
        designSize: _designSize,
        minTextAdapt: true,
        builder: (_, child) {
          return ToastificationWrapper(
            child: MaterialApp.router(
              // key: ValueKey(context.locale.toString()),
              title: 'Ratoufa',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,

              // localizationsDelegates: context.localizationDelegates,
              // supportedLocales: context.supportedLocales,
              // locale: context.locale,

              routeInformationParser:
                  AppRouter.router.routeInformationParser,
              routerDelegate: AppRouter.router.routerDelegate,
              routeInformationProvider:
                  AppRouter.router.routeInformationProvider,
            ),
          );
        },
      ),
    );
  }
}
