import 'dart:convert';
import 'package:birthday_app/api_urls.dart';
import 'package:birthday_app/components/error_dialog.dart';
import 'package:birthday_app/components/member_form.dart';
import 'package:birthday_app/components/member_list_card.dart';
import 'package:birthday_app/components/snackbar.dart';
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

  Future<void> fetchMembers() async {
    _isLoading = true;

    try {
      final response = await AuthenticatedHttpClient.get(ApiUrls.members);
      if (!mounted) return;

      final members = List.from(jsonDecode(response.body))
          .map((el) => Member(
                id: el['id'].toString(),
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

  Future<void> handleLogout() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'auth_token');
  }

  void handleCreateMember() {
    // showBottomSheet(
    //   context: context,
    //   builder: (ctx) {
    //     return MemberForm(
    //       onSubmitMemberForm: handleSubmitMemberCreate,
    //     );
    //   },
    // );
    showSnackbar(context, 'Ainda não está pronto');
  }

  void handleSubmitMemberCreate(String name, String phoneNumber, String birthDate) {}

  @override
  Widget build(BuildContext context) {
    print('members screen build');
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
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: () {}, child: const Text('Cadastrar membro')),
                    Expanded(
                      child: ListView.builder(
                        itemCount: members.length,
                        itemBuilder: (ctx, index) {
                          return MemberListCard(member: members[index]);
                        },
                      ),
                    ),
                  ],
                );
        }),
      ),
    );
  }
}
