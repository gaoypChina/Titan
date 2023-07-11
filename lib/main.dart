import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:myecl/drawer/providers/animation_provider.dart';
import 'package:myecl/drawer/providers/swipe_provider.dart';
import 'package:myecl/drawer/providers/top_bar_callback_provider.dart';
import 'package:myecl/login/providers/animation_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/router.dart';
import 'package:myecl/tools/ui/app_template.dart';
import 'package:myecl/tools/service/push_notification_service.dart';
import 'package:qlevar_router/qlevar_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  QR.setUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage((_) async {});
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PushNotificationService.initialize();
    PushNotificationService.getToken().then(
      (value) {
        print(value);
      }
    );

    final appRouter = ref.watch(appRouterProvider);
    final animationController =
        useAnimationController(duration: const Duration(seconds: 2));
    final animationNotifier = ref.read(backgroundAnimationProvider.notifier);

    Future(() {
      animationNotifier.setController(animationController);
    });

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WillPopScope(
            onWillPop: () async {
              final topBarCallBack = ref.watch(topBarCallBackProvider);
              if (QR.currentPath.split('/').length <= 2) {
                final animation = ref.watch(animationProvider);
                if (animation != null) {
                  final controllerNotifier =
                      ref.watch(swipeControllerProvider(animation).notifier);
                  controllerNotifier.toggle();
                  topBarCallBack.onMenu?.call();
                }
                return false;
              }
              topBarCallBack.onBack?.call();
              return true;
            },
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'MyECL',
              scrollBehavior: MyCustomScrollBehavior(),
              supportedLocales: const [Locale('en', 'US'), Locale('fr', 'FR')],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              theme: ThemeData(
                  primarySwatch: Colors.orange,
                  textTheme:
                      GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
                  brightness: Brightness.light),
              routeInformationParser: const QRouteInformationParser(),
              builder: (context, child) {
                if (child == null) {
                  return const SizedBox();
                }
                return AppTemplate(
                  child: child,
                );
              },
              routerDelegate:
                  QRouterDelegate(appRouter.routes, initPath: AppRouter.root),
            )));
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus
      };
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
}