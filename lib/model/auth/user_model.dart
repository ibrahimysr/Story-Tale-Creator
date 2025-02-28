class UserModel {
  final String id;
  final String username;
  final String email;
  final String avatar;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.avatar,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatar': avatar,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      avatar: map['avatar'] ?? 'boy (1).png',
    );
  }
}