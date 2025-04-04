import 'package:emotions/services/realtime_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseServiceProvider = Provider((ref) => RealtimeDatabaseService());

final selectedCardProvider = StateProvider<String>((ref) {
  return 'normal';
});

final userMoodProvider = StreamProvider.autoDispose.family<String, String>((ref, uid) {
  final database = ref.watch(databaseServiceProvider);
  return database.getUserMood(uid);
});

final moodSyncProvider = NotifierProvider.autoDispose<MoodSyncNotifier, void>(() {
  return MoodSyncNotifier();
});

final storedPartnerMood = StateProvider<String>((ref) => 'normal');
final storedPartnerMoodProvider = NotifierProvider<StoredPartnerMoodNotifier, String>(() {
  return StoredPartnerMoodNotifier();
});

class MoodSyncNotifier extends AutoDisposeNotifier<void> {
  @override
  void build() {
    // No initial state needed
    return;
  }

  Future<void> syncMoodToDatabase(String uid, String newMood) async {
    // Update local state
    ref.read(selectedCardProvider.notifier).state = newMood;
    
    // Update database
    final database = ref.read(databaseServiceProvider);
    await database.updateUserMood(uid, newMood);
  }
}

class StoredPartnerMoodNotifier extends Notifier<String> {
  @override
  String build() {
    return 'normal';
  }

  void storePartnerMood(String mood) {
    state = mood;
    ref.read(storedPartnerMood.notifier).state = mood;
  }
}