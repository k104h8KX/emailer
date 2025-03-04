import '../helpers/environment_helper.dart';

class EmailConfig {
  // Account information
  static const String username = 'petra@cravelessme.site';
  static const String senderName = 'Petra';
  static String get password => Env.get('PETRA_EMAIL_PASSWORD')!;

  static const String username2 = 'hello@craveless.site';
  static const String senderName2 = 'Petter';
  static String get password2 => Env.get('PETTER_EMAIL_PASSWORD')!;

  static const String username3 = 'hi@craveless.site';
  static const String senderName3 = 'Peyton';
  static String get password3 => Env.get('PEYTON_EMAIL_PASSWORD')!;

  // IMAP configuration
  static const String imapServerName = 'mail.spacemail.com';
  static const int imapPort = 993; // Default IMAP SSL port
  static const String imapSecurity = 'SSL';

  // SMTP configuration
  static const String smtpServerName = 'mail.spacemail.com';
  static const int smtpPort = 465;
  static const String smtpSecurity = 'SSL';

  // POP3 configuration
  static const String pop3ServerName = 'mail.spacemail.com';
  static const int pop3Port = 995; // Default POP3 SSL port
  static const String pop3Security = 'SSL';
}
