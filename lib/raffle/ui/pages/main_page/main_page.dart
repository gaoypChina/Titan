import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/raffle/class/raffle.dart';
import 'package:myecl/raffle/class/raffle_status_type.dart';
import 'package:myecl/raffle/class/tickets.dart';
import 'package:myecl/raffle/providers/is_raffle_admin.dart';
import 'package:myecl/raffle/providers/raffle_list_provider.dart';
import 'package:myecl/raffle/providers/user_tickets_provider.dart';
import 'package:myecl/raffle/router.dart';
import 'package:myecl/raffle/tools/constants.dart';
import 'package:myecl/raffle/ui/components/section_title.dart';
import 'package:myecl/raffle/ui/pages/main_page/raffle_card.dart';
import 'package:myecl/raffle/ui/pages/main_page/ticket_card.dart';
import 'package:myecl/raffle/ui/raffle.dart';
import 'package:myecl/tools/ui/admin_button.dart';
import 'package:myecl/tools/ui/loader.dart';
import 'package:myecl/tools/ui/refresher.dart';
import 'package:qlevar_router/qlevar_router.dart';

class RaffleMainPage extends HookConsumerWidget {
  const RaffleMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final raffleList = ref.watch(raffleListProvider);
    final raffleListNotifier = ref.watch(raffleListProvider.notifier);
    final userTicketList = ref.watch(userTicketListProvider);
    final userTicketListNotifier = ref.watch(userTicketListProvider.notifier);
    final isAdmin = ref.watch(isRaffleAdminProvider);

    final rafflesStatus = {};
    raffleList.whenData(
      (raffles) {
        for (var raffle in raffles) {
          rafflesStatus[raffle.id] = raffle.raffleStatusType;
        }
      },
    );

    return RaffleTemplate(
      child: Refresher(
        onRefresh: () async {
          await userTicketListNotifier.loadTicketList();
          await raffleListNotifier.loadRaffleList();
        },
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SectionTitle(text: RaffleTextConstants.tickets),
                  if (isAdmin)
                    AdminButton(
                      onTap: () {
                        QR.to(RaffleRouter.root + RaffleRouter.admin);
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            userTicketList.when(
              data: (tickets) {
                tickets = tickets
                    .where((t) =>
                        t.prize != null ||
                        (rafflesStatus.containsKey(t.typeTicket.raffleId) &&
                            rafflesStatus[t.typeTicket.raffleId] !=
                                RaffleStatusType.locked))
                    .toList();
                final ticketSum = <String, List<Ticket>>{};
                final ticketPrice = <String, double>{};
                for (final ticket in tickets) {
                  if (ticket.prize == null) {
                    final id = ticket.typeTicket.raffleId;
                    if (ticketSum.containsKey(id)) {
                      ticketSum[id]!.add(ticket);
                      ticketPrice[id] = ticketPrice[id]! +
                          ticket.typeTicket.price / ticket.typeTicket.packSize;
                    } else {
                      ticketSum[id] = [ticket];
                      ticketPrice[id] =
                          ticket.typeTicket.price / ticket.typeTicket.packSize;
                    }
                  } else {
                    final id = ticketSum.length.toString();
                    ticketSum[id] = [ticket];
                    ticketPrice[id] =
                        ticket.typeTicket.price / ticket.typeTicket.packSize;
                  }
                }
                return ticketSum.isEmpty
                    ? const Center(
                        child: Text(RaffleTextConstants.noTicket),
                      )
                    : SizedBox(
                        height: 210,
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: ticketSum.length + 2,
                            itemBuilder: (context, index) {
                              if (index == 0 || index == ticketSum.length + 1) {
                                return const SizedBox(
                                  width: 15,
                                );
                              }
                              final key = ticketSum.keys.toList()[index - 1];
                              return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: TicketWidget(
                                    ticket: ticketSum[key]!,
                                    price: ticketPrice[key]!,
                                  ));
                            }));
              },
              loading: () => const SizedBox(height: 120, child: Loader()),
              error: (error, stack) => SizedBox(
                  height: 120,
                  child: Center(
                    child: Text('Error $error',
                        style: const TextStyle(fontSize: 20)),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: raffleList.when(
                  data: (raffles) {
                    final incomingRaffles = <Raffle>[];
                    final pastRaffles = <Raffle>[];
                    final onGoingRaffles = <Raffle>[];
                    for (final raffle in raffles) {
                      switch (raffle.raffleStatusType) {
                        case RaffleStatusType.creation:
                          incomingRaffles.add(raffle);
                          break;
                        case RaffleStatusType.open:
                          onGoingRaffles.add(raffle);
                          break;
                        case RaffleStatusType.locked:
                          pastRaffles.add(raffle);
                          break;
                      }
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (onGoingRaffles.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(
                                bottom: 10, top: 20, left: 5),
                            child: const SectionTitle(
                                text: RaffleTextConstants.actualRaffles),
                          ),
                        ...onGoingRaffles
                            .map((e) => RaffleWidget(raffle: e))
                            .toList(),
                        if (incomingRaffles.isNotEmpty)
                          Container(
                              margin: const EdgeInsets.only(
                                  bottom: 10, top: 20, left: 5),
                              child: const SectionTitle(
                                  text: RaffleTextConstants.nextRaffles)),
                        ...incomingRaffles
                            .map((e) => RaffleWidget(raffle: e))
                            .toList(),
                        if (pastRaffles.isNotEmpty)
                          Container(
                              margin: const EdgeInsets.only(
                                  bottom: 10, top: 20, left: 5),
                              child: const SectionTitle(
                                  text: RaffleTextConstants.pastRaffles)),
                        ...pastRaffles
                            .map((e) => RaffleWidget(raffle: e))
                            .toList(),
                        if (onGoingRaffles.isEmpty &&
                            incomingRaffles.isEmpty &&
                            pastRaffles.isEmpty)
                          const SizedBox(
                            height: 100,
                            child: Center(
                              child: Text(
                                RaffleTextConstants.noCurrentRaffle,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          )
                      ],
                    );
                  },
                  error: (Object error, StackTrace stackTrace) => Center(
                      child: SizedBox(
                          height: 120,
                          child: Text("Error $error",
                              style: const TextStyle(fontSize: 20)))),
                  loading: () => const Center(
                      child: SizedBox(height: 120, child: Loader()))),
            ),
          ],
        ),
      ),
    );
  }
}
