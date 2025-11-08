class RegisterUser {
  final String email;
  final String fullName;
  final String phoneNumber;
  final bool isPlayer;
  final bool isCoach;
  final String password;
  final String password2;

  RegisterUser({
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.isPlayer,
    required this.isCoach,
    required this.password,
    required this.password2,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'is_player': isPlayer,
      'is_coach': isCoach,
      'password': password,
      'password2': password2,
    };
  }

  factory RegisterUser.fromJson(Map<String, dynamic> json) {
    return RegisterUser(
      email: json['email'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      isPlayer: json['is_player'],
      isCoach: json['is_coach'],
      password: json['password'],
      password2: json['password2'],
    );
  }
}
