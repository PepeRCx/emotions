import 'package:emotions/services/auth_service.dart';
import 'package:flutter/material.dart';

class UsernameChangePage extends StatefulWidget {
  const UsernameChangePage({super.key});

  @override
  _UsernameChangePageState createState() => _UsernameChangePageState();
}

class _UsernameChangePageState extends State<UsernameChangePage> {
  String errorMessage = '';
  TextEditingController usernameController = TextEditingController();

  void changeUsername() async {
    if (usernameController.text.isEmpty) {
      setState(() {
        errorMessage = 'Username cannot be empty';
      });
      return;
    }
    try {
      await authService.value.updateUsername(username: usernameController.text);
      showSnackBarSuccess();
      if (!mounted) return;
      Navigator.pop(context);
      errorMessage = '';
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  void showSnackBarSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Username changed successfully', style: TextStyle(color: Colors.grey[800])),
        backgroundColor: Colors.lightBlueAccent,
        duration: Duration(seconds: 3),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Change username'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/backgrounds/home_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'New username',
                    prefixIcon: Icon(Icons.edit)
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      changeUsername();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: const Color.fromARGB(255, 182, 227, 233)
                    ),
                    child: Text('Change username',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ),
                ),
                Text(
                  errorMessage,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}