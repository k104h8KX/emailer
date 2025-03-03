import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

/// A class to send emails with HTML content
class Emailer {
  final SmtpServer _smtpServer;
  final String _senderEmail;
  final String _senderName;

  /// Creates an Emailer instance with SMTP configuration
  ///
  /// - [smtpHost]: SMTP server hostname
  /// - [smtpPort]: SMTP server port (usually 465 for SSL, 587 for TLS)
  /// - [username]: Email account username
  /// - [password]: Email account password
  /// - [senderEmail]: Email address of the sender
  /// - [senderName]: Name to display for the sender
  /// - [secure]: Whether to use SSL (true) or TLS (false)
  Emailer({
    required String smtpHost,
    required int smtpPort,
    required String username,
    required String password,
    required String senderEmail,
    required String senderName,
    bool secure = true,
  })  : _smtpServer = secure
            ? SmtpServer(
                smtpHost,
                port: smtpPort,
                username: username,
                password: password,
                ssl: true,
              )
            : SmtpServer(
                smtpHost,
                port: smtpPort,
                username: username,
                password: password,
                allowInsecure: true,
              ),
        _senderEmail = senderEmail,
        _senderName = senderName;

  /// Send an email with HTML content
  ///
  /// - [recipients]: List of email addresses to send to
  /// - [subject]: Email subject
  /// - [htmlContent]: HTML content of the email
  /// - [attachments]: Optional list of file attachments
  /// - [ccRecipients]: Optional list of CC recipients
  /// - [bccRecipients]: Optional list of BCC recipients
  Future<void> sendEmail({
    required List<String> recipients,
    required String subject,
    required String htmlContent,
    List<FileAttachment>? attachments,
    List<String>? ccRecipients,
    List<String>? bccRecipients,
  }) async {
    // Create the email message
    final message = Message()
      ..from = Address(_senderEmail, _senderName)
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
      final sendReport = await send(message, _smtpServer);
      print('Email sent successfully: ${sendReport.toString()}');
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
