import 'dart:convert';

import 'package:birthday_app/api_urls.dart';
import 'package:birthday_app/components/snackbar.dart';
import 'package:birthday_app/http_client.dart';
import 'package:birthday_app/models/member.dart';
import 'package:birthday_app/providers/members_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MembersScreen extends ConsumerStatefulWidget {
  const MembersScreen({super.key});

  @override
  ConsumerState<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends ConsumerState<MembersScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  Future fetchMembers() async {
    _isLoading = true;

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
    _isLoading = false;
    ref.read(membersProvider.notifier).setMembers(members);
  }

  Future handleLogout() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'auth_token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todos os membros',
          style: TextStyle(color: Colors.white),
        ),
        actions: [IconButton(color: Colors.black87, onPressed: handleLogout, icon: const Icon(Icons.exit_to_app))],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Consumer(builder: (ctx, ref, child) {
          final members = ref.watch(membersProvider);

          return _isLoading
              ? const CircularProgressIndicator()
              : ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      child: ListTile(
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        leading: CircleAvatar(
                          child: members[index].profilePicturePath.isNotEmpty
                              ? Image.network(members[index].profilePicturePath)
                              : const Icon(Icons.person),
                        ),
                        title: Text(members[index].name),
                        subtitle: Text('Data de nascimento ${members[index].birthDateReadable}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            showSnackbar(ctx, 'Ainda não está pronto...');
                          },
                        ),
                      ),
                    );
                  });
        }),
      ),
    );
  }
}
