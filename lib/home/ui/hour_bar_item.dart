// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:myecl/event/class/event.dart';
// import 'package:myecl/event/providers/event_list_provider.dart';
// import 'package:myecl/home/tools/functions.dart';
// import 'package:myecl/home/ui/even_ui.dart';
// import 'package:myecl/tools/functions.dart';

// class HourBarItems extends ConsumerWidget {
//   const HourBarItems({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final res = ref.watch(eventListProvider);
//     final now = DateTime.now();
//     final strNow = processDateToAPIWitoutHour(now);

//     List<Widget> getHourBarItem(double width) {
//       List<Widget> hourBar = [];
//       double dh = 0;
//       double dl = 0;
//       res.when(
//         data: (data) {
//           for (Event e in data) {
//             if (e.recurrenceRule == "" && e.allDay) {
//               DateTime newStart = DateTime.parse(
//                   "${e.start.toString().split(" ")[0]} 00:00:00");
//               DateTime newEnd =
//                   DateTime.parse("${e.end.toString().split(" ")[0]} 23:59:00");
//               data[data.indexOf(e)] =
//                   e.copyWith(fakeStart: newStart, fakeEnd: newEnd);
//             } else if (isDateInReccurence(e.recurrenceRule, strNow, e.start)) {
//               if (e.allDay) {
//                 DateTime newStart =
//                     DateTime.parse("${now.toString().split(" ")[0]} 00:00:00");
//                 DateTime newEnd =
//                     DateTime.parse("${now.toString().split(" ")[0]} 23:59:00");
//                 data[data.indexOf(e)] =
//                     e.copyWith(fakeStart: newStart, fakeEnd: newEnd);
//               } else {
//                 DateTime newStart = DateTime.parse(
//                     "${now.toString().split(" ")[0]} ${e.start.toString().split(" ")[1]}");
//                 DateTime newEnd = DateTime.parse(
//                     "${now.toString().split(" ")[0]} ${e.end.toString().split(" ")[1]}");
//                 data[data.indexOf(e)] =
//                     e.copyWith(fakeStart: newStart, fakeEnd: newEnd);
//               }
//             } else {
//               data[data.indexOf(e)] =
//                   e.copyWith(fakeStart: e.start, fakeEnd: e.end);
//             }
//           }
//           data.sort((a, b) => a.fakeStart.compareTo(b.fakeStart));
//           final todaysEvent = data
//               .where((element) =>
//                   processDateToAPIWitoutHour(element.fakeStart)
//                           .compareTo(strNow) <=
//                       0 &&
//                   processDateToAPIWitoutHour(element.fakeEnd)
//                           .compareTo(strNow) >=
//                       0)
//               .toList();
//           int i = 1;
//           List<Event> toGather = [];
//           while (i < todaysEvent.length) {
//             Event r = todaysEvent[i - 1];
//             DateTime start = correctBeforeDate(r.fakeStart);
//             DateTime end = correctAfterDate(r.fakeEnd);
//             Event nextR = todaysEvent[i];
//             if (isDateBetween(nextR.fakeStart, start, end)) {
//               if (!toGather.contains(r)) {
//                 toGather.add(r);
//               }
//               toGather.add(nextR);
//             } else {
//               if (toGather.isEmpty) {
//                 double h = start.hour + start.minute / 60;
//                 double l =
//                     (end.hour - start.hour) + (end.minute - start.minute) / 60;
//                 double ph = h - dh;
//                 hourBar.add(SizedBox(
//                   height: (ph - dl) * 90.0,
//                 ));
//                 hourBar.add(Container(
//                   margin: const EdgeInsets.only(
//                     left: 20,
//                     right: 15,
//                   ),
//                   child: EventUI(
//                     r: r,
//                     l: l,
//                     neverStart: r.start != r.fakeStart &&
//                         r.recurrenceRule == "" &&
//                         !r.allDay,
//                     neverEnd: r.end != r.fakeEnd &&
//                         r.recurrenceRule == "" &&
//                         !r.allDay,
//                   ),
//                 ));
//                 dh = h;
//                 dl = l;
//               } else {
//                 DateTime start = correctBeforeDate(toGather[0].start);
//                 double nextH = start.hour + start.minute / 60;
//                 List<double> maxL = [];
//                 hourBar.add(Container(
//                     margin: const EdgeInsets.only(
//                       left: 10,
//                       right: 10,
//                     ),
//                     child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: toGather.map((e) {
//                           DateTime start = correctBeforeDate(e.fakeStart);
//                           DateTime end = correctAfterDate(e.fakeEnd);
//                           double h = start.hour + start.minute / 60;
//                           double l = (end.hour - start.hour) +
//                               (end.minute - start.minute) / 60;
//                           maxL.add(l);
//                           double ph = h - dh;
//                           return Container(
//                             width: width / toGather.length - 25,
//                             margin: const EdgeInsets.only(
//                               left: 10,
//                             ),
//                             child: Column(
//                               children: [
//                                 SizedBox(
//                                   height: (ph - dl) * 90.0,
//                                 ),
//                                 EventUI(
//                                   r: e,
//                                   l: l,
//                                   n: toGather.length,
//                                   neverStart: r.start != r.fakeStart &&
//                                       r.recurrenceRule == "" &&
//                                       !r.allDay,
//                                   neverEnd: r.end != r.fakeEnd &&
//                                       r.recurrenceRule == "" &&
//                                       !r.allDay,
//                                 ),
//                               ],
//                             ),
//                           );
//                         }).toList())));
//                 toGather = [];
//                 dh = nextH;
//                 dl = maxL.reduce(max);
//               }
//             }
//             i++;
//           }
//           if (toGather.isEmpty) {
//             if (todaysEvent.isNotEmpty) {
//               Event r = todaysEvent.last;
//               DateTime start = correctBeforeDate(r.fakeStart);
//               DateTime end = correctAfterDate(r.fakeEnd);
//               double h = start.hour + start.minute / 60;
//               double l =
//                   (end.hour - start.hour) + (end.minute - start.minute) / 60;
//               double ph = h - dh;
//               hourBar.add(SizedBox(
//                 height: (ph - dl) * 90.0,
//               ));
//               hourBar.add(Container(
//                   margin: const EdgeInsets.only(
//                     left: 20,
//                     right: 15,
//                   ),
//                   child: EventUI(
//                     r: r,
//                     l: l,
//                     neverStart: r.start != r.fakeStart &&
//                         r.recurrenceRule == "" &&
//                         !r.allDay,
//                     neverEnd: r.end != r.fakeEnd &&
//                         r.recurrenceRule == "" &&
//                         !r.allDay,
//                   )));
//             }
//           } else {
//             DateTime start = correctBeforeDate(toGather[0].fakeStart);
//             double nextH = start.hour + start.minute / 60;
//             List<double> maxL = [];
//             hourBar.add(Container(
//                 margin: const EdgeInsets.only(
//                   left: 10,
//                   right: 10,
//                 ),
//                 child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: toGather.map((e) {
//                       DateTime start = correctBeforeDate(e.fakeStart);
//                       DateTime end = correctAfterDate(e.fakeEnd);

//                       double h = start.hour + start.minute / 60;
//                       double l = (end.hour - start.hour) +
//                           (end.minute - start.minute) / 60;
//                       maxL.add(l);
//                       double ph = h - dh;
//                       return Container(
//                         width: width / toGather.length - 25,
//                         margin: const EdgeInsets.only(
//                           left: 10,
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height: (ph - dl) * 90.0,
//                             ),
//                             EventUI(
//                               r: e,
//                               l: l,
//                               n: toGather.length,
//                               neverStart: e.start != e.fakeStart &&
//                                   e.recurrenceRule == "" &&
//                                   !e.allDay,
//                               neverEnd: e.end != e.fakeEnd &&
//                                   e.recurrenceRule == "" &&
//                                   !e.allDay,
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList())));
//             toGather = [];
//             dh = nextH;
//             dl = maxL.reduce(max);
//           }
//         },
//         loading: () =>
//             hourBar.add(const Center(child: CircularProgressIndicator())),
//         error: (e, s) => hourBar.add(Text(e.toString())),
//       );
//       return hourBar;
//     }

//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: getHourBarItem(constraints.maxWidth));
//       },
//     );
//   }
// }
