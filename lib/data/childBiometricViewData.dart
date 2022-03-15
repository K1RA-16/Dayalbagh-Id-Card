// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChildBiometricData {
  static Map<String, dynamic> data = new Map();
}

class ChildBiometricView {
  final int id;
  final String gender;

  final String name;
  final String father_name;
  final String dob;
  final String parent_uid_one;
  final String parent_uid_two;
  final String branch;
  final String first_created;
  final String last_updated;
  final int isO_FP_1;
  final int isO_FP_2;
  final int isO_FP_3;
  final int isO_FP_4;
  final String fingerPrint_1;
  final String fingerPrint_2;
  final String fingerPrint_3;
  final String fingerPrint_4;
  final String image;
  final String uid;
  ChildBiometricView({
    required this.id,
    required this.gender,
    required this.name,
    required this.father_name,
    required this.dob,
    required this.parent_uid_one,
    required this.parent_uid_two,
    required this.branch,
    required this.first_created,
    required this.last_updated,
    required this.isO_FP_1,
    required this.isO_FP_2,
    required this.isO_FP_3,
    required this.isO_FP_4,
    required this.fingerPrint_1,
    required this.fingerPrint_2,
    required this.fingerPrint_3,
    required this.fingerPrint_4,
    required this.image,
    required this.uid,
  });

  ChildBiometricView copyWith({
    int? id,
    String? gender,
    String? name,
    String? father_name,
    String? dob,
    String? parent_uid_one,
    String? parent_uid_two,
    String? branch,
    String? first_created,
    String? last_updated,
    int? isO_FP_1,
    int? isO_FP_2,
    int? isO_FP_3,
    int? isO_FP_4,
    String? fingerPrint_1,
    String? fingerPrint_2,
    String? fingerPrint_3,
    String? fingerPrint_4,
    String? image,
    String? uid,
  }) {
    return ChildBiometricView(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      name: name ?? this.name,
      father_name: father_name ?? this.father_name,
      dob: dob ?? this.dob,
      parent_uid_one: parent_uid_one ?? this.parent_uid_one,
      parent_uid_two: parent_uid_two ?? this.parent_uid_two,
      branch: branch ?? this.branch,
      first_created: first_created ?? this.first_created,
      last_updated: last_updated ?? this.last_updated,
      isO_FP_1: isO_FP_1 ?? this.isO_FP_1,
      isO_FP_2: isO_FP_2 ?? this.isO_FP_2,
      isO_FP_3: isO_FP_3 ?? this.isO_FP_3,
      isO_FP_4: isO_FP_4 ?? this.isO_FP_4,
      fingerPrint_1: fingerPrint_1 ?? this.fingerPrint_1,
      fingerPrint_2: fingerPrint_2 ?? this.fingerPrint_2,
      fingerPrint_3: fingerPrint_3 ?? this.fingerPrint_3,
      fingerPrint_4: fingerPrint_4 ?? this.fingerPrint_4,
      image: image ?? this.image,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'gender': gender,
      'name': name,
      'father_name': father_name,
      'dob': dob,
      'parent_uid_one': parent_uid_one,
      'parent_uid_two': parent_uid_two,
      'branch': branch,
      'first_created': first_created,
      'last_updated': last_updated,
      'isO_FP_1': isO_FP_1,
      'isO_FP_2': isO_FP_2,
      'isO_FP_3': isO_FP_3,
      'isO_FP_4': isO_FP_4,
      'fingerPrint_1': fingerPrint_1,
      'fingerPrint_2': fingerPrint_2,
      'fingerPrint_3': fingerPrint_3,
      'fingerPrint_4': fingerPrint_4,
      'image': image,
      'uid': uid,
    };
  }

  factory ChildBiometricView.fromMap(Map<String, dynamic> map) {
    return ChildBiometricView(
      id: map['id'] as int,
      gender: map['gender'] as String,
      name: map['name'] as String,
      father_name: map['father_name'] as String,
      dob: map['dob'] as String,
      parent_uid_one: map['parent_uid_one'] as String,
      parent_uid_two: map['parent_uid_two'] as String,
      branch: map['branch'] as String,
      first_created: map['first_created'] as String,
      last_updated: map['last_updated'] as String,
      isO_FP_1: map['isO_FP_1'] as int,
      isO_FP_2: map['isO_FP_2'] as int,
      isO_FP_3: map['isO_FP_3'] as int,
      isO_FP_4: map['isO_FP_4'] as int,
      fingerPrint_1: map['fingerPrint_1'] as String,
      fingerPrint_2: map['fingerPrint_2'] as String,
      fingerPrint_3: map['fingerPrint_3'] as String,
      fingerPrint_4: map['fingerPrint_4'] as String,
      image: map['image'] as String,
      uid: map['uid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChildBiometricView.fromJson(String source) =>
      ChildBiometricView.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChildBiometricView(id: $id, gender: $gender, name: $name, father_name: $father_name, dob: $dob, parent_uid_one: $parent_uid_one, parent_uid_two: $parent_uid_two, branch: $branch, first_created: $first_created, last_updated: $last_updated, isO_FP_1: $isO_FP_1, isO_FP_2: $isO_FP_2, isO_FP_3: $isO_FP_3, isO_FP_4: $isO_FP_4, fingerPrint_1: $fingerPrint_1, fingerPrint_2: $fingerPrint_2, fingerPrint_3: $fingerPrint_3, fingerPrint_4: $fingerPrint_4, image: $image, uid: $uid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChildBiometricView &&
        other.id == id &&
        other.gender == gender &&
        other.name == name &&
        other.father_name == father_name &&
        other.dob == dob &&
        other.parent_uid_one == parent_uid_one &&
        other.parent_uid_two == parent_uid_two &&
        other.branch == branch &&
        other.first_created == first_created &&
        other.last_updated == last_updated &&
        other.isO_FP_1 == isO_FP_1 &&
        other.isO_FP_2 == isO_FP_2 &&
        other.isO_FP_3 == isO_FP_3 &&
        other.isO_FP_4 == isO_FP_4 &&
        other.fingerPrint_1 == fingerPrint_1 &&
        other.fingerPrint_2 == fingerPrint_2 &&
        other.fingerPrint_3 == fingerPrint_3 &&
        other.fingerPrint_4 == fingerPrint_4 &&
        other.image == image &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        gender.hashCode ^
        name.hashCode ^
        father_name.hashCode ^
        dob.hashCode ^
        parent_uid_one.hashCode ^
        parent_uid_two.hashCode ^
        branch.hashCode ^
        first_created.hashCode ^
        last_updated.hashCode ^
        isO_FP_1.hashCode ^
        isO_FP_2.hashCode ^
        isO_FP_3.hashCode ^
        isO_FP_4.hashCode ^
        fingerPrint_1.hashCode ^
        fingerPrint_2.hashCode ^
        fingerPrint_3.hashCode ^
        fingerPrint_4.hashCode ^
        image.hashCode ^
        uid.hashCode;
  }
}
