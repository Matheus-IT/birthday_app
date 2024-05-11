import 'package:birthday_app/models/member.dart';
import 'package:birthday_app/providers/loading_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MemberForm extends ConsumerStatefulWidget {
  const MemberForm({
    super.key,
    this.member,
    required this.formTitle,
    required this.onSubmitMemberForm,
  });

  final Member? member;
  final Future<void> Function(String name, String phoneNumber, String birthDate) onSubmitMemberForm;
  final String formTitle;

  @override
  ConsumerState<MemberForm> createState() => _MemberFormState();
}

class _MemberFormState extends ConsumerState<MemberForm> {
  final dateFormat = DateFormat('dd/MM/yyyy');
  late String initialDate;
  late TextEditingController nameController;
  late TextEditingController phoneNumberController;
  late TextEditingController birthDateController;
  final _formKey = GlobalKey<FormState>();
  final phoneFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####', // Mask for mobile numbers
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.member != null ? widget.member!.name : '');
    phoneNumberController =
        TextEditingController(text: widget.member != null ? widget.member!.phoneNumberFormatted : '');

    initialDate = dateFormat.format(DateTime(2000, 2, 1));
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
    if (phoneNumber == null || phoneNumber.isEmpty) return null;
    phoneNumber = _removeNonNumeric(phoneNumber);

    if (phoneNumber.isNotEmpty && phoneNumber.length < 11) {
      return 'Números de telefone têm 11 caracteres';
    }

    if (phoneNumber.length > 11) {
      return 'Números de telefone não podem ter mais de 11 caracteres';
    }

    if (!isNumeric(phoneNumber)) {
      return 'Só são permitidos caracteres numéricos';
    }
    return null;
  }

  String _removeNonNumeric(String formattedNumber) {
    // Removes non numeric characters used for formatting (like parentheses, spaces, and dashes)
    return formattedNumber.replaceAll(RegExp(r'\D'), '');
  }

  bool isNumeric(String str) {
    final numericRegex = RegExp(r'^-?[0-9]+$');
    return numericRegex.hasMatch(str);
  }

  bool atLeastOneFieldWasChanged() {
    // when theres no member provided, it means that we are in create mode
    if (widget.member == null) return true;

    return (nameController.text != widget.member!.name ||
        _removeNonNumeric(phoneNumberController.text) != widget.member!.phoneNumber ||
        birthDateController.text != dateFormat.format(widget.member!.birthDate));
  }

  Future<void> handleClickSave() async {
    if (_formKey.currentState!.validate() && atLeastOneFieldWasChanged()) {
      ref.read(loadingStateProvider.notifier).setLoading(true);

      await widget.onSubmitMemberForm(
        nameController.text,
        _removeNonNumeric(phoneNumberController.text),
        birthDateController.text,
      );

      ref.read(loadingStateProvider.notifier).setLoading(false);
    } else if (!atLeastOneFieldWasChanged()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        right: 16,
        left: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
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
              inputFormatters: [phoneFormatter],
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
            Consumer(builder: (ctx, ref, child) {
              final isLoading = ref.watch(loadingStateProvider);
              return isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: handleClickSave,
                      child: const Text('Salvar'),
                    );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
