import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/auth/providers/openid_provider.dart';
import 'package:myecl/drawer/ui/app_drawer.dart';
import 'package:myecl/login/ui/auth.dart';
import 'package:myecl/others/ui/no_internert_page.dart';
import 'package:myecl/others/ui/update_page.dart';
import 'package:myecl/tools/constants.dart';
import 'package:myecl/version/providers/titan_version_provider.dart';
import 'package:myecl/version/providers/version_verifier_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionVerifier = ref.watch(versionVerifierProvider);
    final titanVersion = ref.watch(titanVersionProvider);

    final isLoggedIn = ref.watch(isLoggedInProvider);
    final check = versionVerifier.whenData((value) {
      return value.minimalTitanVersion <= titanVersion;
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyECL',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          textTheme: GoogleFonts.notoSerifMalayalamTextTheme(
              Theme.of(context).textTheme)),
      home: check.when(
          data: (value) => value
              ? isLoggedIn
                  ? const AppDrawer()
                  : const AuthScreen()
              : const UpdatePage(),
          loading: () => const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: ColorConstants.gradient1,
                  ),
                ),
              ),
          error: (error, stack) => const Scaffold(body: NoInternetPage())),
    );
  }
}
