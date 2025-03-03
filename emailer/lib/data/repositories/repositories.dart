import 'package:emailer/data/models.dart';

abstract class DataRepository {
  Future<List<Email>> getNextEmailToBeSent();
  Future<void> markEmailAsSent(Email email);
}

