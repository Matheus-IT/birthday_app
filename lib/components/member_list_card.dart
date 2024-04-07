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
            member: member,
            onSubmitMemberForm: handleSubmitMemberUpdate,
          );
        },
      );
    }

    return Card(
      child: ListTile(
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
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
