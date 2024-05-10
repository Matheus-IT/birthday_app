import 'package:birthday_app/models/member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemberListCard extends ConsumerWidget {
  const MemberListCard({
    super.key,
    required this.member,
    required this.onDeleteMember,
    required this.onEditMember,
  });

  final Member member;
  final Future<void> Function(Member member) onDeleteMember;
  final void Function(Member member) onEditMember;

  void handleShowExtraInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.only(top: 32, right: 32, left: 32, bottom: 16),
          title: const Text('Mais informações'),
          children: [
            Text('Nome: ${member.name}'),
            Text('Data de nascimento: ${member.birthDateReadableFull}'),
            Text('Telefone: ${member.phoneNumberFormatted}'),
            const SizedBox(height: 16),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Deletar membro'),
              onPressed: () {
                onDeleteMember(member);
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

  bool _isMemberBirthday(Member member) {
    final now = DateTime.now();
    return member.birthDate.day == now.day && member.birthDate.month == now.month;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: _isMemberBirthday(member) ? Colors.purple[100] : null,
      child: ListTile(
        onTap: () => handleShowExtraInfoDialog(context),
        leading: CircleAvatar(
          child: member.profilePicturePath.isNotEmpty
              ? Image.network(member.profilePicturePath)
              : Icon(_isMemberBirthday(member) ? Icons.cake : Icons.person),
        ),
        title: Text(member.name),
        subtitle: Text(_isMemberBirthday(member) ? 'É hoje!' : 'Data de aniversário ${member.birthDateReadable}'),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            onEditMember(member);
          },
        ),
      ),
    );
  }
}
