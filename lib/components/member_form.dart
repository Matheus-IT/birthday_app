import 'package:birthday_app/models/member.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MemberForm extends StatefulWidget {
  const MemberForm({
    super.key,
    required this.member,
    required this.onSubmitMemberForm,
  });

  final Member member;
  final void Function(String name, String phoneNumber, String birthDate) onSubmitMemberForm;

  @override
  State<MemberForm> createState() => _MemberFormState();
}

class _MemberFormState extends State<MemberForm> {
  final dateFormat = DateFormat('dd/MM/yyyy');
  late TextEditingController nameController;
  late TextEditingController phoneNumberController;
  late TextEditingController birthDateController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.member.name);
    phoneNumberController = TextEditingController(text: widget.member.phoneNumber);
    birthDateController = TextEditingController(text: dateFormat.format(widget.member.birthDate));
  }

  @override
  Widget build(BuildContext context) {
    print('members form build');
    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
        right: 16,
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
            onPressed: () => widget.onSubmitMemberForm(
              nameController.text,
              phoneNumberController.text,
              birthDateController.text,
            ),
            child: const Text('Salvar'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
