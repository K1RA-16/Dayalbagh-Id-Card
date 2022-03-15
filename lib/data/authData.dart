// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AuthData {
  final String username;
  final String password;
  final String version;
  AuthData({
    required this.username,
    required this.password,
    required this.version,
  });

  AuthData copyWith({
    String? username,
    String? password,
    String? version,
  }) {
    return AuthData(
      username: username ?? this.username,
      password: password ?? this.password,
      version: version ?? this.version,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'password': password,
      'version': version,
    };
  }

  factory AuthData.fromMap(Map<String, dynamic> map) {
    return AuthData(
      username: map['username'] as String,
      password: map['password'] as String,
      version: map['version'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthData.fromJson(String source) =>
      AuthData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AuthData(username: $username, password: $password, version: $version)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthData &&
        other.username == username &&
        other.password == password &&
        other.version == version;
  }

  @override
  int get hashCode => username.hashCode ^ password.hashCode ^ version.hashCode;
}
