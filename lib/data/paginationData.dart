import 'dart:convert';

class PaginaionData {
  final int branchid;
  final int offset;
  final int pageSize;
  PaginaionData({
    required this.branchid,
    required this.offset,
    required this.pageSize,
  });

  PaginaionData copyWith({
    int? branchid,
    int? offset,
    int? pageSize,
  }) {
    return PaginaionData(
      branchid: branchid ?? this.branchid,
      offset: offset ?? this.offset,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'branchid': branchid,
      'offset': offset,
      'pageSize': pageSize,
    };
  }

  factory PaginaionData.fromMap(Map<String, dynamic> map) {
    return PaginaionData(
      branchid: map['branchid']?.toInt() ?? 0,
      offset: map['offset']?.toInt() ?? 0,
      pageSize: map['pageSize']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaginaionData.fromJson(String source) =>
      PaginaionData.fromMap(json.decode(source));

  @override
  String toString() =>
      'PaginaionData(branchid: $branchid, offset: $offset, pageSize: $pageSize)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaginaionData &&
        other.branchid == branchid &&
        other.offset == offset &&
        other.pageSize == pageSize;
  }

  @override
  int get hashCode => branchid.hashCode ^ offset.hashCode ^ pageSize.hashCode;
}
