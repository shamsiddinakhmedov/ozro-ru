class RegisterUserRequest {
  RegisterUserRequest({
    required this.email,
    required this.password,
    required this.fullName,
  });

  factory RegisterUserRequest.fromJson(Map<String, dynamic> json) => RegisterUserRequest(
        email: json['email'],
        password: json['password'],
        fullName: json['full_name'],
      );
  final String email;
  final String password;
  final String fullName;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'full_name': fullName,
      };
}
