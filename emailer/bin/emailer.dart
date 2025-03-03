import 'dart:io';
import 'dart:math';

import 'package:emailer/config/config.dart';
import 'package:emailer/config/email_config.dart';
import 'package:emailer/data/models.dart';
import 'package:emailer/data/repositories/email_repository_impl.dart';
import 'package:emailer/email_templates/html_email_templates.dart';
import 'package:emailer/emailer/emailer/emailer.dart';
import 'package:emailer/helpers/environment_helper.dart';

Future<void> main(List<String> arguments) async {
  // Initialize environment
  Env.initialize();

  Emailer emailer = Emailer(
    smtpHost: EmailConfig.smtpServerName,
    smtpPort: EmailConfig.smtpPort,
    username: EmailConfig.username,
    password: EmailConfig.password,
    senderEmail: EmailConfig.username,
    senderName: EmailConfig.senderName,
  );

  final emailRepository = EmailRepositoryImpl();

  // Process emails one by one
  do {
    // Get the next email
    List<Email> emails = await emailRepository.getNextEmailToBeSent();

    if (emails.isEmpty) {
      print('No more emails to send');
      break;
    }

    final currentEmail = emails[0];
    print('Sending email to: ${currentEmail.emailAddress}...');

    try {
      // Send email
      await emailer.sendEmail(
        recipients: [currentEmail.emailAddress],
        subject: 'Do you know the cost of smoking for your workplace?',
        htmlContent: HtmlEmailTemplates.testEmail,
      );

      print('Email sent successfully.');

      // Mark as sent in database
      await emailRepository.markEmailAsSent(currentEmail);
      print('Email marked as sent in database.');

      // Add delay before fetching the next email
      final random = Random();
      final int min = Config.waitTimeLowerBound;
      final int max = Config.waitTimeUpperBound;
      final randomNumber = min + random.nextInt(max - min + 1);

      print('Waiting for $randomNumber minutes before sending next email...');
      await Future.delayed(Duration(minutes: randomNumber));
    } catch (e) {
      print('Error processing email: $e');
      // Wait a bit before trying the next email
      await Future.delayed(Duration(seconds: 30));
    }
  } while (true); // Continue indefinitely until no more emails

  print('All emails processed successfully.');
  exit(0);
}
