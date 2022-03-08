import 'dart:convert';

class satsangiListData {
  static List<SatsangiData> satsangiList = [];
  static int index = 0;
}

class SatsangiData {
  final String uid;
  final String name;
  final String dob;
  final String doi_First;
  final String doi_Second;
  final String mobile;
  final String father_Or_Spouse_Name;
  final bool bioMetric_Status;
  SatsangiData({
    required this.uid,
    required this.name,
    required this.dob,
    required this.doi_First,
    required this.doi_Second,
    required this.mobile,
    required this.father_Or_Spouse_Name,
    required this.bioMetric_Status,
  });

  SatsangiData copyWith({
    String? uid,
    String? name,
    String? dob,
    String? doi_First,
    String? doi_Second,
    String? mobile,
    String? father_Or_Spouse_Name,
    bool? bioMetric_Status,
  }) {
    return SatsangiData(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      doi_First: doi_First ?? this.doi_First,
      doi_Second: doi_Second ?? this.doi_Second,
      mobile: mobile ?? this.mobile,
      father_Or_Spouse_Name:
          father_Or_Spouse_Name ?? this.father_Or_Spouse_Name,
      bioMetric_Status: bioMetric_Status ?? this.bioMetric_Status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'dob': dob,
      'doi_First': doi_First,
      'doi_Second': doi_Second,
      'mobile': mobile,
      'father_Or_Spouse_Name': father_Or_Spouse_Name,
      'bioMetric_Status': bioMetric_Status,
    };
  }

  factory SatsangiData.fromMap(Map<String, dynamic> map) {
    return SatsangiData(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      dob: map['dob'] ?? '',
      doi_First: map['doi_First'] ?? '',
      doi_Second: map['doi_Second'] ?? '',
      mobile: map['mobile'] ?? '',
      father_Or_Spouse_Name: map['father_Or_Spouse_Name'] ?? '',
      bioMetric_Status: map['bioMetric_Status'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory SatsangiData.fromJson(String source) =>
      SatsangiData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SatsangiData(uid: $uid, name: $name, dob: $dob, doi_First: $doi_First, doi_Second: $doi_Second, mobile: $mobile, father_Or_Spouse_Name: $father_Or_Spouse_Name, bioMetric_Status: $bioMetric_Status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SatsangiData &&
        other.uid == uid &&
        other.name == name &&
        other.dob == dob &&
        other.doi_First == doi_First &&
        other.doi_Second == doi_Second &&
        other.mobile == mobile &&
        other.father_Or_Spouse_Name == father_Or_Spouse_Name &&
        other.bioMetric_Status == bioMetric_Status;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        dob.hashCode ^
        doi_First.hashCode ^
        doi_Second.hashCode ^
        mobile.hashCode ^
        father_Or_Spouse_Name.hashCode ^
        bioMetric_Status.hashCode;
  }
}
