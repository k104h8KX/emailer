import 'package:emailer/data/datasources.dart';
import 'package:emailer/data/repositories/repositories.dart';
import 'package:emailer/data/models/send_to_email.dart';

class EmailRepositoryImpl implements DataRepository {
  final NocoDbApi api;

  EmailRepositoryImpl({NocoDbApi? api}) : this.api = api ?? NocoDbApi();

  @override
  Future<List<Email>> getNextEmailToBeSent() async {
    final List<dynamic> rawEmails = await api.fetchUnsentEmails();

    return rawEmails.map((rawEmail) => Email.fromMap(rawEmail)).toList();
  }

  @override
  Future<void> markEmailAsSent(Email email, String sendReport) async {
    // Update the email locally
    email.isSent = true;
    email.responseFromServer = sendReport;

    // Update the email in the database
    await api.markEmailAsSent(email);
  }
}
