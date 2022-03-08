import 'dart:convert';

class AuthData {
  final String username;
  final String password;
  AuthData({
    required this.username,
    required this.password,
  });

  AuthData copyWith({
    String? username,
    String? password,
  }) {
    return AuthData(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }

  factory AuthData.fromMap(Map<String, dynamic> map) {
    return AuthData(
      username: map['username'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthData.fromJson(String source) => AuthData.fromMap(json.decode(source));

  @override
  String toString() => 'AuthData(username: $username, password: $password)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AuthData &&
      other.username == username &&
      other.password == password;
  }

  @override
  int get hashCode => username.hashCode ^ password.hashCode;
}
