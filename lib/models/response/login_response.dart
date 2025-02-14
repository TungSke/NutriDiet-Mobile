class LoginResponse {
  final String email;
  final String password;

  LoginResponse(this.email, this.password);

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(json['email'], json['password']);
  }
}
