class SignupPostData {
  late String email;
  late String name;
  late String password;
  late String confirmPassword;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      'email': email,
      'name': name,
      'password': password,
      'password_confirmation': confirmPassword,
    };

    return data;
  }
}
