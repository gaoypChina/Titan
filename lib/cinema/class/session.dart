import 'package:myecl/tools/functions.dart';

class Session {
  late final String id;
  late final String name;
  late final DateTime start;
  late final int duration;
  late final String overview;
  late final String posterUrl;
  late final String genre;
  late final String tagline;

  Session(
      {required this.id,
      required this.name,
      required this.start,
      required this.duration,
      required this.overview,
      required this.posterUrl,
      required this.genre,
      required this.tagline});

  Session.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    start = DateTime.parse(json["start"]);
    duration = json["duration"];
    overview = json["overview"];
    posterUrl = json["poster_url"];
    genre = json["genre"];
    tagline = json["tagline"];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["start"] = processDateToAPI(start);
    data["duration"] = duration;
    data["overview"] = overview;
    data["poster_url"] = posterUrl;
    data["genre"] = genre;
    data["tagline"] = tagline;
    return data;
  }

  Session copyWith(
      {id, name, start, duration, overview, posterUrl, genre, tagline}) {
    return Session(
        id: id ?? this.id,
        name: name ?? this.name,
        start: start ?? this.start,
        duration: duration ?? this.duration,
        overview: overview ?? this.overview,
        posterUrl: posterUrl ?? this.posterUrl,
        genre: genre ?? this.genre,
        tagline: tagline ?? this.tagline);
  }

  static Session empty() {
    return Session(
        id: "",
        name: "",
        start: DateTime.now(),
        duration: 0,
        overview: "",
        posterUrl: "",
        genre: "",
        tagline: "");
  }
}