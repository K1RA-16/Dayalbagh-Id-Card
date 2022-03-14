// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Search {
  final String branch;
  final String Name;
  Search({
    required this.branch,
    required this.Name,
  });

  Search copyWith({
    String? branch,
    String? Name,
  }) {
    return Search(
      branch: branch ?? this.branch,
      Name: Name ?? this.Name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'branch': branch,
      'Name': Name,
    };
  }

  factory Search.fromMap(Map<String, dynamic> map) {
    return Search(
      branch: map['branch'] as String,
      Name: map['Name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Search.fromJson(String source) =>
      Search.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Search(branch: $branch, Name: $Name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Search && other.branch == branch && other.Name == Name;
  }

  @override
  int get hashCode => branch.hashCode ^ Name.hashCode;
}
