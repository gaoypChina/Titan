import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myecl/admin/providers/group_id_provider.dart';
import 'package:myecl/admin/providers/group_provider.dart';
import 'package:myecl/admin/providers/group_list_provider.dart';
import 'package:myecl/admin/providers/settings_page_provider.dart';
import 'package:myecl/admin/ui/pages/main_page/asso_ui.dart';
import 'package:myecl/admin/ui/refresh_indicator.dart';
import 'package:myecl/loan/providers/loaner_list_provider.dart';
import 'package:myecl/admin/tools/constants.dart';
import 'package:myecl/tools/token_expire_wrapper.dart';
import 'package:myecl/user/providers/user_list_provider.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(allGroupListProvider);
    final groupsNotifier = ref.watch(allGroupListProvider.notifier);
    final pageNotifier = ref.watch(adminPageProvider.notifier);
    final groupNotifier = ref.watch(groupProvider.notifier);
    final groupIdNotifier = ref.watch(groupIdProvider.notifier);
    final loans = ref.watch(loanerList);
    final loanListNotifier = ref.watch(loanerListProvider.notifier);
    ref.watch(userList);
    return AdminRefresher(
      onRefresh: () async {
        await groupsNotifier.loadGroups();
        await loanListNotifier.loadLoanerList();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: groups.when(data: (g) {
          return Column(children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(AdminTextConstants.administration,
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)),
            ),
            const SizedBox(
              height: 50,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(AdminTextConstants.association,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AdminColorConstants.gradient1)),
            ),
            const SizedBox(
              height: 30,
            ),
            ...g
                .map(
                  (x) => AssoUi(
                    name: x.name,
                    onTap: () async {
                      groupIdNotifier.setId(x.id);
                      tokenExpireWrapper(ref, () async {
                        await groupNotifier.loadGroup(x.id);
                        pageNotifier.setAdminPage(AdminPage.asso);
                      });
                    },
                  ),
                )
                .toList(),
            GestureDetector(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AdminColorConstants.gradient1,
                      AdminColorConstants.gradient2,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AdminColorConstants.gradient2.withOpacity(0.5),
                      blurRadius: 5,
                      offset: const Offset(2, 2),
                      spreadRadius: 2,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  AdminTextConstants.addAssociation,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              onTap: () {
                pageNotifier.setAdminPage(AdminPage.addAsso);
              },
            ),
            if (loans.isNotEmpty)
              Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(AdminTextConstants.loaningAssociation,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AdminColorConstants.gradient1)),
                  const SizedBox(height: 10),
                  ...loans
                      .map((x) => AssoUi(
                          name: x.name,
                          onTap: () async {
                            groupIdNotifier.setId(x.groupManagerId);
                            await groupNotifier.loadGroup(x.groupManagerId);
                            pageNotifier.setAdminPage(AdminPage.asso);
                          }))
                      .toList(),
                ],
              ),
            GestureDetector(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AdminColorConstants.gradient1,
                      AdminColorConstants.gradient2,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AdminColorConstants.gradient2.withOpacity(0.5),
                      blurRadius: 5,
                      offset: const Offset(2, 2),
                      spreadRadius: 2,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  AdminTextConstants.addLoaningAssociation,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              onTap: () {
                pageNotifier.setAdminPage(AdminPage.addLoaner);
              },
            )
          ]);
        }, error: (e, s) {
          return Text(e.toString());
        }, loading: () {
          return const Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AdminColorConstants.gradient1),
          ));
        }),
      ),
    );
  }
}
