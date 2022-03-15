// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SatsangiGetBiometricMap {
  static Map<String, dynamic> data = new Map();
}

class SatsangiGetBiometric {
  //get biometric data

  final String name;
  final String father_Or_Spouse_Name;
  final String dob;

  final String branch;

  final String date_of_issue;
  final String status;
  final String gender;
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
  SatsangiGetBiometric({
    required this.name,
    required this.father_Or_Spouse_Name,
    required this.dob,
    required this.branch,
    required this.date_of_issue,
    required this.status,
    required this.gender,
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

  SatsangiGetBiometric copyWith({
    String? name,
    String? father_Or_Spouse_Name,
    String? dob,
    String? branch,
    String? date_of_issue,
    String? status,
    String? gender,
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
    return SatsangiGetBiometric(
      name: name ?? this.name,
      father_Or_Spouse_Name:
          father_Or_Spouse_Name ?? this.father_Or_Spouse_Name,
      dob: dob ?? this.dob,
      branch: branch ?? this.branch,
      date_of_issue: date_of_issue ?? this.date_of_issue,
      status: status ?? this.status,
      gender: gender ?? this.gender,
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
      'name': name,
      'father_Or_Spouse_Name': father_Or_Spouse_Name,
      'dob': dob,
      'branch': branch,
      'date_of_issue': date_of_issue,
      'status': status,
      'gender': gender,
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

  factory SatsangiGetBiometric.fromMap(Map<String, dynamic> map) {
    return SatsangiGetBiometric(
      name: map['name'] as String,
      father_Or_Spouse_Name: map['father_Or_Spouse_Name'] as String,
      dob: map['dob'] as String,
      branch: map['branch'] as String,
      date_of_issue: map['date_of_issue'] as String,
      status: map['status'] as String,
      gender: map['gender'] as String,
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

  factory SatsangiGetBiometric.fromJson(String source) =>
      SatsangiGetBiometric.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SatsangiGetBiometric(name: $name, father_Or_Spouse_Name: $father_Or_Spouse_Name, dob: $dob, branch: $branch, date_of_issue: $date_of_issue, status: $status, gender: $gender, isO_FP_1: $isO_FP_1, isO_FP_2: $isO_FP_2, isO_FP_3: $isO_FP_3, isO_FP_4: $isO_FP_4, fingerPrint_1: $fingerPrint_1, fingerPrint_2: $fingerPrint_2, fingerPrint_3: $fingerPrint_3, fingerPrint_4: $fingerPrint_4, image: $image, uid: $uid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SatsangiGetBiometric &&
        other.name == name &&
        other.father_Or_Spouse_Name == father_Or_Spouse_Name &&
        other.dob == dob &&
        other.branch == branch &&
        other.date_of_issue == date_of_issue &&
        other.status == status &&
        other.gender == gender &&
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
    return name.hashCode ^
        father_Or_Spouse_Name.hashCode ^
        dob.hashCode ^
        branch.hashCode ^
        date_of_issue.hashCode ^
        status.hashCode ^
        gender.hashCode ^
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
