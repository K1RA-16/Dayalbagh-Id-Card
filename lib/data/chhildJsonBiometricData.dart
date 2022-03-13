import 'dart:convert';

class ChildJsonBiometric {
  final String name;
  final String dob;
  //final String gender;
  final String uid;
  final String father_name;
  final String parent_uid_one;
  final String parent_uid_two;
  //final String mobile;
  final int branch;
  final int iso1;
  final int iso2;
  final int iso3;
  final int iso4;
  final String fingerprint1;
  final String fingerprint2;
  final String fingerprint3;
  final String fingerprint4;
  final String faceimage;
  ChildJsonBiometric({
    required this.name,
    required this.dob,
    required this.uid,
    required this.father_name,
    required this.parent_uid_one,
    required this.parent_uid_two,
    required this.branch,
    required this.iso1,
    required this.iso2,
    required this.iso3,
    required this.iso4,
    required this.fingerprint1,
    required this.fingerprint2,
    required this.fingerprint3,
    required this.fingerprint4,
    required this.faceimage,
  });

  ChildJsonBiometric copyWith({
    String? name,
    String? dob,
    String? uid,
    String? father_name,
    String? parent_uid_one,
    String? parent_uid_two,
    int? branch,
    int? iso1,
    int? iso2,
    int? iso3,
    int? iso4,
    String? fingerprint1,
    String? fingerprint2,
    String? fingerprint3,
    String? fingerprint4,
    String? faceimage,
  }) {
    return ChildJsonBiometric(
      name: name ?? this.name,
      dob: dob ?? this.dob,
      uid: uid ?? this.uid,
      father_name: father_name ?? this.father_name,
      parent_uid_one: parent_uid_one ?? this.parent_uid_one,
      parent_uid_two: parent_uid_two ?? this.parent_uid_two,
      branch: branch ?? this.branch,
      iso1: iso1 ?? this.iso1,
      iso2: iso2 ?? this.iso2,
      iso3: iso3 ?? this.iso3,
      iso4: iso4 ?? this.iso4,
      fingerprint1: fingerprint1 ?? this.fingerprint1,
      fingerprint2: fingerprint2 ?? this.fingerprint2,
      fingerprint3: fingerprint3 ?? this.fingerprint3,
      fingerprint4: fingerprint4 ?? this.fingerprint4,
      faceimage: faceimage ?? this.faceimage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dob': dob,
      'uid': uid,
      'father_name': father_name,
      'parent_uid_one': parent_uid_one,
      'parent_uid_two': parent_uid_two,
      'branch': branch,
      'iso1': iso1,
      'iso2': iso2,
      'iso3': iso3,
      'iso4': iso4,
      'fingerprint1': fingerprint1,
      'fingerprint2': fingerprint2,
      'fingerprint3': fingerprint3,
      'fingerprint4': fingerprint4,
      'faceimage': faceimage,
    };
  }

  factory ChildJsonBiometric.fromMap(Map<String, dynamic> map) {
    return ChildJsonBiometric(
      name: map['name'] ?? '',
      dob: map['dob'] ?? '',
      uid: map['uid'] ?? '',
      father_name: map['father_name'] ?? '',
      parent_uid_one: map['parent_uid_one'] ?? '',
      parent_uid_two: map['parent_uid_two'] ?? '',
      branch: map['branch']?.toInt() ?? 0,
      iso1: map['iso1']?.toInt() ?? 0,
      iso2: map['iso2']?.toInt() ?? 0,
      iso3: map['iso3']?.toInt() ?? 0,
      iso4: map['iso4']?.toInt() ?? 0,
      fingerprint1: map['fingerprint1'] ?? '',
      fingerprint2: map['fingerprint2'] ?? '',
      fingerprint3: map['fingerprint3'] ?? '',
      fingerprint4: map['fingerprint4'] ?? '',
      faceimage: map['faceimage'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChildJsonBiometric.fromJson(String source) =>
      ChildJsonBiometric.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChildJsonBiometric(name: $name, dob: $dob, uid: $uid, father_name: $father_name, parent_uid_one: $parent_uid_one, parent_uid_two: $parent_uid_two, branch: $branch, iso1: $iso1, iso2: $iso2, iso3: $iso3, iso4: $iso4, fingerprint1: $fingerprint1, fingerprint2: $fingerprint2, fingerprint3: $fingerprint3, fingerprint4: $fingerprint4, faceimage: $faceimage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ChildJsonBiometric &&
      other.name == name &&
      other.dob == dob &&
      other.uid == uid &&
      other.father_name == father_name &&
      other.parent_uid_one == parent_uid_one &&
      other.parent_uid_two == parent_uid_two &&
      other.branch == branch &&
      other.iso1 == iso1 &&
      other.iso2 == iso2 &&
      other.iso3 == iso3 &&
      other.iso4 == iso4 &&
      other.fingerprint1 == fingerprint1 &&
      other.fingerprint2 == fingerprint2 &&
      other.fingerprint3 == fingerprint3 &&
      other.fingerprint4 == fingerprint4 &&
      other.faceimage == faceimage;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      dob.hashCode ^
      uid.hashCode ^
      father_name.hashCode ^
      parent_uid_one.hashCode ^
      parent_uid_two.hashCode ^
      branch.hashCode ^
      iso1.hashCode ^
      iso2.hashCode ^
      iso3.hashCode ^
      iso4.hashCode ^
      fingerprint1.hashCode ^
      fingerprint2.hashCode ^
      fingerprint3.hashCode ^
      fingerprint4.hashCode ^
      faceimage.hashCode;
  }
}
