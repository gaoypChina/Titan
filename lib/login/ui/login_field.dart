import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/login/tools/constants.dart';

class CreateAccountField extends HookConsumerWidget {
  final TextEditingController controller;
  final String label;
  final int index;
  final PageController pageController;
  final ValueNotifier<int> currentPage;
  final TextInputType keyboardType;
  const CreateAccountField(
      {super.key,
      required this.controller,
      required this.label,
      required this.index,
      required this.pageController,
      required this.currentPage,
      this.keyboardType = TextInputType.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPassword = keyboardType == TextInputType.visiblePassword;
    final hidePassword = useState(isPassword);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 9,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: LoginColorConstants.background,
              )),
        ),
        const SizedBox(
          height: 14,
        ),
        TextFormField(
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          autofocus: true,
          keyboardType: keyboardType,
          onFieldSubmitted: (_) {
            pageController.animateToPage(index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.decelerate);
            currentPage.value = index;
          },
          obscureText: hidePassword.value,
          controller: controller,
          cursorColor: Colors.white,
          decoration: (keyboardType == TextInputType.visiblePassword)
              ? InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      hidePassword.value = !hidePassword.value;
                    },
                  ),
                  enabledBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: LoginColorConstants.background)),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.white,
                  )),
                  errorBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.white,
                  )),
                  errorStyle: const TextStyle(color: Colors.white))
              : const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: LoginColorConstants.background)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.white,
                  )),
                  errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.white,
                  )),
                  errorStyle: TextStyle(color: Colors.white)),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return LoginTextConstants.emptyFieldError;
            }
            return null;
          },
        ),
      ],
    );
  }
}
