import 'package:emotions/models/partner_data.dart';
import 'package:emotions/pages/couple.dart';
import 'package:emotions/components/me.dart';
import 'package:emotions/pages/moods_tab.dart';
import 'package:emotions/pages/settings.dart';
import 'package:emotions/services/app_initializer.dart';
import 'package:emotions/services/auth_service.dart';
import 'package:emotions/services/riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  String appGroupId = 'group.emotionsPartnerMood';
  String iosWidgetName = "PartnerMoodWidget";
  String dataKey = "text_from_flutter_app";

  final List<Widget> _screens = [
    ShopScreen(),
    HomeScreen(),
    InventoryScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    HomeWidget.setAppGroupId(appGroupId);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppInitializer.initializePartnerData(ref);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void initializePartnerData(WidgetRef ref) async {
    final uid = authService.value.currentUser?.uid;
    if (uid != null) {
      ref.read(partnerNotifierProvider.notifier).loadPartnerData(uid);
    }
  }

  final widgetUpdateProvider = Provider((ref) {
    final mood = ref.watch(partnerNotifierProvider.select((data) => data.mood));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await HomeWidget.saveWidgetData('text_from_flutter_app', mood);
        await HomeWidget.updateWidget(
          iOSName: 'PartnerMoodWidget',
          androidName: 'PartnerMoodWidget',
        );
      } catch (e) {
        debugPrint('Error updating widget: $e');
      }
    });
  });

  @override
  Widget build(BuildContext context) {
    ref.watch(widgetUpdateProvider);
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/backgrounds/home_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          _screens[_selectedIndex],
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: const Color(0xFFFFEE96),
        indicatorColor: const Color(0xFFFFE043),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            selectedIcon: Icon(Icons.shopping_bag),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_emotions_outlined),
            selectedIcon: Icon(Icons.emoji_emotions),
            label: 'Inventory',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mood = ref.watch(partnerNotifierProvider.select((data) => data.mood));
    return Center(child: Stack(children: [Text(mood)]));
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Stack(children: [CouplePage()]));
  }
}

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext content) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: const Color(0xFFC8E2C8),
          bottom: const TabBar(
            dividerColor: Colors.transparent,
            tabs: [Tab(text: 'Me'), Tab(text: 'Moods')],
          ),
        ),
        body: TabBarView(
          children: [
            Stack(
              children: [
                Image.asset(
                  'lib/assets/backgrounds/home_bg.png',
                  fit: BoxFit.cover,
                ),
                MeTab(), //Component
              ],
            ),
            Stack(
              children: [
                Image.asset(
                  'lib/assets/backgrounds/home_bg.png',
                  fit: BoxFit.cover,
                ),
                MoodsTab(), //Component
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: ListView(children: [SettingsPage()]));
  }
}
