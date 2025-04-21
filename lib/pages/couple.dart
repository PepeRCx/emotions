import 'package:emotions/services/auth_service.dart';
import 'package:emotions/services/realtime_database.dart';
import 'package:flutter/material.dart';
import 'package:emotions/services/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

bool isLinked = false;
String uid = authService.value.currentUser?.uid ?? '';

class CouplePage extends StatefulWidget {
  const CouplePage({super.key});

  @override
  CouplePageState createState() => CouplePageState();
}

class CouplePageState extends State<CouplePage> {
  @override
  void initState() {
    super.initState();
    checkPartner();
  }

  void checkPartner() async {
    try {
      final partner = await RealtimeDatabaseService().getUserPartner(uid);
      if (partner) {
        setState(() {
          isLinked = true;
        });
      } else {
        setState(() {
          isLinked = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: LoadingWidget(),
      //isLinked ? Partner() : NotPartner(),
    );
  }
}

class NotPartner extends StatelessWidget {
  const NotPartner({super.key});

  @override
  Widget build(BuildContext build) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "You don't have a partner yet, please go to settings and link you to a partner.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        Image.asset('lib/assets/single/broke.png'),
      ],
    );
  }
}

class Partner extends ConsumerWidget {
  const Partner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.read(databaseServiceProvider);

    const moodImages = {
      'normal': 'lib/assets/skins/default/default.png',
      'angry': 'lib/assets/images/moods/angry.png',
      'happy': 'lib/assets/images/moods/happy.png',
      'hungry': 'lib/assets/images/moods/hungry.png',
      'sad': 'lib/assets/images/moods/sad.png',
      'shy': 'lib/assets/images/moods/shy.png',
    };

    return FutureBuilder<String>(
      future: database.getUserPartnerUid(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget();
        }
        if (!snapshot.hasData) {
          return Text('No partner found');
        }

        final partnerUid = snapshot.data!;
        //final partnerMoodStream = database.watchPartnerMood(partnerUid);

        return StreamBuilder<String>(
          stream: database.watchPartnerMood(partnerUid),
          initialData: 'normal',
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingWidget();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final mood = snapshot.data ?? 'loading...';

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  moodImages[mood] ?? 'lib/assets/skins/default/default.png',
                ),
                Text('Your partner is currently $mood'),
              ],
            );
          },
        );
      },
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show loading indicator
        }
        return isLinked ? Partner() : NotPartner();
      },
    );
  }
}

Future<bool> fetchData() async {
  return true;
}
