import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myecl/admin/middlewares/admin_middleware.dart';
import 'package:myecl/admin/router.dart';
import 'package:myecl/admin/ui/pages/main_page/main_page.dart';
import 'package:myecl/amap/router.dart';
import 'package:myecl/amap/ui/pages/main_page/main_page.dart';
import 'package:myecl/booking/router.dart';
import 'package:myecl/booking/ui/pages/main_page/main_page.dart';
import 'package:myecl/cinema/router.dart';
import 'package:myecl/cinema/ui/pages/main_page/main_page.dart';
import 'package:myecl/event/router.dart';
import 'package:myecl/event/ui/pages/main_page/main_page.dart';
import 'package:myecl/home/router.dart';
import 'package:myecl/home/ui/home.dart';
import 'package:myecl/loan/router.dart';
import 'package:myecl/loan/ui/pages/main_page/main_page.dart';
import 'package:myecl/login/ui/auth.dart';
import 'package:myecl/others/ui/loading_page.dart';
import 'package:myecl/others/ui/no_internert_page.dart';
import 'package:myecl/settings/router.dart';
import 'package:myecl/settings/ui/pages/main_page/main_page.dart';
import 'package:myecl/tombola/router.dart';
import 'package:myecl/tombola/ui/pages/main_page/main_page.dart';
import 'package:myecl/tools/middlewares/authenticated_middleware.dart';
import 'package:myecl/vote/router.dart';
import 'package:myecl/vote/ui/pages/main_page/main_page.dart';
import 'package:qlevar_router/qlevar_router.dart';

final appRouterProvider = Provider<AppRouter>((ref) => AppRouter(ref));

class AppRouter {
  final ProviderRef ref;
  late List<QRoute> routes = [];
  static const String root = '/';
  static const String login = '/login';
  static const String loading = '/loading';
  static const String noInternet = '/no_internet';
  AppRouter(this.ref) {
    routes = [
      QRoute(
        path: root,
        builder: () => const HomePage(),
        middleware: [AuthenticatedMiddleware(ref)],
      ),
      QRoute(
          path: SettingsRouter.root,
          builder: () => const SettingsMainPage(),
          middleware: [AuthenticatedMiddleware(ref)],
          children: SettingsRouter().routes),
      QRoute(
        path: AdminRouter.root,
        builder: () => const AdminMainPage(),
        middleware: [AuthenticatedMiddleware(ref), AdminMiddleware(ref)],
        children: AdminRouter().routes,
      ),
      QRoute(
        path: BookingRouter.root,
        builder: () => const BookingMainPage(),
        middleware: [AuthenticatedMiddleware(ref)],
        children: BookingRouter(ref).routes,
      ),
      QRoute(
        path: EventRouter.root,
        builder: () => const EventMainPage(),
        middleware: [AuthenticatedMiddleware(ref)],
        children: EventRouter(ref).routes,
      ),
      QRoute(
        path: LoanRouter.root,
        builder: () => const LoanMainPage(),
        middleware: [AuthenticatedMiddleware(ref)],
        children: LoanRouter(ref).routes,
      ),
      QRoute(
        path: VoteRouter.root,
        builder: () => const VoteMainPage(),
        middleware: [AuthenticatedMiddleware(ref)],
        children: VoteRouter(ref).routes,
      ),
      QRoute(
        path: RaffleRouter.root,
        builder: () => const RaffleMainPage(),
        middleware: [AuthenticatedMiddleware(ref)],
        children: RaffleRouter(ref).routes,
      ),
      QRoute(
        path: CinemaRouter.root,
        builder: () => const CinemaMainPage(),
        middleware: [AuthenticatedMiddleware(ref)],
        children: CinemaRouter(ref).routes,
      ),
      QRoute(
        path: AmapRouter.root,
        builder: () => const AmapMainPage(),
        middleware: [AuthenticatedMiddleware(ref)],
        children: AmapRouter(ref).routes,
      ),
      QRoute(
        path: HomeRouter.root,
        builder: () => const HomePage(),
        middleware: [AuthenticatedMiddleware(ref)],
      ),
      QRoute(
        path: login,
        builder: () => const AuthScreen(),
      ),
      QRoute(
        path: loading,
        builder: () => const LoadingPage(),
      ),
      QRoute(
        path: noInternet,
        builder: () => const Scaffold(body: NoInternetPage()),
      ),
    ];
  }
}
