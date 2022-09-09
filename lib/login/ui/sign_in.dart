import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/login/tools/constants.dart';
import 'package:myecl/login/tools/functions.dart';
import 'package:myecl/login/ui/sign_in_up_bar.dart';
import 'package:myecl/login/ui/text_from_decoration.dart';
import 'package:myecl/auth/providers/oauth2_provider.dart';
import 'package:myecl/tools/functions.dart';

class SignIn extends HookConsumerWidget {
  const SignIn({Key? key, required this.onRegisterPressed}) : super(key: key);

  final VoidCallback onRegisterPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authTokenProvider.notifier);
    final username = useTextEditingController(text: "test2@ecl21.ec-lyon.fr");
    final password = useTextEditingController(text: "testPass");
    final hidePass = useState(true);
    return AutofillGroup(
        child: Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  LoginTextConstants.welcomeBack,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 5,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: TextFormField(
                        decoration: signInRegisterInputDecoration(
                          isSignIn: true,
                            hintText: LoginTextConstants.email),
                        controller: username,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: TextFormField(
                          decoration: signInRegisterInputDecoration(
                              isSignIn: true,
                              hintText: LoginTextConstants.password, notifier: hidePass),
                          controller: password,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: hidePass.value,
                        )),
                    SignInBar(
                      isLoading: ref.watch(loadingrovider),
                      label: LoginTextConstants.signIn,
                      onPressed: () async {
                        await authNotifier.getTokenFromRequest(
                            username.text, password.text);
                        ref.watch(authTokenProvider).when(
                            data: (token) {},
                            error: (e, s) {
                              displayLoginToast(
                                  context, TypeMsg.error, e.toString());
                            },
                            loading: () {});
                      },
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              splashColor:
                                  const Color.fromRGBO(255, 255, 255, 1),
                              onTap: () {
                                onRegisterPressed();
                              },
                              child: const Text(
                                LoginTextConstants.createAccount,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  decoration: TextDecoration.underline,
                                  fontSize: 14,
                                ),
                              ),
                            )),
                        Container(
                            height: 40,
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              splashColor:
                                  const Color.fromRGBO(255, 255, 255, 1),
                              onTap: () {
                                onRegisterPressed();
                              },
                              child: const Text(
                                LoginTextConstants.forgotPassword,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  decoration: TextDecoration.underline,
                                  fontSize: 14,
                                ),
                              ),
                            )),
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    ));
  }
}