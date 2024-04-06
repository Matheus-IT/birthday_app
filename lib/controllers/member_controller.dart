import 'dart:convert';

import 'package:birthday_app/api_urls.dart';
import 'package:birthday_app/http_client.dart';
import 'package:birthday_app/models/member.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class MemberController {
  static Future<bool> updateMemberInfo(Member m) async {
    try {
      final response = await AuthenticatedHttpClient.put(ApiUrls.member(m.id), {
        'name': m.name,
        'profile_picture': null,
        'phone_number': m.phoneNumber,
        'birth_date': DateFormat('yyyy-MM-dd').format(m.birthDate),
      });
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
      } else {
        print('Code was not 200');
      }
      return true;
    } on ClientException catch (e) {
      if (e.message.contains('Connection refused')) {
        print('Não foi possível atualizar membro. Talvez houve um problema com o servidor.');
      } else {
        print('Não foi possível atualizar membro.');
      }
      return false;
    }
  }
}
