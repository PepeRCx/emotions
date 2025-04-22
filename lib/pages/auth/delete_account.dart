import 'package:emotions/services/auth_service.dart';
import 'package:emotions/services/realtime_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeleteAccount extends StatefulWidget{
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  String uid = authService.value.currentUser?.uid ?? '';

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String errorMessage = '';

  void deleteAccount() async {
    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = 'Passwords do not match';
      });
      Navigator.of(context).pop();
      return;
    }
    try {
      String partnerUid = await RealtimeDatabaseService().getUserPartnerUid(uid);
      bool hasPartner = await RealtimeDatabaseService().getUserPartner(uid);
      if (hasPartner) {
        await RealtimeDatabaseService().unlinkPartner(uid, partnerUid);
      }
      await authService.value.deleteAccount(email: authService.value.currentUser!.email!, password: passwordController.text);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      showSuccessSnackBar();
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'An unknown error ocurred';
        Navigator.of(context).pop();
      });
    }
  }

  void showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Account deleted successfully', style: TextStyle(color: Colors.grey[800]),),
        duration: Duration(seconds: 3),
        backgroundColor: const Color.fromARGB(255, 255, 238, 150),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Delete account'),
        backgroundColor: Colors.transparent,
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
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext content) {
                          return AlertDialog(
                            title: Text('Final warning'),
                            content: Text('Are you sure you want to delete your account? there is no going back.'),
                            actions: [
                              TextButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlueAccent
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                child: Text('Delete account'),
                                onPressed: () {
                                  deleteAccount();
                                },
                              )
                            ],
                          );
                        }
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                      ),
                      backgroundColor: const Color.fromARGB(255, 182, 227, 233)
                    ),
                    child: Text(
                      'Delete account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400
                      ),
                      ),
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