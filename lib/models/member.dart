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

  String get birthDateReadableFull {
    return DateFormat('dd/MM/yyyy').format(birthDate);
  }

  String get phoneNumberFormatted {
    // Assuming phone numbers are in the format '86995610997'
    // You can adjust this format according to your requirements
    if (phoneNumber.isEmpty) return '';
    String areaCode = phoneNumber.substring(0, 2); // Assuming the country code is the first two digits
    String localNumber1 = phoneNumber.substring(2, 7); // Assuming the local number is the rest of the digits
    String localNumber2 = phoneNumber.substring(7); // Assuming the local number is the rest of the digits

    return '($areaCode) $localNumber1-$localNumber2';
  }

  @override
  String toString() {
    return name;
  }
}
