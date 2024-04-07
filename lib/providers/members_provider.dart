import 'package:birthday_app/models/member.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MembersStateNotifier extends StateNotifier<List<Member>> {
  MembersStateNotifier() : super([]);

  void setMembers(List<Member> members) {
    state = members;
  }

  void updateMember(Member updatedMember) {
    final myMembers = state;
    final index = myMembers.indexWhere((m) => m.id == updatedMember.id);
    myMembers[index] = updatedMember;
    state = [...myMembers];
  }

  void addMember(Member newMember) {
    final myMembers = state;
    myMembers.add(newMember);
    state = [...myMembers];
  }
}

final membersProvider = StateNotifierProvider<MembersStateNotifier, List<Member>>((ref) => MembersStateNotifier());
