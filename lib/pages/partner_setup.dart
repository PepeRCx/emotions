import 'package:emotions/components/buttons/main_button.dart';
import 'package:emotions/services/auth_service.dart';
import 'package:emotions/services/realtime_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String uid = authService.value.currentUser?.uid ?? '';

class PartnerSetupPage extends StatefulWidget {
  const PartnerSetupPage({super.key});

  @override
  PartnerSetupPageState createState() => PartnerSetupPageState();
}

class PartnerSetupPageState extends State<PartnerSetupPage> {
  bool isLinked = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkPartner();
  }

  void checkPartner() async {
    try {
      final partner = await RealtimeDatabaseService().getUserPartner(uid);
      if (partner) {
        setState(() {
          isLinked = true;
        });
      } else {
        setState(() {
          isLinked = false;
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'lib/assets/backgrounds/home_bg.png',
                fit: BoxFit.cover,
              ),
            ),
            isLoading ? LoadingWidget() : isLinked ? LinkedPartnerPage() : LinkPartnerPage(),
          ],
        ),
      ),
    );
  }

}

class LinkedPartnerPage extends StatefulWidget {
  const LinkedPartnerPage({super.key});

  @override
  LinkedPartnerPageState createState() => LinkedPartnerPageState();
}

class LinkedPartnerPageState extends State<LinkedPartnerPage> {
  String errorMessage = '';

  void unlinkPartner() async {
    try {
      String partnerUid = await RealtimeDatabaseService().getUserPartnerUid(uid);
      await RealtimeDatabaseService().unlinkPartner(uid, partnerUid);
      showSuccessSnackBar();
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        errorMessage = 'Something went wrong, please try again';
      });
    }
  }

  Future<bool?> showConfirmDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Unlink'),
        content: Text('This action cannot be undone, are you sure about it?'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Yes'),
          ),
        ],
      )
    );
  }

  void showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Partner unlinked successfully', style: TextStyle(color: Colors.grey[800])),
        duration: Duration(seconds: 3),
        backgroundColor: const Color(0xFFFFEE96),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Image.asset('lib/assets/single/heart_chicken.png'),
            Text('You are linked with someone', style: TextStyle(fontSize: 18)),
            Spacer(),
            Text(errorMessage, style: TextStyle(
              fontSize: 18,
              color: Colors.red
            ),),
            MainButton(text: 'UNLINK', onPressed: () => {
              showConfirmDialog(context).then((value) {
                if (value == true) {
                  unlinkPartner();
                }
              })
            })
          ],
        ),
      )
    );
  }
}

class LinkPartnerPage extends StatefulWidget {
  const LinkPartnerPage({super.key});

  @override
  LinkPartnerPageState createState() => LinkPartnerPageState();
}

class LinkPartnerPageState extends State<LinkPartnerPage> {
  String errorMessage = '';
  TextEditingController partnerCodeController = TextEditingController();

  void linkPartner() async {
    final partnerUid = partnerCodeController.text;

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
        errorMessage = e.toString();
        print(e.toString());
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
    return Padding(
      padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/single/heart_chicken.png',
            ),
            SizedBox(height: 20),
            TextField(
              controller: partnerCodeController,
              decoration: InputDecoration(
                labelText: "Enter your partner's code",
                prefixIcon: Icon(Icons.link_rounded),
              ),
            ),
          SizedBox(height: 20),
          MainButton(
            text: 'Connect',
            onPressed: () {
              linkPartner();
            },
          ),
          SizedBox(height: 5),
          Text(errorMessage, style: TextStyle(color: Colors.red)),
          Text("Or share this code with your partner:"),
          SizedBox(height: 5,),
          SelectableText(authService.value.currentUser?.uid ?? ''),
        ],
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CupertinoActivityIndicator(
        radius: 15,
      ),
    );
  }
}