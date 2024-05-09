import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiUrls {
  static String base = dotenv.env['BASE_URL']!;
  static Uri login = Uri.parse('${base}login/');
  static Uri members = Uri.parse('${base}members/');
  static Uri birthdayMembers = Uri.parse('${base}get-birthdays-of-the-day/');

  static Uri member(String id) {
    return Uri.parse('${base}members/$id/');
  }
}
