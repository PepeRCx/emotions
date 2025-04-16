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
                text: 'Neutral',
                imagePath: 'lib/assets/images/mood_cards/neutral.png'
              ),
              EmotionCard(
                emotionId: 'angry',
                text: 'Angry', 
                imagePath: 'lib/assets/images/mood_cards/angry.png',
              ),
              EmotionCard(
                emotionId: 'happy',
                text: 'Happy',
                imagePath: 'lib/assets/images/mood_cards/happy.png',
              ),
              EmotionCard(
                emotionId: 'hungry',
                text: 'Hungry',
                imagePath: 'lib/assets/images/mood_cards/hungry.png',
              ),
              EmotionCard(
                emotionId: 'sad',
                text: 'Sad',
                imagePath: 'lib/assets/images/mood_cards/sad.png',
              ),
              EmotionCard(
                emotionId: 'shy',
                text: 'Shy',
                imagePath: 'lib/assets/images/mood_cards/shy.png',
              ),
            ],
          )
        ],
      ),
    );
  }
}