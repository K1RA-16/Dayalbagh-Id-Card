import 'dart:convert';

class ChildList {
  static List<ChildListData> childList = [];
  static int index = 0;
  static int childrenNo = 0;
}

class ChildListData {
  final int id;
  final String uid;
  final String name;
  final String father_name;
  ChildListData({
    required this.id,
    required this.uid,
    required this.name,
    required this.father_name,
  });

  ChildListData copyWith({
    int? id,
    String? uid,
    String? name,
    String? father_name,
  }) {
    return ChildListData(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      father_name: father_name ?? this.father_name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'father_name': father_name,
    };
  }

  factory ChildListData.fromMap(Map<String, dynamic> map) {
    return ChildListData(
      id: map['id']?.toInt() ?? 0,
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      father_name: map['father_name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChildListData.fromJson(String source) =>
      ChildListData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChildListData(id: $id, uid: $uid, name: $name, father_name: $father_name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChildListData &&
        other.id == id &&
        other.uid == uid &&
        other.name == name &&
        other.father_name == father_name;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uid.hashCode ^ name.hashCode ^ father_name.hashCode;
  }
}
