class Member {
  final String name;
  final String profilePicturePath;
  final String phoneNumber;
  final String birthDate;

  Member({
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
