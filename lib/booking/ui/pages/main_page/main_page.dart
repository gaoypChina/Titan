import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/booking/providers/booking_list_provider.dart';
import 'package:myecl/booking/providers/booking_page_provider.dart';
import 'package:myecl/booking/providers/is_booking_admin_provider.dart';
import 'package:myecl/booking/tools/constants.dart';
import 'package:myecl/booking/ui/button.dart';
import 'package:myecl/booking/ui/refresh_indicator.dart';
import 'package:myecl/booking/ui/pages/main_page/calendar.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isBookingAdmin);
    final bookingsNotifier = ref.watch(bookingListProvider.notifier);
    return Expanded(
      child: BookingRefresher(
        onRefresh: () async {
          await bookingsNotifier.loadBookings();
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height -
                      290 -
                      (isAdmin ? 70 : 0),
                  child: const Calendar()),
              const SizedBox(
                height: 20,
              ),
              const Button(
                text: BookingTextConstants.addBookingPage,
                page: BookingPage.addBooking,
              ),
              const SizedBox(
                height: 20,
              ),
              const Button(
                text: BookingTextConstants.myBookings,
                page: BookingPage.bookings,
              ),
              const SizedBox(
                height: 20,
              ),
              isAdmin
                  ? Column(
                      children: const [
                        Button(
                          text: BookingTextConstants.adminPage,
                          page: BookingPage.admin,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                  : Container(),
            ]),
      ),
    );
  }
}
