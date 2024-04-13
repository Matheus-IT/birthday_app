import 'dart:convert';
import 'package:birthday_app/api_urls.dart';
import 'package:birthday_app/components/create_member_button.dart';
import 'package:birthday_app/components/error_dialog.dart';
import 'package:birthday_app/components/info_dialog.dart';
import 'package:birthday_app/components/member_form.dart';
import 'package:birthday_app/components/member_list_card.dart';
import 'package:birthday_app/controllers/member_controller.dart';
import 'package:birthday_app/dtos/member_dto.dart';
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

  Future<void> handleDeleteMember(Member member) async {
    final result = await MemberController.deleteMember(member.id, ref);

    if (result) {
      showInfoDialog(
        context,
        title: 'Sucesso',
        content: 'Membro ${member.name.toUpperCase()} foi removido com sucesso',
      );
      return;
    }

    showErrorDialog(context, content: 'Não foi possível excluir o membro ${member.name.toUpperCase()}');
  }

  Future<void> handleLogout() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'auth_token');
  }

  void handleEditMember(Member member) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return MemberForm(
          formTitle: 'Editar membro',
          member: member,
          onSubmitMemberForm: (name, phone, birthDate) => handleSubmitMemberUpdate(
            MemberDTO(
              id: member.id,
              name: name,
              profilePicturePath: '',
              phoneNumber: phone,
              birthDate: DateFormat('dd/MM/yyyy').parse(birthDate),
            ),
          ),
        );
      },
    );
  }

  Future<void> handleSubmitMemberUpdate(MemberDTO memberDTO) async {
    try {
      final success = await MemberController.updateMemberInfo(memberDTO, ref);
      if (success) {
        Navigator.of(context).pop();
      }
    } on ClientException catch (e) {
      if (e.message.contains('Connection refused')) {
        showErrorDialog(
          context,
          content: 'Não foi possível atualizar membro. Talvez houve um problema com o servidor.',
        );
      } else {
        showErrorDialog(
          context,
          content: 'Não foi possível atualizar membro.',
        );
      }
    }
  }

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
                    const CreateMemberButton(),
                    Expanded(
                      child: members.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Text('Nenhum membro cadastrado, clique no botão acima para incluir um membro'),
                              ),
                            )
                          : ListView.builder(
                              itemCount: members.length,
                              itemBuilder: (ctx, index) {
                                return MemberListCard(
                                  member: members[index],
                                  onDeleteMember: handleDeleteMember,
                                  onEditMember: handleEditMember,
                                );
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
