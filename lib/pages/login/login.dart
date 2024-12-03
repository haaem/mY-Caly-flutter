class Login {
  final String id;
  final String password;
  final String token;

  Login(this.id, this.password, this.token);

  Login.fromJson(Map<String, dynamic> json)
      : id = json['accountName'],
        password = json['password'],
        token = json['token'];

  Map<String, dynamic> toJson() => {
    'accountName': id,
    'password': password,
    'user_id': token,
  };
}