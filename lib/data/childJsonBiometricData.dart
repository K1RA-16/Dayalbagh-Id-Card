// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChildJsonBiometric {
  final String name;
  final String dob;
  final String Gender;
  final String uid;
  final String father_name;
  final String parent_uid_one;
  final String parent_uid_two;
  final String mobile;
  final String branch;
  final int ISO_FP_1;
  final int ISO_FP_2;
  final int ISO_FP_3;
  final int ISO_FP_4;
  final String FingerPrint_1;
  final String FingerPrint_2;
  final String FingerPrint_3;
  final String FingerPrint_4;
  final String FaceImage;
  ChildJsonBiometric({
    required this.name,
    required this.dob,
    required this.Gender,
    required this.uid,
    required this.father_name,
    required this.parent_uid_one,
    required this.parent_uid_two,
    required this.mobile,
    required this.branch,
    required this.ISO_FP_1,
    required this.ISO_FP_2,
    required this.ISO_FP_3,
    required this.ISO_FP_4,
    required this.FingerPrint_1,
    required this.FingerPrint_2,
    required this.FingerPrint_3,
    required this.FingerPrint_4,
    required this.FaceImage,
  });

  ChildJsonBiometric copyWith({
    String? name,
    String? dob,
    String? Gender,
    String? uid,
    String? father_name,
    String? parent_uid_one,
    String? parent_uid_two,
    String? mobile,
    String? branch,
    int? ISO_FP_1,
    int? ISO_FP_2,
    int? ISO_FP_3,
    int? ISO_FP_4,
    String? FingerPrint_1,
    String? FingerPrint_2,
    String? FingerPrint_3,
    String? FingerPrint_4,
    String? FaceImage,
  }) {
    return ChildJsonBiometric(
      name: name ?? this.name,
      dob: dob ?? this.dob,
      Gender: Gender ?? this.Gender,
      uid: uid ?? this.uid,
      father_name: father_name ?? this.father_name,
      parent_uid_one: parent_uid_one ?? this.parent_uid_one,
      parent_uid_two: parent_uid_two ?? this.parent_uid_two,
      mobile: mobile ?? this.mobile,
      branch: branch ?? this.branch,
      ISO_FP_1: ISO_FP_1 ?? this.ISO_FP_1,
      ISO_FP_2: ISO_FP_2 ?? this.ISO_FP_2,
      ISO_FP_3: ISO_FP_3 ?? this.ISO_FP_3,
      ISO_FP_4: ISO_FP_4 ?? this.ISO_FP_4,
      FingerPrint_1: FingerPrint_1 ?? this.FingerPrint_1,
      FingerPrint_2: FingerPrint_2 ?? this.FingerPrint_2,
      FingerPrint_3: FingerPrint_3 ?? this.FingerPrint_3,
      FingerPrint_4: FingerPrint_4 ?? this.FingerPrint_4,
      FaceImage: FaceImage ?? this.FaceImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'dob': dob,
      'Gender': Gender,
      'uid': uid,
      'father_name': father_name,
      'parent_uid_one': parent_uid_one,
      'parent_uid_two': parent_uid_two,
      'mobile': mobile,
      'branch': branch,
      'ISO_FP_1': ISO_FP_1,
      'ISO_FP_2': ISO_FP_2,
      'ISO_FP_3': ISO_FP_3,
      'ISO_FP_4': ISO_FP_4,
      'FingerPrint_1': FingerPrint_1,
      'FingerPrint_2': FingerPrint_2,
      'FingerPrint_3': FingerPrint_3,
      'FingerPrint_4': FingerPrint_4,
      'FaceImage': FaceImage,
    };
  }

  factory ChildJsonBiometric.fromMap(Map<String, dynamic> map) {
    return ChildJsonBiometric(
      name: map['name'] as String,
      dob: map['dob'] as String,
      Gender: map['Gender'] as String,
      uid: map['uid'] as String,
      father_name: map['father_name'] as String,
      parent_uid_one: map['parent_uid_one'] as String,
      parent_uid_two: map['parent_uid_two'] as String,
      mobile: map['mobile'] as String,
      branch: map['branch'] as String,
      ISO_FP_1: map['ISO_FP_1'] as int,
      ISO_FP_2: map['ISO_FP_2'] as int,
      ISO_FP_3: map['ISO_FP_3'] as int,
      ISO_FP_4: map['ISO_FP_4'] as int,
      FingerPrint_1: map['FingerPrint_1'] as String,
      FingerPrint_2: map['FingerPrint_2'] as String,
      FingerPrint_3: map['FingerPrint_3'] as String,
      FingerPrint_4: map['FingerPrint_4'] as String,
      FaceImage: map['FaceImage'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChildJsonBiometric.fromJson(String source) =>
      ChildJsonBiometric.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChildJsonBiometric(name: $name, dob: $dob, Gender: $Gender, uid: $uid, father_name: $father_name, parent_uid_one: $parent_uid_one, parent_uid_two: $parent_uid_two, mobile: $mobile, branch: $branch, ISO_FP_1: $ISO_FP_1, ISO_FP_2: $ISO_FP_2, ISO_FP_3: $ISO_FP_3, ISO_FP_4: $ISO_FP_4, FingerPrint_1: $FingerPrint_1, FingerPrint_2: $FingerPrint_2, FingerPrint_3: $FingerPrint_3, FingerPrint_4: $FingerPrint_4, FaceImage: $FaceImage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChildJsonBiometric &&
        other.name == name &&
        other.dob == dob &&
        other.Gender == Gender &&
        other.uid == uid &&
        other.father_name == father_name &&
        other.parent_uid_one == parent_uid_one &&
        other.parent_uid_two == parent_uid_two &&
        other.mobile == mobile &&
        other.branch == branch &&
        other.ISO_FP_1 == ISO_FP_1 &&
        other.ISO_FP_2 == ISO_FP_2 &&
        other.ISO_FP_3 == ISO_FP_3 &&
        other.ISO_FP_4 == ISO_FP_4 &&
        other.FingerPrint_1 == FingerPrint_1 &&
        other.FingerPrint_2 == FingerPrint_2 &&
        other.FingerPrint_3 == FingerPrint_3 &&
        other.FingerPrint_4 == FingerPrint_4 &&
        other.FaceImage == FaceImage;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        dob.hashCode ^
        Gender.hashCode ^
        uid.hashCode ^
        father_name.hashCode ^
        parent_uid_one.hashCode ^
        parent_uid_two.hashCode ^
        mobile.hashCode ^
        branch.hashCode ^
        ISO_FP_1.hashCode ^
        ISO_FP_2.hashCode ^
        ISO_FP_3.hashCode ^
        ISO_FP_4.hashCode ^
        FingerPrint_1.hashCode ^
        FingerPrint_2.hashCode ^
        FingerPrint_3.hashCode ^
        FingerPrint_4.hashCode ^
        FaceImage.hashCode;
  }
}
