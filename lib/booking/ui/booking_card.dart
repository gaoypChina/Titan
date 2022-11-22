import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/booking/class/booking.dart';
import 'package:myecl/booking/tools/constants.dart';
import 'package:myecl/booking/tools/functions.dart';

class BookingCard extends HookConsumerWidget {
  final Booking booking;
  final Function() onEdit, onReturn, onInfo;
  final bool isAdmin, isDetail;
  const BookingCard(
      {super.key,
      required this.booking,
      required this.onEdit,
      required this.onReturn,
      required this.onInfo,
      required this.isAdmin,
      required this.isDetail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        // height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(3, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(booking.room.name,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  if (!isDetail)
                    GestureDetector(
                      onTap: onInfo,
                      child: const HeroIcon(HeroIcons.informationCircle,
                          color: Colors.black, size: 25),
                    )
                ],
              ),
              const SizedBox(height: 5),
              Text(formatDates(booking.start, booking.end, false),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade400)),
              const SizedBox(height: 3),
              Text(booking.reason,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      booking.decision == Decision.pending
                          ? BookingTextConstants.pending
                          : booking.decision == Decision.approved
                              ? BookingTextConstants.confirmed
                              : BookingTextConstants.declined,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade400)),
                  Text(
                      '${BookingTextConstants.keys}: ${booking.key ? BookingTextConstants.yes : BookingTextConstants.no}',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade400)),
                ],
              ),
              // const Spacer(),
              const SizedBox(height: 20),
              if (!isDetail)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: isAdmin
                                  ? booking.decision == Decision.approved
                                      ? Colors.black
                                      : Colors.transparent
                                  : Colors.transparent,
                              width: 2),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(2, 3))
                          ],
                        ),
                        child: Icon(isAdmin ? Icons.check : Icons.edit,
                            color: Colors.black),
                      ),
                    ),
                    if (isAdmin) const Spacer(),
                    if (isAdmin)
                      GestureDetector(
                        onTap: onReturn,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: isAdmin
                                    ? booking.decision == Decision.declined
                                        ? Colors.white
                                        : Colors.transparent
                                    : Colors.transparent,
                                width: 2),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(2, 3))
                            ],
                          ),
                          child: const Icon(Icons.clear, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              if (!isDetail) const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
