import 'package:birthday_app/components/error_dialog.dart';
import 'package:birthday_app/components/member_form.dart';
import 'package:birthday_app/controllers/member_controller.dart';
import 'package:birthday_app/dtos/member_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class CreateMemberButton extends ConsumerStatefulWidget {
  const CreateMemberButton({
    super.key,
  });

  @override
  ConsumerState<CreateMemberButton> createState() => _CreateMemberButtonState();
}

class _CreateMemberButtonState extends ConsumerState<CreateMemberButton> {
  void handleCreateMember(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return MemberForm(
          formTitle: 'Cadastrar membro',
          onSubmitMemberForm: handleSubmitMemberCreate,
        );
      },
    );
  }

  void handleSubmitMemberCreate(String name, String phoneNumber, String birthDate) async {
    final m = MemberDTO(
      name: name,
      profilePicturePath: '',
      phoneNumber: phoneNumber,
      birthDate: DateFormat('dd/MM/yyyy').parse(birthDate),
    );

    try {
      final success = await MemberController.createMember(m, ref);

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pop();
      }
    } on ClientException catch (e) {
      if (e.message.contains('Connection refused')) {
        showErrorDialog(
          context,
          content: 'Não foi possível criar o membro. Talvez houve um problema com o servidor.',
        );
      } else {
        showErrorDialog(
          context,
          content: 'Não foi possível criar o membro.',
        );
      }
    } catch (e) {
      showErrorDialog(context, content: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => handleCreateMember(context),
      child: const Text('Cadastrar membro'),
    );
  }
}
