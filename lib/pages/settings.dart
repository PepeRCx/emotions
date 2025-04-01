import 'package:emotions/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  void _logout() async {
    try {
      await authService.value.signOut();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [const Color.fromARGB(130, 255, 235, 59), const Color.fromARGB(240, 0, 174, 255)]),
            border: Border.all(color: Color.fromARGB(255, 255, 238, 150), width: 4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                authService.value.currentUser?.displayName ?? 'Emotions',
                style: TextStyle(fontSize: 22),
              ),
              Text(
                authService.value.currentUser?.email ?? 'emotions@emotions.com',
              ),
            ],
          ),
        ),
        ListTile(
          title: Text('Partner setup'),
          leading: Icon(Icons.emoji_nature),
          trailing: Icon(Icons.arrow_forward_ios, size: 18),
          onTap: () => Navigator.pushNamed(context, '/partner_setup'),
        ),
        ListTile(
          title: Text('Change username'),
          leading: Icon(Icons.edit),
          trailing: Icon(Icons.arrow_forward_ios, size: 18),
          onTap: () {
            Navigator.pushNamed(context, '/username_change');
          },
        ),
        ListTile(
          title: Text('Change password'),
          leading: Icon(Icons.password),
          trailing: Icon(Icons.arrow_forward_ios, size: 18),
          onTap: () {
            Navigator.pushNamed(context, '/password_change');
          },
        ),
        ListTile(
          title: Text('Delete my account'),
          leading: Icon(Icons.delete),
          trailing: Icon(Icons.arrow_forward_ios, size: 18),
          onTap: () {
            Navigator.pushNamed(context, '/delete_account');
          },
        ),
        ListTile(
          title: Text('Logout'),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Logout'),
                  content: Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent
                      ),
                      child: Text('Logout'),
                      onPressed: () {
                        _logout();
                      },
                    ),
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              }, 
            );
          },
          leading: Icon(Icons.logout),
        )
      ],
    );
  }
}