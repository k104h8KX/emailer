import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:emailer/data/models/send_from_email.dart';
import 'package:emailer/helpers/email_getter.dart';

/// A class to send emails with HTML content
class Emailer {
  final String _smtpHost;
  final int _smtpPort;
  final bool _secure;

  /// Creates an Emailer instance with SMTP configuration
  ///
  /// - [smtpHost]: SMTP server hostname
  /// - [smtpPort]: SMTP server port (usually 465 for SSL, 587 for TLS)
  /// - [username]: Optional email account username (if not provided, will use random email)
  /// - [password]: Optional email account password (if not provided, will use random email)
  /// - [senderEmail]: Optional email address of sender (if not provided, will use random email)
  /// - [senderName]: Optional name to display for sender (if not provided, will use random email)
  /// - [secure]: Whether to use SSL (true) or TLS (false)
  Emailer({
    required String smtpHost,
    required int smtpPort,
    String? username,
    String? password,
    String? senderEmail,
    String? senderName,
    bool secure = true,
  })  : _smtpHost = smtpHost,
        _smtpPort = smtpPort,
        _secure = secure;

  /// Send an email with HTML content
  ///
  /// - [recipients]: List of email addresses to send to
  /// - [subject]: Email subject
  /// - [htmlContent]: HTML content of the email
  /// - [attachments]: Optional list of file attachments
  /// - [ccRecipients]: Optional list of CC recipients
  /// - [bccRecipients]: Optional list of BCC recipients
  /// - [fromEmail]: Optional specific email to send from (instead of random)
  ///
  /// Returns a string containing the send report and the email username
  Future<String> sendEmail({
    required List<String> recipients,
    required String subject,
    required String htmlContent,
    List<FileAttachment>? attachments,
    List<String>? ccRecipients,
    List<String>? bccRecipients,
    SendFromEmail? fromEmail,
  }) async {
    // Use provided email or get a random one
    final email = fromEmail ?? getRandomEmail();

    // Create SMTP server with selected credentials
    final smtpServer = _secure
        ? SmtpServer(
            _smtpHost,
            port: _smtpPort,
            username: email.username,
            password: email.password,
            ssl: true,
          )
        : SmtpServer(
            _smtpHost,
            port: _smtpPort,
            username: email.username,
            password: email.password,
            allowInsecure: true,
          );

    // Create the email message
    final message = Message()
      ..from = Address(email.username, email.senderName)
      ..recipients.addAll(recipients.map((e) => Address(e)))
      ..ccRecipients.addAll(ccRecipients?.map((e) => Address(e)) ?? [])
      ..bccRecipients.addAll(bccRecipients?.map((e) => Address(e)) ?? [])
      ..subject = subject
      ..html = htmlContent;

    // Add attachments if any
    if (attachments != null && attachments.isNotEmpty) {
      for (var attachment in attachments) {
        message.attachments.add(attachment);
      }
    }

    // Send the email
    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent using ${email.senderName} (${email.username})');
      return '${sendReport.toString()} | ${email.username}';
    } catch (e) {
      print('Error sending email: $e');
      rethrow;
    }
  }

  /// Create a file attachment from a file path
  static FileAttachment attachFile(String filePath, {String? filename}) {
    final file = File(filePath);
    return FileAttachment(
      file,
      contentType: 'application/octet-stream',
      fileName: filename ?? file.path.split('/').last,
    );
  }
}
