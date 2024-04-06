import 'dart:convert';

import 'package:birthday_app/api_urls.dart';
import 'package:birthday_app/http_client.dart';
import 'package:birthday_app/models/member.dart';
import 'package:birthday_app/providers/members_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class MemberController {
  static Future<bool> updateMemberInfo(Member m, WidgetRef ref) async {
    final response = await AuthenticatedHttpClient.put(ApiUrls.member(m.id), {
      'name': m.name,
      'profile_picture': null,
      'phone_number': m.phoneNumber,
      'birth_date': DateFormat('yyyy-MM-dd').format(m.birthDate),
    });

    if (response.statusCode == 200) {
      ref.read(membersProvider.notifier).updateMember(m);
      return true;
    }

    print('Code was not 200');
    return false;
  }
}
