import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/drawer/providers/is_web_format_provider.dart';
import 'package:myecl/drawer/providers/swipe_provider.dart';
import 'package:myecl/drawer/ui/custom_drawer.dart';

class AppTemplate extends HookConsumerWidget {
  static Duration duration = const Duration(milliseconds: 200);
  static const double maxSlide = 255;
  static const dragRigthStartVal = 60;
  static const dragLeftStartVal = maxSlide - 20;
  static bool shouldDrag = false;
  final Widget child;

  const AppTemplate({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationController =
        useAnimationController(duration: duration, initialValue: 1);
    final controller = ref.watch(swipeControllerProvider(animationController));
    final controllerNotifier =
        ref.watch(swipeControllerProvider(animationController).notifier);
    final isWebFormat = ref.watch(isWebFormatProvider);
    if (isWebFormat) {
      controllerNotifier.close();
    }
    return GestureDetector(
        onHorizontalDragStart: controllerNotifier.onDragStart,
        onHorizontalDragUpdate: controllerNotifier.onDragUpdate,
        onHorizontalDragEnd: (details) => controllerNotifier.onDragEnd(
            details, MediaQuery.of(context).size.width),
        onTap: () {},
        child: AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, _) {
              double animationVal = controller.value;
              double translateVal = animationVal * maxSlide;
              double scaleVal = 1 - (isWebFormat ? 0 : (animationVal * 0.3));
              double cornerval = isWebFormat ? 0 : 30.0 * animationVal;
              return Stack(
                children: [
                  CustomDrawer(controllerNotifier: controllerNotifier),
                  Transform(
                      alignment: Alignment.centerLeft,
                      transform: Matrix4.identity()
                        ..translate(translateVal)
                        ..scale(scaleVal),
                      child: GestureDetector(
                        onTap: () {
                          if (controller.isCompleted) {
                            controllerNotifier.close();
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(cornerval),
                          child: Stack(
                            children: [
                              child,
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                onEnter: (event) {
                                  if (controller.isCompleted) {
                                    controllerNotifier.close();
                                  } else {
                                    controllerNotifier.open();
                                  }
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  width: 20,
                                  height: double.infinity,
                                ),
                              )
                            ],
                          ),
                        ),
                      ))
                ],
              );
            }));
  }
}
