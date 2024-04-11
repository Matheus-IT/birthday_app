import 'dart:convert';

import 'package:birthday_app/api_urls.dart';
import 'package:birthday_app/dtos/member_dto.dart';
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
    return false;
  }

  static Future<bool> createMember(MemberDTO m, WidgetRef ref) async {
    final response = await AuthenticatedHttpClient.post(ApiUrls.members, {
      'name': m.name,
      'profile_picture': null,
      'phone_number': m.phoneNumber,
      'birth_date': DateFormat('yyyy-MM-dd').format(m.birthDate),
    });

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      final member = Member(
        id: responseData['id'].toString(),
        name: responseData['name'],
        profilePicturePath: '',
        phoneNumber: responseData['phone_number'],
        birthDate: DateTime.parse(responseData['birth_date']),
      );
      ref.read(membersProvider.notifier).addMember(member);
      return true;
    }
    return false;
  }

  static Future<bool> deleteMember(String memberId, WidgetRef ref) async {
    final response = await AuthenticatedHttpClient.delete(ApiUrls.member(memberId));

    if (response.statusCode == 204) {
      ref.read(membersProvider.notifier).removeMember(memberId);
      return true;
    }
    return false;
  }
}
