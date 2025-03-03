import 'dart:io';
import 'dart:math';

import 'package:emailer/config/config.dart';
import 'package:emailer/config/email_config.dart';
import 'package:emailer/data/models.dart';
import 'package:emailer/data/repositories/email_repository_impl.dart';
import 'package:emailer/email_templates/html_email_templates.dart';
import 'package:emailer/emailer.dart';

Future<void> main(List<String> arguments) async {
  Emailer emailer = Emailer(
    smtpHost: EmailConfig.smtpServerName,
    smtpPort: EmailConfig.smtpPort,
    username: EmailConfig.username,
    password: EmailConfig.password,
    senderEmail: EmailConfig.username,
    senderName: EmailConfig.senderName,
  );

  final emailRepository = EmailRepositoryImpl();
  List<Email> emails = await emailRepository.getNextEmailToBeSent();

  print('this is the email list');
  print(emails.toString());

  if (emails.isEmpty) {
    print('No emails to send');
    exit(0);
  }

  await Future.delayed(Duration(seconds: 24));

  await emailRepository.markEmailAsSent(emails[0]);

  print('email marked as sent');

  exit(0);

//   print('Sending email...');

//   await emailer.sendEmail(
//     recipients: ['tom.avila@outlook.com'],
//     subject: 'Do you know the cost of smoking for your workplace?',
//     htmlContent: HtmlEmailTemplates.testEmail,
//   );

//   print('Sending email...');

//   //generate a random number between 1 and 100
//   final random = Random();
//   final int min = Config.waitTimeLowerBound; // Lower bound (inclusive)
//   final int max = Config.waitTimeUpperBound; // Upper bound (inclusive)
//   final randomNumber = min + random.nextInt(max - min + 1);

//   print('Email sent...');
//   print('Waiting for $randomNumber minutes...');

//   //wait for a random amount of time
//   await Future.delayed(Duration(minutes: randomNumber));

//   await emailer.sendEmail(
//     recipients: ['tom.avila@outlook.com'],
//     subject: 'Do you know the cost of smoking for your workplace?',
//     htmlContent: HtmlEmailTemplates.howMuchSpentOnSmoking,
//   );
}
