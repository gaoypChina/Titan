import 'package:flutter/material.dart';

class EventColorConstants {
  static final Color background = Colors.grey.shade100;
  static const Color gradient1 = Color(0xFFfb6d10);
  static const Color gradient2 = Color(0xffeb3e1b);
  static const Color background2 = Color(0xFF222643);
}

class EventTextConstants {
  static const String add = "Ajouter";
  static const String addEvent = "Ajouter un événement";
  static const String addedEvent = "Événement ajouté";
  static const String addingError = "Erreur lors de l'ajout";
  static const String allDay = "Toute la journée";
  static const String confirmation = "Confirmation";
  static const String dates = "Dates";
  static const String delete = "Supprimer";
  static const String deletedEvent = "Événement supprimé";
  static const String deleting = "Suppression";
  static const String deletingError = "Erreur lors de la suppression";
  static const String deletingEvent = "Supprimer l'événement ?";
  static const String description = "Description";
  static const String edit = "Modifier";
  static const String endDate = "Date de fin";
  static const String endHour = "Heure de fin";
  static const String eventList = "Liste des événements";
  static const String eventType = "Type d'événement";
  static const String every = "Tous les";
  static const String incorrectOrMissingFields =
      "Certains champs sont incorrects ou manquants";
  static const String interval = "Intervalle";
  static const String invalidDates =
      "La date de fin doit être après la date de début";
  static const String invalidIntervalError =
      "Veuillez entrer un intervalle valide";
  static const String name = "Nom";
  static const String next = "Suivant";
  static const String no = "Non";
  static const String noDateError = "Veuillez entrer une date";
  static const String noDescriptionError = "Veuillez entrer une description";
  static const String noEvent = "Aucun événement";
  static const String noNameError = "Veuillez entrer un nom";
  static const String noOrganizerError = "Veuillez entrer un organisateur";
  static const String noPlaceError = "Veuillez entrer un lieu";
  static const String noRuleError = "Veuillez entrer une règle de récurrence";
  static const String organizer = "Organisateur";
  static const String place = "Lieu";
  static const String previous = "Précédent";
  static const String recurrence = "Récurrence";
  static const String recurrenceDays = "Jours de récurrence";
  static const String recurrenceEndDate = "Date de fin de la récurrence";
  static const String recurrenceRule = "Règle de récurrence";
  static const String startDate = "Date de début";
  static const String startHour = "Heure de début";
  static const String title = "Événements";
  static const String yes = "Oui";
  static const String eventEvery = "Toutes les";
  static const String weeks = "semaines";

  static const List<String> dayList = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
    'Dimanche'
  ];
}
