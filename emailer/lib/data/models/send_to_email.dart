class Email {
  final int id;
  final String emailAddress;
  bool isSent;
  String? responseFromServer;

  Email({
    required this.id,
    required this.emailAddress,
    this.isSent = false,
    this.responseFromServer,
  });

  // Convert Email to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': emailAddress,
      'is_sent': isSent,
      'response_from_server': responseFromServer,
    };
  }

  // Create Email from Map
  factory Email.fromMap(Map<String, dynamic> map) {
    return Email(
      id: map['Id'] is int ? map['Id'] : int.parse(map['Id'].toString()),
      emailAddress: map['email'],
      isSent: map['is_sent'] ?? false,
      responseFromServer: map['response_from_server'],
    );
  }

  @override
  String toString() {
    return 'Email(id: $id, emailAddress: $emailAddress, isSent: $isSent, responseFromServer: $responseFromServer)';
  }
}
