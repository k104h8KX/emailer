import 'dart:math';

import 'package:emailer/config/email_config.dart';
import 'package:emailer/data/models/send_from_email.dart';

SendFromEmail getRandomEmail() {
  final random = Random();
  final emailNumber = random.nextInt(3) + 1;

  print('Using email number $emailNumber');

  switch (emailNumber) {
    case 1:
      return SendFromEmail(
        username: EmailConfig.username,
        senderName: EmailConfig.senderName,
        password: EmailConfig.password,
      );
    case 2:
      return SendFromEmail(
        username: EmailConfig.username2,
        senderName: EmailConfig.senderName2,
        password: EmailConfig.password2,
      );
    case 3:
      return SendFromEmail(
        username: EmailConfig.username3,
        senderName: EmailConfig.senderName3,
        password: EmailConfig.password3,
      );
    default:
      return SendFromEmail(
        username: EmailConfig.username,
        senderName: EmailConfig.senderName,
        password: EmailConfig.password,
      );
  }
}
