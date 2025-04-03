import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {

    final fcmToken = await _firebaseMessaging.getToken();
    
    if (fcmToken != null) {
      print('✅ FCM Token: $fcmToken');
    } else {
      print('❌ Failed to get FCM Token');
    }
  }
}
