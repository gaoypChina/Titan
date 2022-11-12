import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:myecl/tools/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';

enum TypeMsg { msg, error }

void displayToast(BuildContext context, TypeMsg type, String text) {
  LinearGradient linearGradient;
  HeroIcons icon;

  switch (type) {
    case TypeMsg.msg:
      linearGradient = const LinearGradient(
          colors: [ColorConstants.gradient1, ColorConstants.gradient2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight);
      icon = HeroIcons.check;
      break;
    case TypeMsg.error:
      linearGradient = const LinearGradient(
          colors: [ColorConstants.background2, Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight);
      icon = HeroIcons.exclamationTriangle;
      break;
  }

  showFlash(
      context: context,
      duration: const Duration(seconds: 2),
      builder: (context, controller) {
        return Flash.dialog(
          controller: controller,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          backgroundGradient: linearGradient,
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: HeroIcon(icon, color: Colors.white),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 120,
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    text,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    maxLines: 4,
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

String capitalize(String s) {
  if (s.isEmpty) {
    return s;
  }
  return s[0].toUpperCase() + s.substring(1);
}

String processDate(DateTime date) {
  return "${date.day.toString().padLeft(2, "0")}/${date.month.toString().padLeft(2, "0")}/${date.year}";
}

String processDateWithHour(DateTime date) {
  return "${processDate(date)} ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}";
}

String processDatePrint(String d) {
  if (d == "") {
    return "";
  }
  List<String> e = d.split("-");
  return "${e[2].toString().padLeft(2, "0")}/${e[1].toString().padLeft(2, "0")}/${e[0]}";
}

String processDateBack(String d) {
  if (d == "") {
    return "";
  }
  List<String> e = d.split("/");
  return "${e[2].toString().padLeft(2, "0")}-${e[1].toString().padLeft(2, "0")}-${e[0]}";
}

String processDateToAPI(DateTime date) {
  return date.toIso8601String();
}

String processDateToAPIWitoutHour(DateTime date) {
  return date.toIso8601String().split('T')[0];
}
