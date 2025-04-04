import 'package:emotions/pages/couple.dart';
import 'package:emotions/components/me.dart';
import 'package:emotions/pages/moods_tab.dart';
import 'package:emotions/pages/settings.dart';
import 'package:emotions/services/push_notifications.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    PushNotificationsService().initNotifications();
  }

  final List<Widget> _screens = [
    Center(child: Text("Shop", style: TextStyle(fontSize: 24))),
    HomeScreen(),
    InventoryScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
          children: [
            CouplePage(),
          ],
        ),
    );
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
            tabs: [
              Tab(text: 'Me',),
              Tab(text: 'Moods',),
            ],
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
                MeTab() //Component
              ],
            ),
            Stack(
              children: [
                Image.asset(
                  'lib/assets/backgrounds/home_bg.png',
                  fit: BoxFit.cover,
                ),
                MoodsTab() //Component
              ],
            )
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
    return Center(
      child: ListView(
        children: [
          SettingsPage(),
        ],
      ),
    );
  }
}
