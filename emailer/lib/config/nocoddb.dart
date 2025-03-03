import '../helpers/environment_helper.dart';

class Nocoddb {
  static String get key => Env.get('NOCO_DB_API_KEY')!;
}
