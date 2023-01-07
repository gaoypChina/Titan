import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/amap/class/cash.dart';
import 'package:myecl/amap/providers/cash_provider.dart';
import 'package:myecl/amap/tools/constants.dart';
import 'package:myecl/tools/functions.dart';
import 'package:myecl/tools/token_expire_wrapper.dart';

class UserCashUi extends HookConsumerWidget {
  final Cash cash;
  const UserCashUi({super.key, required this.cash});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flipped = useState(true);
    final amount = useTextEditingController();
    final key = GlobalKey<FormState>();
    bool isFront = true;
    double anglePlus = 0;
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );
    void displayVoteWithContext(TypeMsg type, String msg) {
      displayToast(context, type, msg);
    }

    isFrontImage(double abs) {
      const degrees90 = pi / 2;
      const degrees270 = 3 * pi / 2;

      return abs <= degrees90 || abs >= degrees270;
    }

    toggle() {
      flipped.value = !flipped.value;
      if (flipped.value) {
        controller.reverse();
        isFront = true;
        anglePlus = 0;
      } else {
        controller.forward();
        isFront = false;
        anglePlus = pi;
      }
    }

    return GestureDetector(
      onTap: toggle,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          double angle = controller.value * -pi;
          if (isFront) angle += anglePlus;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(angle);
          return Transform(
            alignment: Alignment.center,
            transform: transform,
            child: isFrontImage(angle.abs())
                ? Container(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                        width: 150,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: const RadialGradient(
                            colors: [
                              AMAPColorConstants.green1,
                              AMAPColorConstants.textLight,
                            ],
                            center: Alignment.topLeft,
                            radius: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AMAPColorConstants.textDark.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: const Offset(3, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 17.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                AutoSizeText(
                                    cash.user.nickname.isEmpty
                                        ? cash.user.firstname
                                        : cash.user.nickname,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(
                                            223, 244, 255, 183))),
                                const SizedBox(height: 2),
                                AutoSizeText(
                                    cash.user.nickname.isNotEmpty
                                        ? '${cash.user.firstname} ${cash.user.name}'
                                        : cash.user.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AMAPColorConstants.textDark)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AutoSizeText(
                                        '${cash.balance.toStringAsFixed(2)} €',
                                        maxLines: 1,
                                        minFontSize: 10,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                223, 244, 255, 183))),
                                    const HeroIcon(
                                      HeroIcons.plus,
                                      color: Color.fromARGB(223, 244, 255, 183),
                                      size: 20,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            ))))
                : Transform(
                    transform: Matrix4.identity()..rotateX(pi),
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        width: 140,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: const RadialGradient(
                            colors: [
                              AMAPColorConstants.green1,
                              AMAPColorConstants.textLight,
                            ],
                            center: Alignment.topLeft,
                            radius: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AMAPColorConstants.textDark.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset: const Offset(3, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 17.0),
                          child: Form(
                            key: key,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: TextFormField(
                                    controller: amount,
                                    keyboardType: TextInputType.number,
                                    validator: (value) => value!.isEmpty
                                        ? AMAPTextConstants.add
                                        : null,
                                    cursorColor: AMAPColorConstants.textDark,
                                    decoration: const InputDecoration(
                                      suffixText: '€',
                                      suffixStyle: TextStyle(
                                        color: AMAPColorConstants.textDark,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      contentPadding: EdgeInsets.all(0),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AMAPColorConstants.textDark,
                                          width: 2,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              223, 244, 255, 183),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  child: const Icon(
                                    Icons.add,
                                    color: Color.fromARGB(223, 244, 255, 183),
                                    size: 30,
                                  ),
                                  onTap: () {
                                    if (key.currentState!.validate()) {
                                      tokenExpireWrapper(ref, () async {
                                        await ref
                                            .read(cashProvider.notifier)
                                            .updateCash(
                                              Cash(
                                                user: cash.user,
                                                balance: cash.balance +
                                                    int.parse(amount.text),
                                              ),
                                            )
                                            .then((value) {
                                          if (value) {
                                            key.currentState!.reset();
                                            toggle();
                                            displayVoteWithContext(
                                                TypeMsg.msg,
                                                AMAPTextConstants
                                                    .updatedAmount);
                                          } else {
                                            displayVoteWithContext(
                                                TypeMsg.error,
                                                AMAPTextConstants
                                                    .updatingError);
                                          }
                                        });
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}