import 'package:emotions/models/partner_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emotions/services/auth_service.dart';

class AppInitializer {
  static void initializePartnerData(WidgetRef ref) {
    final uid = authService.value.currentUser?.uid;
    if (uid != null && uid.isNotEmpty) {
      ref.read(partnerNotifierProvider.notifier).loadPartnerData(uid);
    }
  }
}
