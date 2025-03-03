import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:emailer/config/nocoddb.dart';
import 'package:emailer/data/models.dart';

class NocoDbApi {
  final String baseUrl = 'https://app.nocodb.com/api/v2';
  final http.Client client;

  NocoDbApi({http.Client? client}) : this.client = client ?? http.Client();

  Future<List<dynamic>> fetchUnsentEmails({int limit = 1}) async {
    final Uri uri = Uri.parse('$baseUrl/tables/mm1rbik1annq3gc/records')
        .replace(queryParameters: {
      'where': 'where(is_sent,eq,false)',
      'limit': limit.toString(),
      'shuffle': '0',
      'offset': '0',
    });

    final response = await client.get(
      uri,
      headers: {
        'accept': 'application/json',
        'xc-token': Nocoddb.key,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['list'] ?? [];
    } else {
      throw Exception(
          'Failed to fetch emails: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> markEmailAsSent(Email email) async {
    final Uri uri = Uri.parse('$baseUrl/tables/mm1rbik1annq3gc/records');

    final Map<String, dynamic> requestBody = {
      'Id': email.id,
      'is_sent': true,
      'response_from_server': email.responseFromServer,
    };

    final response = await client.patch(
      uri,
      headers: {
        'accept': 'application/json',
        'xc-token': Nocoddb.key,
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to mark email as sent: ${response.statusCode} ${response.body}');
    }
  }
}
