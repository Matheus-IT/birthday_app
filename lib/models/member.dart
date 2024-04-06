import 'package:intl/intl.dart';

class Member {
  final String id;
  final String name;
  final String profilePicturePath;
  final String phoneNumber;
  final DateTime birthDate;

  Member({
    required this.id,
    required this.name,
    required this.profilePicturePath,
    required this.phoneNumber,
    required this.birthDate,
  });

  String get birthDateReadable {
    return DateFormat('dd/MM').format(birthDate);
  }

  @override
  String toString() {
    return name;
  }
}
