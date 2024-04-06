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
import 'package:intl/intl.dart';

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
      if (!mounted) return;

      final members = List.from(jsonDecode(response.body))
          .map((el) => Member(
                name: el['name'],
                profilePicturePath: '',
                phoneNumber: el['phone_number'],
                birthDate: DateTime.parse(el['birth_date']),
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

  Future handleEditMember(Member member) async {
    final nameController = TextEditingController(text: member.name);
    final phoneNumberController = TextEditingController(text: member.phoneNumber);
    final dateFormat = DateFormat('dd/MM/yyyy');
    final birthDateController = TextEditingController(text: dateFormat.format(member.birthDate));

    void handleSubmitMemberForm() {
      // Perform submit
    }

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) {
          print('member form builder');
          return Padding(
            padding: EdgeInsets.only(
              top: 16,
              right: 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                  ),
                  controller: nameController,
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Número de telefone',
                  ),
                  controller: phoneNumberController,
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Data de nascimento',
                  ),
                  readOnly: true,
                  controller: birthDateController,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: dateFormat.parse(birthDateController.text),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        birthDateController.text = dateFormat.format(selectedDate);
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    handleSubmitMemberForm();
                    Navigator.pop(context);
                  },
                  child: const Text('Salvar'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    print('members page build');
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
                          onPressed: () => handleEditMember(members[index]),
                        ),
                      ),
                    );
                  });
        }),
      ),
    );
  }
}
