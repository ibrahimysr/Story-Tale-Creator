class UserProfile {
  final String uid;
  final String name;
  final String username;
  final int stories;
  final String missions;
  final int level;

  UserProfile({
    required this.uid,
    required this.name,
    required this.username,
    required this.stories,
    required this.missions,
    required this.level,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      stories: map['stories'] ?? 0,
      missions: map['missions'] ?? '0/0',
      level: map['level'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'stories': stories,
      'missions': missions,
      'level': level,
    };
  }
} 