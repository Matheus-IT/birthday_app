import 'package:birthday_app/models/member.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MembersStateNotifier extends StateNotifier<List<Member>> {
  MembersStateNotifier() : super([]);

  void setMembers(List<Member> members) {
    state = _sortByNextBirthday(members);
  }

  void updateMember(Member updatedMember) {
    final myMembers = state;
    final index = myMembers.indexWhere((m) => m.id == updatedMember.id);
    myMembers[index] = updatedMember;
    state = [..._sortByNextBirthday(myMembers)];
  }

  void addMember(Member newMember) {
    final myMembers = state;
    myMembers.add(newMember);
    state = [..._sortByNextBirthday(myMembers)];
  }

  void removeMember(String memberId) {
    final myMembers = state;
    final index = myMembers.indexWhere((m) => m.id == memberId);
    myMembers.removeAt(index);
    state = [..._sortByNextBirthday(myMembers)];
  }

  List<Member> _sortByNextBirthday(List<Member> members) {
    members.sort((a, b) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Calculate difference from today for each member, ignoring year
      final memberADifference = _calculateDifference(today, a.birthDate);
      final memberBDifference = _calculateDifference(today, b.birthDate);

      return memberADifference.compareTo(memberBDifference);
    });
    return members;
  }

  int _calculateDifference(DateTime today, DateTime memberBirthdate) {
    // Helper function to calculate the difference ignoring year
    final nextBirthday = DateTime(today.year, memberBirthdate.month, memberBirthdate.day);
    if (nextBirthday.isBefore(today)) {
      // Handle birthdays that already passed this year
      return nextBirthday.difference(today).inDays + 365;
    } else {
      return nextBirthday.difference(today).inDays;
    }
  }
}

final membersProvider = StateNotifierProvider<MembersStateNotifier, List<Member>>((ref) => MembersStateNotifier());
