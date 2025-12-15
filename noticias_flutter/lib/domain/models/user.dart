class User {
  final String token;
  final String firstName;
  final String lastName;
  final String email;

  const User({
    required this.token,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  User copyWith({
    String? token,
    String? firstName,
    String? lastName,
    String? email,
  }) {
    return User(
      token: token ?? this.token,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
    );
  }
}
