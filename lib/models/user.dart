class User {
  final int id;
  final String name;
  final String password;

  User({required this.id, required this.name, required this.password});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'password': password};
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      password: json['password'] as String,
    );
  }
}
