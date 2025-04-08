import 'dart:async';

import 'package:emotions/services/realtime_database.dart';
import 'package:emotions/services/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PartnerData {
  final String? partnerUid;
  final String mood;
  final bool isLoading;
  final String? error;

  PartnerData({
    this.partnerUid,
    this.mood = 'normal',
    this.isLoading = false,
    this.error,
  });

  PartnerData copyWith({
    String? partnerUid,
    String? mood,
    bool? isLoading,
    String? error,
  }) {
    return PartnerData(
      partnerUid: partnerUid ?? this.partnerUid,
      mood: mood ?? this.mood,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class PartnerNotifier extends StateNotifier<PartnerData> {
  final RealtimeDatabaseService database;
  StreamSubscription<String>? _moodSubscription;

  PartnerNotifier(this.database) : super(PartnerData());

  Future<void> loadPartnerData(String uid) async {
    state = state.copyWith(isLoading: true);
    try {
      final partnerUid = await database.getUserPartnerUid(uid);
      if (partnerUid != '') {
        _subscribeToMoodChanges(partnerUid);
        state = state.copyWith(partnerUid: partnerUid, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false, error: 'No partner');
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void _subscribeToMoodChanges(String partnerUid) {
    _moodSubscription?.cancel();
    _moodSubscription = database
        .watchPartnerMood(partnerUid)
        .listen(
          (mood) {
            state = state.copyWith(mood: mood);
          },
          onError: (e) {
            state = state.copyWith(error: e.toString());
          },
        );
  }

  @override
  void dispose() {
    _moodSubscription?.cancel();
    super.dispose();
  }
}

final partnerNotifierProvider =
    StateNotifierProvider<PartnerNotifier, PartnerData>((ref) {
      final database = ref.read(databaseServiceProvider);
      return PartnerNotifier(database);
    });

final homeWidgetProvider = StateNotifierProvider<PartnerNotifier, PartnerData>((
  ref,
) {
  final database = ref.read(databaseServiceProvider);
  return PartnerNotifier(database);
});
