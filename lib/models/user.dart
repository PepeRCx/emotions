class User {
  final DateTime createdAt;
  final String email;
  final String linkedPartnerId;
  final String currentMood;

  User({
    required this.createdAt,
    required this.email,
    this.linkedPartnerId = '',
    this.currentMood = 'normal',
  });

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'email': email,
      'linkedPartnerId': linkedPartnerId,
      'currentMood': currentMood,
    };
  }
}
