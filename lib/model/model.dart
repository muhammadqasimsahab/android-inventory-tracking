class UserModel {
  final String uId;
  final String username;
  final String email;
  final String password;
  final DateTime createdOn;

  UserModel({
    required this.uId,
    required this.username,
    required this.email,
    required this.password,
    required this.createdOn,
  });

  // Serialize the UserModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'username': username,
      'email': email,
      'password': password,
      'createdOn': createdOn,
    };
  }

  // Create a UserModel instance from a JSON map
  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      uId: json['uId'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      createdOn: DateTime.parse(json['createdOn']),
    );
  }
}
