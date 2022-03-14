// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaginaionData {
  final String branch;
  final int Offset;
  final int PageSize;
  PaginaionData({
    required this.branch,
    required this.Offset,
    required this.PageSize,
  });

  PaginaionData copyWith({
    String? branch,
    int? Offset,
    int? PageSize,
  }) {
    return PaginaionData(
      branch: branch ?? this.branch,
      Offset: Offset ?? this.Offset,
      PageSize: PageSize ?? this.PageSize,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'branch': branch,
      'Offset': Offset,
      'PageSize': PageSize,
    };
  }

  factory PaginaionData.fromMap(Map<String, dynamic> map) {
    return PaginaionData(
      branch: map['branch'] as String,
      Offset: map['Offset'] as int,
      PageSize: map['PageSize'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaginaionData.fromJson(String source) =>
      PaginaionData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PaginaionData(branch: $branch, Offset: $Offset, PageSize: $PageSize)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaginaionData &&
        other.branch == branch &&
        other.Offset == Offset &&
        other.PageSize == PageSize;
  }

  @override
  int get hashCode => branch.hashCode ^ Offset.hashCode ^ PageSize.hashCode;
}
