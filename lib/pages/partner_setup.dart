import 'package:emotions/services/auth_service.dart';
import 'package:emotions/services/realtime_database.dart';
import 'package:flutter/material.dart';

class PartnerSetupPage extends StatefulWidget {
  const PartnerSetupPage({super.key});

  @override
  PartnerSetupPageState createState() => PartnerSetupPageState();
}

class PartnerSetupPageState extends State<PartnerSetupPage> {
  String errorMessage = '';
  TextEditingController partnerCodeController = TextEditingController();

  void linkPartner() async {
    final partnerUid = partnerCodeController.text;
    String uid = authService.value.currentUser?.uid ?? '';

    if (partnerUid.isEmpty) {
      setState(() {
        errorMessage = 'Please enter a valid partner code';
      });
      return;
    }
    if (partnerUid == uid) {
      setState(() {
        errorMessage = 'You cannot link to yourself';
      });
      return;
    }
    try {
      await RealtimeDatabaseService().linkPartner(uid, partnerUid);
      showSuccessSnackBar();
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        errorMessage = 'Something went wrong, please try again';
      });
    }
  }

  void showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Partner linked successfully', style: TextStyle(color: Colors.grey[800])),
        duration: Duration(seconds: 3),
        backgroundColor: const Color(0xFFFFEE96),
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Partner setup'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
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
                Image.asset('lib/assets/single/heart_chicken.png'),
                SizedBox(height: 20),                
                TextField(
                  controller: partnerCodeController,
                  decoration: InputDecoration(
                    labelText: "Enter your partner's code",
                    prefixIcon: Icon(Icons.link_rounded),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      linkPartner();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB6E3E9),
                    ),
                    child: Text(
                      'Connect',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      ),
                  ),
                ),
                SizedBox(height: 20),
                Text("Or share this code with your partner:"),
                SizedBox(height: 5),
                SelectableText(authService.value.currentUser?.uid ?? ''),
                SizedBox(height: 5),
                Text(errorMessage, style: TextStyle(color: Colors.red)),
              ],
            ),
          )
        ],
      ),
    );
  }
}