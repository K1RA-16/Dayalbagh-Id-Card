// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class satsangiListData {
  static List<SatsangiData> satsangiList = [];
  static int index = 0;
}

class SatsangiData {
  final String uid;
  final String name;
  final String dob;
  final bool card_Print_Status;
  final String region;

  final String father_Or_Spouse_Name;
  final bool bioMetric_Status;
  final String branch;
  final String title;

  SatsangiData({
    required this.uid,
    required this.name,
    required this.dob,
    required this.card_Print_Status,
    required this.region,
    required this.father_Or_Spouse_Name,
    required this.bioMetric_Status,
    required this.branch,
    required this.title,
  });

  SatsangiData copyWith({
    String? uid,
    String? name,
    String? dob,
    bool? card_Print_Status,
    String? region,
    String? father_Or_Spouse_Name,
    bool? bioMetric_Status,
    String? branch,
    String? title,
  }) {
    return SatsangiData(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      card_Print_Status: card_Print_Status ?? this.card_Print_Status,
      region: region ?? this.region,
      father_Or_Spouse_Name:
          father_Or_Spouse_Name ?? this.father_Or_Spouse_Name,
      bioMetric_Status: bioMetric_Status ?? this.bioMetric_Status,
      branch: branch ?? this.branch,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'dob': dob,
      'card_Print_Status': card_Print_Status,
      'region': region,
      'father_Or_Spouse_Name': father_Or_Spouse_Name,
      'bioMetric_Status': bioMetric_Status,
      'branch': branch,
      'title': title,
    };
  }

  factory SatsangiData.fromMap(Map<String, dynamic> map) {
    return SatsangiData(
      uid: map['uid'] as String,
      name: map['name'] as String,
      dob: map['dob'] as String,
      card_Print_Status: map['card_Print_Status'] as bool,
      region: map['region'] as String,
      father_Or_Spouse_Name: map['father_Or_Spouse_Name'] as String,
      bioMetric_Status: map['bioMetric_Status'] as bool,
      branch: map['branch'] as String,
      title: map['title'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SatsangiData.fromJson(String source) =>
      SatsangiData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SatsangiData(uid: $uid, name: $name, dob: $dob, card_Print_Status: $card_Print_Status, region: $region, father_Or_Spouse_Name: $father_Or_Spouse_Name, bioMetric_Status: $bioMetric_Status, branch: $branch, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SatsangiData &&
        other.uid == uid &&
        other.name == name &&
        other.dob == dob &&
        other.card_Print_Status == card_Print_Status &&
        other.region == region &&
        other.father_Or_Spouse_Name == father_Or_Spouse_Name &&
        other.bioMetric_Status == bioMetric_Status &&
        other.branch == branch &&
        other.title == title;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        dob.hashCode ^
        card_Print_Status.hashCode ^
        region.hashCode ^
        father_Or_Spouse_Name.hashCode ^
        bioMetric_Status.hashCode ^
        branch.hashCode ^
        title.hashCode;
  }
}
