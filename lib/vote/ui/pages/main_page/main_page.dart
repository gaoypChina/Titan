import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/tools/refresher.dart';
import 'package:myecl/vote/class/pretendance.dart';
import 'package:myecl/vote/providers/is_vote_admin_provider.dart';
import 'package:myecl/vote/providers/pretendance_list_provider.dart';
import 'package:myecl/vote/providers/pretendance_logo_provider.dart';
import 'package:myecl/vote/providers/pretendance_logos_provider.dart';
import 'package:myecl/vote/providers/sections_pretendance_provider.dart';
import 'package:myecl/vote/providers/sections_provider.dart';
import 'package:myecl/vote/providers/status_provider.dart';
import 'package:myecl/vote/providers/vote_page_provider.dart';
import 'package:myecl/vote/providers/voted_section_provider.dart';
import 'package:myecl/vote/repositories/status_repository.dart';
import 'package:myecl/vote/tools/constants.dart';
import 'package:myecl/vote/ui/pages/main_page/list_pretendence_card.dart';
import 'package:myecl/vote/ui/pages/main_page/list_side_item.dart';
import 'package:myecl/vote/ui/pages/main_page/section_title.dart';
import 'package:myecl/vote/ui/pages/main_page/vote_button.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageNotifier = ref.watch(votePageProvider.notifier);
    final status = ref.watch(statusProvider);
    final statusNotifier = ref.watch(statusProvider.notifier);
    final isAdmin = ref.watch(isVoteAdmin);
    final sections = ref.watch(sectionsProvider);
    final sectionsNotifier = ref.watch(sectionsProvider.notifier);
    final sectionsPretendances = ref.watch(sectionPretendanceProvider);
    final pretendances = ref.watch(pretendanceListProvider);
    final sectionPretendanceNotifier =
        ref.watch(sectionPretendanceProvider.notifier);
    return status.when(data: (s) {
      if (s == Status.open) {
        final logosNotifier = ref.watch(pretendenceLogoProvider.notifier);
        final votedSection = ref.watch(votedSectionProvider);
        final votedSectionNotifier = ref.watch(votedSectionProvider.notifier);
        final pretendanceLogosNotifier =
            ref.watch(pretendanceLogosProvider.notifier);
        final animation = useAnimationController(
          duration: const Duration(milliseconds: 2400),
        );

        List<String> alreadyVotedSection = [];
        votedSection.when(
            data: (voted) {
              alreadyVotedSection = voted;
            },
            error: (error, stackTrace) {},
            loading: () {});

        return Refresher(
          onRefresh: () async {
            await statusNotifier.loadStatus();
            await votedSectionNotifier.getVotedSections();
            final sections = await sectionsNotifier.loadSectionList();
            sections.whenData((value) {
              List<Pretendance> list = [];
              pretendances.when(data: (pretendance) {
                list = pretendance;
              }, error: (error, stackTrace) {
                list = [];
              }, loading: () {
                list = [];
              });
              sectionPretendanceNotifier.loadTList(value);
              pretendanceLogosNotifier.loadTList(list);
              for (final l in value) {
                if (!alreadyVotedSection.contains(l.id)) {
                  sectionPretendanceNotifier.setTData(
                      l,
                      AsyncValue.data(list
                          .where((element) => element.section.id == l.id)
                          .toList()));
                }
              }
              for (final l in list) {
                logosNotifier.getLogo(l.id).then((value) =>
                    pretendanceLogosNotifier.setTData(
                        l, AsyncValue.data([value])));
              }
            });
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 100,
            child: Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Column(children: [
                  SizedBox(
                    height: isAdmin ? 10 : 15,
                  ),
                  sections.when(
                    data: (sectionList) => Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height -
                              (isAdmin ? 215 : 220),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListSideItem(
                                  sectionList: sectionList,
                                  animation: animation),
                              Expanded(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: sectionsPretendances.when(
                                    data: (pretendanceList) =>
                                        Column(children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SectionTitle(
                                              sectionList: sectionList),
                                          if (isAdmin)
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  right: 20),
                                              child: GestureDetector(
                                                onTap: () {
                                                  pageNotifier.setVotePage(
                                                      VotePage.admin);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.2),
                                                            blurRadius: 10,
                                                            offset:
                                                                const Offset(
                                                                    0, 5))
                                                      ]),
                                                  child: Row(
                                                    children: const [
                                                      HeroIcon(
                                                          HeroIcons.userGroup,
                                                          color: Colors.white),
                                                      SizedBox(width: 10),
                                                      Text("Admin",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .white)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Expanded(
                                          child: ListPretendenceCard(
                                        animation: animation,
                                      ))
                                    ]),
                                    loading: () => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    error: (error, stack) => const Center(
                                      child: Text('Error'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (sectionList.isNotEmpty) const VoteButton(),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => const Center(child: Text('Error')),
                  ),
                ])),
          ),
        );
      } else {
        return Refresher(
            onRefresh: () async {
              await statusNotifier.loadStatus();
              final sections = await sectionsNotifier.loadSectionList();
              sections.whenData((value) {
                List<Pretendance> list = [];
                pretendances.when(data: (pretendance) {
                  list = pretendance;
                }, error: (error, stackTrace) {
                  list = [];
                }, loading: () {
                  list = [];
                });
                sectionPretendanceNotifier.loadTList(value);
                for (final l in value) {
                  sectionPretendanceNotifier.setTData(
                      l,
                      AsyncValue.data(list
                          .where((element) => element.section.id == l.id)
                          .toList()));
                }
              });
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: Column(children: [
                SizedBox(
                  height: isAdmin ? 10 : 15,
                ),
                sections.when(
                  data: (sectionList) => Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          sectionsPretendances.when(
                            data: (pretendanceList) => Column(children: [
                              Row(
                                children: [
                                  const Text(
                                    VoteTextConstants.section,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 243,
                                  ),
                                  isAdmin
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(right: 20),
                                          child: GestureDetector(
                                            onTap: () {
                                              pageNotifier
                                                  .setVotePage(VotePage.admin);
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.2),
                                                        blurRadius: 10,
                                                        offset:
                                                            const Offset(0, 5))
                                                  ]),
                                              child: Row(
                                                children: const [
                                                  HeroIcon(HeroIcons.userGroup,
                                                      color: Colors.white),
                                                  SizedBox(width: 10),
                                                  Text("Admin",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Text(
                                s == Status.waiting
                                    ? VoteTextConstants.notOpenedVote
                                    : s == Status.closed
                                        ? VoteTextConstants.closedVote
                                        : VoteTextConstants.onGoingCount,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              ...pretendanceList
                                  .map((key, value) => MapEntry(
                                        key,
                                        value.when(
                                          data: (pretendance) => Align(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  60,
                                              margin: const EdgeInsets.only(
                                                  right: 30, bottom: 30),
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text(
                                                            key.name,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          const SizedBox(
                                                            height: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 3,
                                                          ),
                                                          Text(
                                                            pretendance.length
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ),
                                          loading: () => const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          error: (error, stack) => const Center(
                                              child: Text('Error')),
                                        ),
                                      ))
                                  .values
                            ]),
                            error: (Object error, StackTrace stackTrace) {
                              return Center(child: Text('Error $error'));
                            },
                            loading: () {
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                        ]),
                  ),
                  error: (Object error, StackTrace stackTrace) {
                    return Center(child: Text('Error $error'));
                  },
                  loading: () {
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ]),
            ));
      }
    }, error: (Object error, StackTrace stackTrace) {
      return const Center(
        child: Text("Error"),
      );
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
