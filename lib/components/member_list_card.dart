import 'package:birthday_app/components/member_form.dart';
import 'package:birthday_app/controllers/member_controller.dart';
import 'package:birthday_app/models/member.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MemberListCard extends StatelessWidget {
  const MemberListCard({
    super.key,
    required this.member,
  });

  final Member member;

  @override
  Widget build(BuildContext context) {
    void handleEditMember(Member member) {
      showBottomSheet(
        context: context,
        // isScrollControlled: true,
        builder: (ctx) {
          return MemberForm(
            member: member,
            onSubmitMemberForm: (name, phone, birthDate) async {
              final m = Member(
                id: member.id,
                name: name,
                profilePicturePath: '',
                phoneNumber: phone,
                birthDate: DateFormat('dd/MM/yyyy').parse(birthDate),
              );

              final success = await MemberController.updateMemberInfo(m);

              if (success) {
                Navigator.of(context).pop();
              }
            },
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
