import 'package:emotions/services/auth_service.dart';
import 'package:emotions/services/riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmotionCard extends ConsumerWidget {
  final String text;
  final String imagePath;
  final Color borderColor;
  final Color borderColorPressed;
  final Color backgroundColor;
  final double borderRadius;
  final VoidCallback? onTap;

  final String emotionId;
  final Color selectedColor;

  const EmotionCard({
    super.key,
    required this.text,
    required this.imagePath,
    required this.emotionId,

    this.selectedColor = const Color(0xFFA8D8EA),
    this.borderColor = Colors.lightBlue,
    this.borderColorPressed = const Color.fromARGB(255, 0, 118, 157),
    this.backgroundColor = const Color(0xFFDCE2C8),
    this.borderRadius = 20,
    this.onTap,
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String uid = authService.value.currentUser?.uid ?? '';

    final moodState = ref.watch(userMoodProvider(uid));
    final currentMood = moodState.value;

    final isSelected = currentMood == emotionId;
    
    return GestureDetector(
      onTap: () {
        ref.read(selectedCardProvider.notifier).state = emotionId;
        ref.read(moodSyncProvider.notifier).syncMoodToDatabase(uid, emotionId);
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: 1.0,
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isSelected ? borderColorPressed : borderColor, 
              width: isSelected ? 3 : 2,
              ),
            color: backgroundColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              Image.asset(
                imagePath,
                width: 120,
                height: 120,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
