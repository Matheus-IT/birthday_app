import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiUrls {
  static String base = dotenv.env['BASE_URL']!;
  static Uri login = Uri.parse('${base}login/');
}
