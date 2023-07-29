import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/cinema/class/session.dart';
import 'package:myecl/cinema/providers/session_poster_map_provider.dart';
import 'package:myecl/cinema/providers/session_poster_provider.dart';
import 'package:myecl/tools/ui/builders/auto_loader_child.dart';
import 'package:myecl/tools/ui/layouts/card_button.dart';
import 'package:myecl/tools/ui/builders/shrink_button.dart';

class AdminSessionCard extends HookConsumerWidget {
  final Session session;
  final VoidCallback onTap, onEdit;
  final Future Function() onDelete;
  const AdminSessionCard(
      {super.key,
      required this.session,
      required this.onTap,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionPosterMap = ref.watch(sessionPosterMapProvider);
    final sessionPosterMapNotifier =
        ref.read(sessionPosterMapProvider.notifier);
    final sessionPosterNotifier = ref.read(sessionPosterProvider.notifier);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 155,
        height: 300,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            children: [
              Container(
                  decoration: const BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 7,
                      offset: Offset(0, 5),
                    ),
                  ]),
                  child: AutoLoaderChild(
                    value: sessionPosterMap,
                    notifier: sessionPosterMapNotifier,
                    mapKey: session,
                    loader: (session) =>
                        sessionPosterNotifier.getLogo(session.id),
                    dataBuilder: (context, data) => Image(
                      image: data.image,
                      fit: BoxFit.cover,
                    ),
                    errorBuilder: (error, stack) => const Center(
                      child: HeroIcon(HeroIcons.exclamationCircle),
                    ),
                  )),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                height: 90,
                child: Column(
                  children: [
                    AutoSizeText(
                      session.name,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: onEdit,
                          child: CardButton(
                            color: Colors.grey.shade200,
                            shadowColor: Colors.grey.withOpacity(0.2),
                            child: const HeroIcon(HeroIcons.pencil,
                                color: Colors.black),
                          ),
                        ),
                        ShrinkButton(
                          onTap: onDelete,
                          builder: (child) =>
                              CardButton(color: Colors.black, child: child),
                          child: const HeroIcon(HeroIcons.trash,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
