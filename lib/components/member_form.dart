import 'package:birthday_app/models/member.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MemberForm extends StatefulWidget {
  const MemberForm({
    super.key,
    this.member,
    required this.formTitle,
    required this.onSubmitMemberForm,
  });

  final Member? member;
  final void Function(String name, String phoneNumber, String birthDate) onSubmitMemberForm;
  final String formTitle;

  @override
  State<MemberForm> createState() => _MemberFormState();
}

class _MemberFormState extends State<MemberForm> {
  final dateFormat = DateFormat('dd/MM/yyyy');
  late String initialDate;
  late TextEditingController nameController;
  late TextEditingController phoneNumberController;
  late TextEditingController birthDateController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.member != null ? widget.member!.name : '');
    phoneNumberController = TextEditingController(text: widget.member != null ? widget.member!.phoneNumber : '');

    initialDate = dateFormat.format(DateTime(2000, 1, 1));
    birthDateController =
        TextEditingController(text: widget.member != null ? dateFormat.format(widget.member!.birthDate) : initialDate);
  }

  String? nameValidator(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'O nome é obrigatório';
    }
    return null;
  }

  String? phoneNumberValidator(String? phoneNumber) {
    if (phoneNumber == null) return null;

    if (phoneNumber.isNotEmpty && phoneNumber.length < 11) {
      return 'Números de telefone têm 11 caracteres';
    }

    if (phoneNumber.length > 12) {
      return 'Números de telefone não podem ter mais de 11 caracteres';
    }

    if (!isNumeric(phoneNumber)) {
      return 'Só são permitidos caracteres numéricos';
    }
    return null;
  }

  bool isNumeric(String str) {
    final numericRegex = RegExp(r'^-?[0-9]+$');
    return numericRegex.hasMatch(str);
  }

  bool atLeastOneFieldWasChanged() {
    // when theres no member provided, it means that we are in create mode
    if (widget.member == null) return true;

    return (nameController.text != widget.member!.name ||
        phoneNumberController.text != widget.member!.phoneNumber ||
        birthDateController.text != dateFormat.format(widget.member!.birthDate));
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(style: Theme.of(context).textTheme.titleMedium, widget.formTitle),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
              controller: nameController,
              validator: nameValidator,
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Número de telefone',
              ),
              keyboardType: TextInputType.number,
              controller: phoneNumberController,
              validator: phoneNumberValidator,
            ),
            const SizedBox(height: 8),
            TextFormField(
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
                if (_formKey.currentState!.validate() && atLeastOneFieldWasChanged()) {
                  widget.onSubmitMemberForm(
                    nameController.text,
                    phoneNumberController.text,
                    birthDateController.text,
                  );
                } else if (!atLeastOneFieldWasChanged()) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Salvar'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
