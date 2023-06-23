import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/cinema/providers/scroll_provider.dart';
import 'package:myecl/cinema/providers/main_page_index_provider.dart';
import 'package:myecl/cinema/router.dart';
import 'package:myecl/drawer/providers/swipe_provider.dart';
import 'package:myecl/cinema/tools/constants.dart';
import 'package:qlevar_router/qlevar_router.dart';

class TopBar extends HookConsumerWidget {
  final SwipeControllerNotifier controllerNotifier;
  const TopBar({Key? key, required this.controllerNotifier}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialPageNotifier = ref.watch(mainPageIndexProvider.notifier);
    final scrollNotifier = ref.watch(scrollProvider.notifier);
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 70,
              child: Builder(
                builder: (BuildContext appBarContext) {
                  return IconButton(
                      onPressed: () {
                        if (QR.currentPath == CinemaRouter.root) {
                          controllerNotifier.toggle();
                          initialPageNotifier.reset();
                          scrollNotifier.reset();
                        } else {
                          QR.back();
                        }
                      },
                      icon: HeroIcon(
                        QR.currentPath == CinemaRouter.root
                            ? HeroIcons.bars3BottomLeft
                            : HeroIcons.chevronLeft,
                        color: Colors.black,
                        size: 30,
                      ));
                },
              ),
            ),
            const Text(CinemaTextConstants.cinema,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(
              width: 70,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
