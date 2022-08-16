import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myecl/amap/tools/functions.dart';
import 'package:myecl/loan/class/loan.dart';
import 'package:myecl/loan/providers/loaner_id_provider.dart';
import 'package:myecl/loan/providers/loaner_list_provider.dart';
import 'package:myecl/loan/providers/loaner_provider.dart';
import 'package:myecl/loan/providers/item_list_provider.dart';
import 'package:myecl/loan/providers/loan_list_provider.dart';
import 'package:myecl/loan/providers/selected_items_provider.dart';
import 'package:myecl/loan/providers/loan_page_provider.dart';
import 'package:myecl/loan/tools/constants.dart';
import 'package:myecl/loan/tools/functions.dart';
import 'package:myecl/tools/tokenExpireWrapper.dart';

class AddLoanPage extends HookConsumerWidget {
  const AddLoanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageNotifier = ref.watch(loanPageProvider.notifier);
    final _currentStep = useState(0);
    final key = GlobalKey<FormState>();
    final asso = useState(ref.watch(loanerProvider));
    final associations = ref.watch(loanerListProvider);
    final items = useState(ref.watch(itemListProvider));
    final itemListNotifier = ref.watch(itemListProvider.notifier);
    final selectedItems = ref.watch(selectedListProvider);
    final selectedItemsNotifier = ref.watch(selectedListProvider.notifier);
    final loanListNotifier = ref.watch(loanListProvider.notifier);
    final loanerId = ref.watch(loanerIdProvider);
    final start = useTextEditingController();
    final end = useTextEditingController();
    final number = useTextEditingController();
    final note = useTextEditingController();
    final caution = useState(false);

    Widget w = const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(LoanColorConstants.orange),
      ),
    );

    associations.when(
      data: (listAsso) {
        if (listAsso.isNotEmpty) {
          print(listAsso);
          List<Step> steps = [
            Step(
              title: const Text(LoanTextConstants.association),
              content: Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: LoanColorConstants.lightGrey,
                  unselectedWidgetColor: LoanColorConstants.lightGrey,
                ),
                child: Column(
                    children: listAsso
                        .map(
                          (e) => RadioListTile(
                              title: Text(capitalize(e.name),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                              selected: asso.value.name == e.name,
                              value: e.name,
                              activeColor: LoanColorConstants.orange,
                              groupValue: asso.value.name,
                              onChanged: (s) async {
                                print('onChanged');
                                asso.value = e;
                                itemListNotifier.setId(e.id);
                                items.value =
                                    await itemListNotifier.loadLoanList();
                                print('items ${items.value}');
                              }),
                        )
                        .toList()),
              ),
              isActive: _currentStep.value >= 0,
              state: _currentStep.value >= 0
                  ? StepState.complete
                  : StepState.disabled,
            ),
            Step(
              title: const Text(LoanTextConstants.objects),
              content: Column(
                children: items.value.when(data: (itemList) {
                  return itemList
                      .map(
                        (e) => CheckboxListTile(
                          title: Text(e.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                          value: selectedItems[itemList.indexOf(e)],
                          onChanged: (s) {
                            selectedItemsNotifier.toggle(itemList.indexOf(e));
                          },
                        ),
                      )
                      .toList();
                }, error: (error, s) {
                  return [
                    Text(error.toString(),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                  ];
                }, loading: () {
                  return [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          LoanColorConstants.orange),
                    ),
                  ];
                }),
              ),
              isActive: _currentStep.value >= 0,
              state: _currentStep.value >= 1
                  ? StepState.complete
                  : StepState.disabled,
            ),
            Step(
              title: const Text(LoanTextConstants.dates),
              content: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 30),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(bottom: 3),
                            padding: const EdgeInsets.only(left: 10),
                            child: const Text(
                              LoanTextConstants.beginDate,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 85, 85, 85),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _selectDate(context, start),
                            child: SizedBox(
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: start,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(10),
                                    isDense: true,
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 85, 85, 85))),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.blue)),
                                    errorBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red)),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 158, 158, 158),
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return LoanTextConstants.enterDate;
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 30),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(bottom: 3),
                              padding: const EdgeInsets.only(left: 10),
                              child: const Text(
                                LoanTextConstants.endDate,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 85, 85, 85),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _selectDate(context, end),
                              child: SizedBox(
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: end,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      isDense: true,
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 85, 85, 85))),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.blue)),
                                      errorBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 158, 158, 158),
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return LoanTextConstants.enterDate;
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ])),
                ],
              ),
              isActive: _currentStep.value >= 0,
              state: _currentStep.value >= 3
                  ? StepState.complete
                  : StepState.disabled,
            ),
            Step(
              // TODO:
              title: const Text(LoanTextConstants.borrower),
              content: Column(
                children: <Widget>[
                  TextFormField(
                    controller: number,
                    decoration:
                        const InputDecoration(labelText: 'Mobile Number'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null) {
                        return LoanTextConstants.noValue;
                      } else if (int.tryParse(value) == null) {
                        return LoanTextConstants.invalidNumber;
                      }
                      return null;
                    },
                  ),
                ],
              ),
              isActive: _currentStep.value >= 0,
              state: _currentStep.value >= 4
                  ? StepState.complete
                  : StepState.disabled,
            ),
            Step(
              title: const Text(LoanTextConstants.note),
              content: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: LoanTextConstants.note),
                    controller: note,
                    validator: (value) {
                      if (value == null) {
                        return LoanTextConstants.noValue;
                      }
                      return null;
                    },
                  ),
                ],
              ),
              isActive: _currentStep.value >= 0,
              state: _currentStep.value >= 5
                  ? StepState.complete
                  : StepState.disabled,
            ),
            Step(
              title: const Text(LoanTextConstants.caution),
              content: CheckboxListTile(
                value: caution.value,
                title: const Text(LoanTextConstants.paidCaution),
                onChanged: (value) {
                  caution.value = !caution.value;
                },
              ),
              isActive: _currentStep.value >= 0,
              state: _currentStep.value >= 6
                  ? StepState.complete
                  : StepState.disabled,
            ),
            Step(
              title: const Text(LoanTextConstants.confirmation),
              content: Column(
                children: <Widget>[
                  Row(
                    children: [
                      const Text(LoanTextConstants.association + " : "),
                      Text(asso.value.name),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(LoanTextConstants.borrower + " : "),
                      Text(number.text),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(LoanTextConstants.objects + " : "),
                      ...items.value.when(
                        data: (itemList) {
                          return itemList
                              .where((element) =>
                                  selectedItems[itemList.indexOf(element)])
                              .map(
                                (e) => Text(
                                  e.name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                              .toList();
                        },
                        error: (error, s) {
                          return [Text(error.toString())];
                        },
                        loading: () {
                          return [
                            const Center(
                                child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                  LoanColorConstants.orange),
                            ))
                          ];
                        },
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text(LoanTextConstants.beginDate + " : "),
                      Text(start.text),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(LoanTextConstants.endDate + " : "),
                      Text(end.text),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(LoanTextConstants.note + " : "),
                      Text(note.text),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(LoanTextConstants.paidCaution + " : "),
                      Text(caution.value
                          ? LoanTextConstants.yes
                          : LoanTextConstants.no),
                    ],
                  ),
                ],
              ),
              isActive: _currentStep.value >= 0,
              state: _currentStep.value >= 7
                  ? StepState.complete
                  : StepState.disabled,
            ),
          ];

          void continued() {
            _currentStep.value < steps.length ? _currentStep.value += 1 : null;
          }

          void cancel() {
            _currentStep.value > 0 ? _currentStep.value -= 1 : null;
          }

          w = Form(
            key: key,
            child: Stepper(
              physics: const BouncingScrollPhysics(),
              currentStep: _currentStep.value,
              onStepTapped: (step) => _currentStep.value = step,
              onStepContinue: continued,
              onStepCancel: cancel,
              controlsBuilder: (context, ControlsDetails controls) {
                final isLastStep = _currentStep.value == steps.length - 1;
                return Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: !isLastStep
                            ? controls.onStepContinue
                            : () {
                                if (key.currentState == null) {
                                  return;
                                }
                                if (key.currentState!.validate()) {
                                  if (start.text.compareTo(end.text) >= 0) {
                                    displayToast(context, TypeMsg.error,
                                        LoanTextConstants.invalidDates);
                                  } else {
                                    pageNotifier.setLoanPage(LoanPage.main);
                                    items.value.when(
                                      data: (itemList) {
                                        tokenExpireWrapper(ref, () async {
                                          loanListNotifier
                                              .addLoan(
                                            Loan(
                                              loanerId: loanerId,
                                              items: itemList
                                                  .where((element) =>
                                                      selectedItems[itemList
                                                          .indexOf(element)])
                                                  .toList(),
                                              borrowerId: number.text,
                                              caution: caution.value,
                                              end: DateTime.parse(end.text),
                                              id: "",
                                              notes: note.text,
                                              start: DateTime.parse(start.text),
                                            ),
                                          )
                                              .then((value) {
                                            if (value) {
                                              displayToast(context, TypeMsg.msg,
                                                  LoanTextConstants.addedLoan);
                                            } else {
                                              displayToast(
                                                  context,
                                                  TypeMsg.error,
                                                  LoanTextConstants
                                                      .addingError);
                                            }
                                          });
                                        });
                                      },
                                      error: (error, s) {
                                        displayToast(context, TypeMsg.error,
                                            error.toString());
                                      },
                                      loading: () {
                                        displayToast(context, TypeMsg.error,
                                            LoanTextConstants.addingError);
                                      },
                                    );
                                    _currentStep.value = 0;
                                  }
                                } else {
                                  displayToast(
                                      context,
                                      TypeMsg.error,
                                      LoanTextConstants
                                          .incorrectOrMissingFields);
                                }
                              },
                        child: (isLastStep)
                            ? const Text(LoanTextConstants.add)
                            : const Text(LoanTextConstants.next),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (_currentStep.value > 0)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: controls.onStepCancel,
                          child: const Text(LoanTextConstants.previous),
                        ),
                      )
                  ],
                );
              },
              steps: steps,
            ),
          );
        } else {
          w = const Text(LoanTextConstants.noAssociationsFounded);
        }
      },
      error: (e, s) {
        w = Text(e.toString());
      },
      loading: () {},
    );

    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(), child: w);
  }

  _selectDate(
      BuildContext context, TextEditingController dateController) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: DateTime(now.year + 1, now.month, now.day));
    dateController.text = DateFormat('yyyy-MM-dd').format(picked ?? now);
  }
}
