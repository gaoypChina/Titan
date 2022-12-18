import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/admin/providers/group_id_provider.dart';
import 'package:myecl/admin/providers/group_list_provider.dart';
import 'package:myecl/admin/providers/settings_page_provider.dart';
import 'package:myecl/admin/ui/pages/main_page/asso_ui.dart';
import 'package:myecl/loan/providers/loaner_list_provider.dart';
import 'package:myecl/admin/tools/constants.dart';
import 'package:myecl/tools/constants.dart';
import 'package:myecl/tools/dialog.dart';
import 'package:myecl/tools/functions.dart';
import 'package:myecl/tools/refresher.dart';
import 'package:myecl/tools/token_expire_wrapper.dart';
import 'package:myecl/user/providers/user_list_provider.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(allGroupListProvider);
    final groupsNotifier = ref.watch(allGroupListProvider.notifier);
    final pageNotifier = ref.watch(adminPageProvider.notifier);
    final groupIdNotifier = ref.watch(groupIdProvider.notifier);
    final loans = ref.watch(loanerListProvider);
    final loanListNotifier = ref.watch(loanerListProvider.notifier);
    ref.watch(userList);
    void displayToastWithContext(TypeMsg type, String msg) {
      displayToast(context, type, msg);
    }

    final loanersId = [];

    loans.whenData(
        (value) => loanersId.addAll(value.map((e) => e.groupManagerId)));

    return Refresher(
      onRefresh: () async {
        await groupsNotifier.loadGroups();
        await loanListNotifier.loadLoanerList();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: groups.when(data: (g) {
          return Column(children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    pageNotifier.setAdminPage(AdminPage.addAsso);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 5,
                              spreadRadius: 2)
                        ]),
                    child: Row(
                      children: [
                        const Spacer(),
                        HeroIcon(
                          HeroIcons.plus,
                          color: Colors.grey.shade700,
                          size: 40,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    pageNotifier.setAdminPage(AdminPage.addLoaner);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 5,
                              spreadRadius: 2)
                        ]),
                    child: Row(
                      children: [
                        const Spacer(),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            HeroIcon(
                              HeroIcons.buildingLibrary,
                              color: Colors.grey.shade700,
                              size: 40,
                            ),
                            Positioned(
                              right: -2,
                              top: -2,
                              child: HeroIcon(
                                HeroIcons.plus,
                                size: 15,
                                color: Colors.grey.shade700,
                              ),
                            )
                          ],
                        ),
                        const Spacer()
                      ],
                    ),
                  ),
                ),
                ...g
                    .map((group) => AssoUi(
                          group: group,
                          isLoaner: loanersId.contains(group.id),
                          onTap: () async {
                            groupIdNotifier.setId(group.id);
                            pageNotifier.setAdminPage(AdminPage.asso);
                          },
                          onEdit: () {
                            groupIdNotifier.setId(group.id);
                            pageNotifier.setAdminPage(AdminPage.edit);
                          },
                          onDelete: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomDialogBox(
                                    title: AdminTextConstants.deleting,
                                    descriptions:
                                        AdminTextConstants.deleteAssociation,
                                    onYes: () async {
                                      tokenExpireWrapper(ref, () async {
                                        final value = await groupsNotifier
                                            .deleteGroup(group);
                                        if (value) {
                                          displayToastWithContext(
                                              TypeMsg.msg,
                                              AdminTextConstants
                                                  .deletedAssociation);
                                        } else {
                                          displayToastWithContext(TypeMsg.error,
                                              AdminTextConstants.deletingError);
                                        }
                                      });
                                    },
                                  );
                                });
                          },
                        ))
                    .toList(),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ]);
        }, error: (e, s) {
          return Text(e.toString());
        }, loading: () {
          return const Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(ColorConstants.gradient1),
          ));
        }),
      ),
    );
  }
}
