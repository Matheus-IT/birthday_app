import 'package:birthday_app/components/error_dialog.dart';
import 'package:birthday_app/components/member_form.dart';
import 'package:birthday_app/controllers/member_controller.dart';
import 'package:birthday_app/models/member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class MemberListCard extends ConsumerWidget {
  const MemberListCard({
    super.key,
    required this.member,
  });

  final Member member;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('members list card build');

    void handleSubmitMemberUpdate(String name, String phone, String birthDate) async {
      final m = Member(
        id: member.id,
        name: name,
        profilePicturePath: '',
        phoneNumber: phone,
        birthDate: DateFormat('dd/MM/yyyy').parse(birthDate),
      );

      try {
        final success = await MemberController.updateMemberInfo(m, ref);
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

    void handleEditMember(Member member) {
      showBottomSheet(
        context: context,
        builder: (ctx) {
          return MemberForm(
            formTitle: 'Editar membro',
            member: member,
            onSubmitMemberForm: handleSubmitMemberUpdate,
          );
        },
      );
    }

    void handleShowExtraInfoDialog() {
      showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.only(top: 32, right: 32, left: 32, bottom: 16),
            title: const Text('Mais informações'),
            children: [
              Text('Nome: ${member.name}'),
              Text('Data de nascimento: ${member.birthDateReadableFull}'),
              Text('Telefone: ${member.phoneNumber}'),
              const SizedBox(height: 16),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Deletar membro'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Fechar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Card(
      child: ListTile(
        onTap: handleShowExtraInfoDialog,
        leading: CircleAvatar(
          child: member.profilePicturePath.isNotEmpty
              ? Image.network(member.profilePicturePath)
              : const Icon(Icons.person),
        ),
        title: Text(member.name),
        subtitle: Text('Data de aniversário ${member.birthDateReadable}'),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            handleEditMember(member);
          },
        ),
      ),
    );
  }
}
