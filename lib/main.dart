import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/auth/providers/oauth2_provider.dart';
import 'package:myecl/drawer/ui/app_drawer.dart';
import 'package:myecl/login/ui/auth.dart';
import 'package:myecl/others/ui/no_internert_page.dart';
import 'package:myecl/others/ui/update_page.dart';
import 'package:myecl/version/providers/titan_version_provider.dart';
import 'package:myecl/version/providers/version_verifier_provider.dart';
// import 'package:uni_links/uni_links.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final recievedUri = useState<String?>(null);
    // final token = useState<String?>(null);

    // useState<Stream<Uri?>>(uriLinkStream).value.listen((Uri? uri) {
    //   recievedUri.value = uri.toString();
    //   token.value = uri?.queryParameters['token'];
    // }, onError: (Object err) {
    //   recievedUri.value = 'Failed to get initial uri: $err.';
    // });
    final versionVerifier = ref.watch(versionVerifierProvider);
    final titanVersion = ref.watch(titanVersionProvider);
    final check = versionVerifier.whenData(
        (value) => value.minimalTitanVersion.compareTo(titanVersion) <= 0);
    final isLoggedIn = ref.watch(isLoggedInProvider);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyECL',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.notoSerifMalayalamTextTheme(
                Theme.of(context).textTheme)),
        home: AppDrawer());
        // home: SafeArea(
        //   child: check.when(
        //       data: (value) => value
        //           ? isLoggedIn
        //               ? const AppDrawer()
        //               : const AuthScreen()
        //           : const UpdatePage(),
        //       loading: () => const Scaffold(
        //             body: Center(
        //               child: CircularProgressIndicator(),
        //             ),
        //           ),
        //       error: (error, stack) => const Scaffold(body: NoInternetPage())),
        // ));
  }
}
