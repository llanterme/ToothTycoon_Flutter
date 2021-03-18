class SignupPostData {
  String email;
  String name;
  String password;
  String confirmPassword;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      'email': this.email,
      'name': this.name,
      'password': this.password,
      'password_confirmation': this.confirmPassword,
    };

    return data;
  }
}
