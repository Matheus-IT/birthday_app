import 'dart:convert';

import 'package:birthday_app/api_urls.dart';
import 'package:birthday_app/http_client.dart';
import 'package:flutter/material.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  void fetchMembers() async {
    final response = await AuthenticatedHttpClient.get(ApiUrls.members);
    print('Response: ${jsonDecode(response.body)}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('members'),
      ),
    );
  }
}
