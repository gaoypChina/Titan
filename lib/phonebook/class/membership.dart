import 'package:myecl/phonebook/class/association.dart';

class Membership {
  Membership({
    required this.id,
    required this.association,
    required this.rolesTags,
    required this.apparentName,
  });

  late final String id;
  late final Association association;
  late final List<String> rolesTags;
  late final String apparentName;

  Membership.fromJSON(Map<String, dynamic> json) {
    id = json['id'];
    association = json['association'];
    rolesTags = json['roleTags'];
    apparentName = json['apparentName'];
  }

  Map<String, dynamic> toJSON() {
    final data = <String, dynamic>{
      'id': id,
      'association': association.id,
      'roleTags': rolesTags,
      'apparentName': apparentName,
    };
    return data;
  }

  Membership copyWith({
    String? id,
    Association? association,
    List<String>? rolesTags,
    String? apparentName,
  }) {
    return Membership(
      id: id ?? this.id,
      association: association ?? this.association,
      rolesTags: rolesTags ?? this.rolesTags,
      apparentName: apparentName ?? this.apparentName,
    );
  }

  Membership.empty() {
    id = "";
    association = Association.empty();
    rolesTags = [];
    apparentName = "";
  }

  Membership setAssociation(String name, String id) {
    return copyWith(association: association.copyWith(name: name, id: id));
  }

  Membership setRolesTags(List<String> rolesTags) {
    return copyWith(rolesTags: rolesTags);
  }

  Membership setApparentName(String apparentName) {
    return copyWith(apparentName: apparentName);
  }

  @override
  String toString() {
    return 'Membership(id: $id, association: $association, rolesTags: $rolesTags, apparentName: $apparentName)';
  }
}
