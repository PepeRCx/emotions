import 'package:emotions/services/riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeTab extends ConsumerWidget {
  const MeTab({super.key});

  static const emotionImages = {
    'default': 'lib/assets/skins/default/default.png',
    'sleepy': 'lib/assets/skins/sleep/sleep.png',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            emotionImages[ref.watch(selectedCardProvider)] ?? 'lib/assets/skins/default/default.png',
          ),
        ],
      ),
    );
  }
}