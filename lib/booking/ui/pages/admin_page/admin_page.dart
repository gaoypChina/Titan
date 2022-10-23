import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/booking/class/booking.dart';
import 'package:myecl/booking/class/room.dart';
import 'package:myecl/booking/providers/booking_list_provider.dart';
import 'package:myecl/booking/providers/booking_page_provider.dart';
import 'package:myecl/booking/providers/room_list_provider.dart';
import 'package:myecl/booking/providers/room_provider.dart';
import 'package:myecl/booking/tools/constants.dart';
import 'package:myecl/booking/ui/pages/admin_page/room_chip.dart';
import 'package:myecl/booking/ui/pages/main_page/booking_card.dart';
import 'package:myecl/booking/ui/refresh_indicator.dart';
import 'package:myecl/tools/functions.dart';

class AdminPage extends HookConsumerWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageNotifier = ref.watch(bookingPageProvider.notifier);
    final roomList = ref.watch(roomListProvider);
    final room = ref.watch(roomProvider);
    final roomNotifier = ref.watch(roomProvider.notifier);
    final bookings = ref.watch(bookingListProvider);
    final List<Booking> pendingBookings = [],
        confirmedBookings = [],
        canceledBookings = [];
    bookings.when(
        data: (
          bookings,
        ) {
          for (Booking b in bookings) {
            switch (b.decision) {
              case Decision.approved:
                confirmedBookings.add(b);
                break;
              case Decision.declined:
                canceledBookings.add(b);
                break;
              case Decision.pending:
                pendingBookings.add(b);
                break;
            }
          }
        },
        error: (e, s) {},
        loading: () {});
    return BookingRefresher(
      onRefresh: () async {
        await ref.watch(bookingListProvider.notifier).loadBookings();
      },
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(BookingTextConstants.adminPage,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(BookingTextConstants.room,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 205, 205, 205))),
            ),
          ),
          const SizedBox(height: 10),
          roomList.when(
            data: (List<Room> data) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      pageNotifier.setBookingPage(BookingPage.addRoom);
                    },
                    child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Chip(
                          label: const HeroIcon(
                            HeroIcons.plus,
                            color: Colors.black,
                          ),
                          backgroundColor: Colors.grey.shade200,
                        )),
                  ),
                  ...data.map(
                    (e) => RoomChip(
                      label: capitalize(e.name),
                      selected: room.id == e.id,
                      onTap: () {
                        roomNotifier.setRoom(e);
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                ],
              ),
            ),
            error: (Object error, StackTrace? stackTrace) {
              return Center(child: Text('Error $error'));
            },
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
          ),
          const SizedBox(height: 30),
          if (pendingBookings.isEmpty &&
              confirmedBookings.isEmpty &&
              canceledBookings.isEmpty)
            const Center(
              child: Text(BookingTextConstants.noCurrentBooking,
                  style: TextStyle(
                      color: BookingColorConstants.darkBlue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
          if (pendingBookings.isNotEmpty)
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(BookingTextConstants.pending,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 205, 205, 205))),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      ...pendingBookings.map((e) => BookingCard(
                            booking: e,
                            onEdit: () {},
                            onReturn: () {},
                          )),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          if (confirmedBookings.isNotEmpty)
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(BookingTextConstants.confirmed,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 205, 205, 205))),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      ...confirmedBookings.map((e) => BookingCard(
                            booking: e,
                            onEdit: () {},
                            onReturn: () {},
                          )),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          if (canceledBookings.isNotEmpty)
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(BookingTextConstants.declined,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 205, 205, 205))),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      ...canceledBookings.map((e) => BookingCard(
                            booking: e,
                            onEdit: () {},
                            onReturn: () {},
                          )),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            )
        ],
      ),
    );
  }
}
