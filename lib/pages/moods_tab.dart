import 'package:emotions/components/emotion_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoodsTab extends ConsumerWidget {
  const MoodsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ListView(
        children: [
          SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              EmotionCard(
                emotionId: 'normal',
                text: 'Normal',
                imagePath: 'lib/assets/skins/default/default_mood.png'),
              EmotionCard(
                emotionId: 'sleepy',
                text: 'Sleepy', 
                imagePath: 'lib/assets/skins/sleep/sleepy.png'),
            ],
          )
        ],
      ),
    );
  }
}