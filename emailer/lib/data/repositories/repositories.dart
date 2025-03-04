import 'package:emailer/data/models/send_to_email.dart';

abstract class DataRepository {
  Future<List<Email>> getNextEmailToBeSent();
  Future<void> markEmailAsSent(Email email, String sendReport);
}

