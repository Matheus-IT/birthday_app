import 'dart:convert';

import 'package:birthday_app/api_urls.dart';
import 'package:birthday_app/http_client.dart';
import 'package:birthday_app/models/member.dart';
import 'package:birthday_app/providers/members_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MembersScreen extends ConsumerStatefulWidget {
  const MembersScreen({super.key});

  @override
  ConsumerState<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends ConsumerState<MembersScreen> {
  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  void fetchMembers() async {
    final response = await AuthenticatedHttpClient.get(ApiUrls.members);
    final members = List.from(jsonDecode(response.body))
        .map((el) => Member(
              name: el['name'],
              profilePicturePath: '',
              phoneNumber: el['phone_number'],
              birthDate: el['birth_date'],
            ))
        .toList();
    // initialize members provider
    ref.read(membersProvider.notifier).setMembers(members);
  }

  @override
  Widget build(BuildContext context) {
    print('build members screen');

    final members = ref.watch(membersProvider);

    return Scaffold(
      body: Center(
        child: ListView(
          children: members
              .map((m) => ListTile(
                    title: Text(m.name),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
