import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/booking/class/booking.dart';
import 'package:myecl/booking/tools/constants.dart';
import 'package:myecl/event/class/event.dart';
import 'package:myecl/event/providers/confirmed_event_list_provider.dart';
import 'package:myecl/event/providers/event_list_provider.dart';
import 'package:myecl/event/providers/event_page_provider.dart';
import 'package:myecl/event/providers/event_provider.dart';
import 'package:myecl/event/ui/event_ui.dart';
import 'package:myecl/tools/token_expire_wrapper.dart';
import 'package:myecl/tools/ui/dialog.dart';

class ListEvent extends HookConsumerWidget {
  final List<Event> events;
  final bool canToggle = true;
  final String title;
  const ListEvent({
    Key? key,
    required this.events,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageNotifier = ref.watch(eventPageProvider.notifier);
    final eventNotifier = ref.watch(eventProvider.notifier);
    final eventListNotifier = ref.watch(eventListProvider.notifier);
    final confirmedEventListNotifier =
        ref.watch(confirmedEventListProvider.notifier);
    final toggle = useState(false);
    if (events.isNotEmpty) {
      return Column(
        children: [
          if (canToggle)
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  toggle.value = !toggle.value;
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(title,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 149, 149, 149))),
                      ),
                      HeroIcon(
                        toggle.value
                            ? HeroIcons.chevronUp
                            : HeroIcons.chevronDown,
                        color: const Color.fromARGB(255, 149, 149, 149),
                        size: 30,
                      ),
                    ],
                  ),
                )),
          if (toggle.value)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  ...events.map((e) => EventUi(
                        event: e,
                        isDetailPage: true,
                        isAdmin: e.start.isAfter(DateTime.now()),
                        onEdit: () {
                          eventNotifier.setEvent(e);
                          pageNotifier
                              .setEventPage(EventPage.addEditEventFromAdmin);
                        },
                        onInfo: () {
                          eventNotifier.setEvent(e);
                          pageNotifier.setEventPage(
                              EventPage.eventDetailfromModuleFromAdmin);
                        },
                        onConfirm: () async {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return CustomDialogBox(
                                    title: BookingTextConstants.confirm,
                                    descriptions:
                                        BookingTextConstants.confirmBooking,
                                    onYes: () async {
                                      await tokenExpireWrapper(ref, () async {
                                        eventListNotifier
                                            .toggleConfirmed(
                                                e, Decision.approved)
                                            .then((value) {
                                          if (value) {
                                            confirmedEventListNotifier
                                                .addEvent(e);
                                          }
                                        });
                                      });
                                    });
                              });
                        },
                        onDecline: () async {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return CustomDialogBox(
                                    title: BookingTextConstants.decline,
                                    descriptions:
                                        BookingTextConstants.declineBooking,
                                    onYes: () async {
                                      await tokenExpireWrapper(ref, () async {
                                        eventListNotifier
                                            .toggleConfirmed(
                                                e, Decision.declined)
                                            .then((value) {
                                          if (value) {
                                            confirmedEventListNotifier
                                                .deleteEvent(e);
                                          }
                                        });
                                      });
                                    });
                              });
                        },
                        onCopy: () {
                          eventNotifier.setEvent(e.copyWith(id: ""));
                          pageNotifier
                              .setEventPage(EventPage.addEditEventFromAdmin);
                        },
                      )),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          const SizedBox(height: 30),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}