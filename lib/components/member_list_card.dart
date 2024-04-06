import 'package:birthday_app/components/member_form.dart';
import 'package:birthday_app/models/member.dart';
import 'package:flutter/material.dart';

class MemberListCard extends StatelessWidget {
  const MemberListCard({
    super.key,
    required this.member,
  });

  final Member member;

  @override
  Widget build(BuildContext context) {
    void handleEditMember(Member member) {
      print('handleEditMember');

      showBottomSheet(
        context: context,
        // isScrollControlled: true,
        builder: (ctx) {
          print('showModalBottomSheet builder');
          return MemberForm(
              member: member,
              onSubmitMemberForm: (name, phone, birthDate) {
                // "name": "test2",
                // "profile_picture": null,
                // "phone_number": "86995453618",
                // "birth_date": "2001-12-08"
              });
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
