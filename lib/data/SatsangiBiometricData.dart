// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

//update biometric data
class SatsangiBiometricData {
  final String uid;
  final int iso1;
  final int iso2;
  final int iso3;
  final int iso4;
  final String fingerprint1;
  final String fingerprint2;
  final String fingerprint3;
  final String fingerprint4;
  final String concent;
  final String faceimage;
  SatsangiBiometricData({
    required this.uid,
    required this.iso1,
    required this.iso2,
    required this.iso3,
    required this.iso4,
    required this.fingerprint1,
    required this.fingerprint2,
    required this.fingerprint3,
    required this.fingerprint4,
    required this.concent,
    required this.faceimage,
  });

  SatsangiBiometricData copyWith({
    String? uid,
    int? iso1,
    int? iso2,
    int? iso3,
    int? iso4,
    String? fingerprint1,
    String? fingerprint2,
    String? fingerprint3,
    String? fingerprint4,
    String? concent,
    String? faceimage,
  }) {
    return SatsangiBiometricData(
      uid: uid ?? this.uid,
      iso1: iso1 ?? this.iso1,
      iso2: iso2 ?? this.iso2,
      iso3: iso3 ?? this.iso3,
      iso4: iso4 ?? this.iso4,
      fingerprint1: fingerprint1 ?? this.fingerprint1,
      fingerprint2: fingerprint2 ?? this.fingerprint2,
      fingerprint3: fingerprint3 ?? this.fingerprint3,
      fingerprint4: fingerprint4 ?? this.fingerprint4,
      concent: concent ?? this.concent,
      faceimage: faceimage ?? this.faceimage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'ISO_FP_1': iso1,
      'ISO_FP_2': iso2,
      'ISO_FP_3': iso3,
      'ISO_FP_4': iso4,
      'FingerPrint_1': fingerprint1,
      'FingerPrint_2': fingerprint2,
      'FingerPrint_3': fingerprint3,
      'FingerPrint_4': fingerprint4,
      'concent': concent,
      'FaceImage': faceimage,
    };
  }

  factory SatsangiBiometricData.fromMap(Map<String, dynamic> map) {
    return SatsangiBiometricData(
      uid: map['uid'] as String,
      iso1: map['ISO_FP_1'] as int,
      iso2: map['ISO_FP_2'] as int,
      iso3: map['ISO_FP_3'] as int,
      iso4: map['ISO_FP_4'] as int,
      fingerprint1: map['FingerPrint_1'] as String,
      fingerprint2: map['FingerPrint_2'] as String,
      fingerprint3: map['FingerPrint_3'] as String,
      fingerprint4: map['FingerPrint_4'] as String,
      concent: map['concent'] as String,
      faceimage: map['FaceImage'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SatsangiBiometricData.fromJson(String source) =>
      SatsangiBiometricData.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SatsangiBiometricData(uid: $uid, iso1: $iso1, iso2: $iso2, iso3: $iso3, iso4: $iso4, fingerprint1: $fingerprint1, fingerprint2: $fingerprint2, fingerprint3: $fingerprint3, fingerprint4: $fingerprint4, concent: $concent, faceimage: $faceimage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SatsangiBiometricData &&
        other.uid == uid &&
        other.iso1 == iso1 &&
        other.iso2 == iso2 &&
        other.iso3 == iso3 &&
        other.iso4 == iso4 &&
        other.fingerprint1 == fingerprint1 &&
        other.fingerprint2 == fingerprint2 &&
        other.fingerprint3 == fingerprint3 &&
        other.fingerprint4 == fingerprint4 &&
        other.concent == concent &&
        other.faceimage == faceimage;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        iso1.hashCode ^
        iso2.hashCode ^
        iso3.hashCode ^
        iso4.hashCode ^
        fingerprint1.hashCode ^
        fingerprint2.hashCode ^
        fingerprint3.hashCode ^
        fingerprint4.hashCode ^
        concent.hashCode ^
        faceimage.hashCode;
  }
}
