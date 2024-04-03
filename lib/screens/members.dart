import 'dart:convert';
import 'package:birthday_app/api_urls.dart';
import 'package:birthday_app/components/error_dialog.dart';
import 'package:birthday_app/http_client.dart';
import 'package:birthday_app/models/member.dart';
import 'package:birthday_app/providers/members_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

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

    try {
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
    } on ClientException catch (e) {
      if (e.message.contains('Connection refused')) {
        showErrorDialog(
          context,
          content: 'Não foi possível trazer a lista de membros. Talvez houve um problema com o servidor.',
          action: fetchMembers,
        );
      } else if (e.message.contains('Connection failed')) {
        showErrorDialog(
          context,
          content: 'Não foi possível trazer a lista de membros. Você tem certeza de que está conectado à internet?',
          action: fetchMembers,
        );
      } else {
        showErrorDialog(
          context,
          content: 'Não foi possível trazer a lista de membros.',
          action: fetchMembers,
        );
      }
    }
  }

  Future handleLogout() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'auth_token');
  }

  Future handleEditMember() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nome',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Número de telefone',
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Data de nascimento',
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Handle the form submission
                    Navigator.pop(context);
                  },
                  child: Text('Salvar'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todos os membros',
          style: TextStyle(color: Colors.white),
        ),
        actions: [IconButton(color: Colors.white, onPressed: handleLogout, icon: const Icon(Icons.exit_to_app))],
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
                        subtitle: Text('Data de aniversário ${members[index].birthDateReadable}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: handleEditMember,
                        ),
                      ),
                    );
                  });
        }),
      ),
    );
  }
}
