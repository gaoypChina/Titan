import 'package:myecl/tombola/class/prize.dart';
import 'package:myecl/tombola/class/pack_ticket.dart';
import 'package:myecl/tombola/class/stats.dart';
import 'package:myecl/tombola/class/tickets.dart';
import 'package:myecl/tools/repository/repository.dart';

class RaffleDetailRepository extends Repository {
  @override
  // ignore: overridden_fields
  final ext = "tombola/raffle/";

  Future<List<PackTicket>> getPackTicketListFromRaffle(String raffleId) async {
    return List<PackTicket>.from((await getList(suffix: "$raffleId/pack_tickets"))
        .map((x) => PackTicket.fromJson(x)));
  }

  
  Future<List<Ticket>> getTicketListFromRaffle(String raffleId) async {
    return List<Ticket>.from((await getList(suffix: "$raffleId/tickets"))
        .map((x) => Ticket.fromJson(x)));
  }

  Future<List<Prize>> getLotListFromRaffle(String raffleId) async {
    return List<Prize>.from((await getList(suffix: "$raffleId/lots"))
        .map((x) => Prize.fromJson(x)));
  }

  Future<RaffleStats> getRaffleStats(String raffleId) async {
    return RaffleStats.fromJson(await getOne(raffleId, suffix: "/stats"));
  }
}
