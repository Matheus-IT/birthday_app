class MemberDTO {
  final String? id;
  final String name;
  final String profilePicturePath;
  final String phoneNumber;
  final DateTime birthDate;

  MemberDTO({
    this.id,
    required this.name,
    required this.profilePicturePath,
    required this.phoneNumber,
    required this.birthDate,
  });

  @override
  String toString() {
    return name;
  }
}
