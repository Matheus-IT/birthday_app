import 'package:birthday_app/models/member.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MembersStateNotifier extends StateNotifier<List<Member>> {
  MembersStateNotifier() : super([]);

  void setMembers(List<Member> members) {
    state = members;
  }
}

final membersProvider = StateNotifierProvider<MembersStateNotifier, List<Member>>((ref) => MembersStateNotifier());
