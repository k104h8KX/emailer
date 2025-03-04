class SendFromEmail {
  final String username;
  final String senderName;
  final String password;

  SendFromEmail({
    required this.username,
    required this.senderName,
    required this.password,
  });

  // Create an instance from a map (for parsing from JSON)
  factory SendFromEmail.fromMap(Map<String, dynamic> map) {
    return SendFromEmail(
      username: map['username'] ?? '',
      senderName: map['senderName'] ?? '',
      password: map['password'] ?? '',
    );
  }

  // Convert instance to a map (for serialization to JSON)
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'senderName': senderName,
      'password': password,
    };
  }

  // Create a copy with potentially modified fields
  SendFromEmail copyWith({
    String? username,
    String? senderName,
    String? password,
  }) {
    return SendFromEmail(
      username: username ?? this.username,
      senderName: senderName ?? this.senderName,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'SendFromEmail(username: $username, senderName: $senderName, password: ***)';
  }
}
