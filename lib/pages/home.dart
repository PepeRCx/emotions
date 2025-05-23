import 'dart:io';

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
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:home_widget/home_widget.dart';
import 'dart:io';

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
      bottomNavigationBar: Container(
        color: const Color(0xFFFFEE96),
        height: Platform.isAndroid ? 65 : 90,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Platform.isAndroid ? 15 : 15, vertical: Platform.isAndroid ? 10 : 20), //5 + 10
          child: GNav(
            haptic: true,
            gap: 8,
            backgroundColor: const Color(0xFFFFEE96),
            tabBackgroundColor: const Color(0xFFFFE043),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: Platform.isAndroid ? 5 : 12), //10 + 5
            onTabChange: (index) {
              _onItemTapped(index);
            },
            tabs: [
              GButton(
                icon: Icons.shop,
                iconColor: Colors.transparent,
                text: 'Shop',
                textStyle: TextStyle(fontSize: 18),
                leading: Image.asset(
                  'lib/assets/icons/shop.png',
                  width: 26,
                  height: 26,
                ),
              ),
              GButton(
                icon: Icons.home,
                iconColor: Colors.transparent,
                text: 'Home',
                textStyle: TextStyle(fontSize: 18),
                leading: Image.asset(
                  'lib/assets/icons/home.png',
                  width: 26,
                  height: 26,
                ),
              ),
              GButton(
                icon: Icons.inventory,
                iconColor: Colors.transparent,
                text: 'Inventory',
                textStyle: TextStyle(fontSize: 18),
                leading: Image.asset(
                  'lib/assets/icons/inventory.png',
                  width: 28,
                  height: 28,
                ),
              ),
              GButton(
                icon: Icons.settings,
                iconColor: Colors.transparent,
                text: 'Settings',
                textStyle: TextStyle(fontSize: 18),
                leading: Image.asset(
                  'lib/assets/icons/settings.png',
                  width: 26,
                  height: 26,
                ),
              ),
            ],
          ),
        ),
      )
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
            labelStyle: TextStyle(
              fontFamily: 'AmaticSC',
              fontSize: 22,
            ),
            dividerColor: Colors.transparent,
            tabs: [Tab(text: 'Me'), Tab(text: 'Moods')],
          ),
        ),
        body: TabBarView(
          children: [
            Stack(
              children: [
                Image.asset(
                  'lib/assets/backgrounds/inv_2.png',
                  fit: BoxFit.cover,
                ),
                MeTab(), //Component
              ],
            ),
            Stack(
              children: [
                Image.asset(
                  'lib/assets/backgrounds/inv_1.png',
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
