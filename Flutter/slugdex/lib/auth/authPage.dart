import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:slugdex/screens/LiveMapScreen.dart';
import 'package:slugdex/screens/createAccountScreen.dart';
import 'package:slugdex/screens/loginScreen.dart';
import 'package:slugdex/main.dart';
import 'package:slugdex/Entry/entryReadWrite.dart';
import 'package:slugdex/db/ManageUserData.dart';

class authPage extends StatefulWidget {
  const authPage({Key? key}) : super(key: key);

  @override
  State<authPage> createState() => _authPageState();
}

class _authPageState extends State<authPage> {
  bool showLogin = true;

  void toggleScreens() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return loginScreen(showCreateAccountScreen: toggleScreens);
    } else {
      return createAccountScreen(showLoginScreen: toggleScreens);
    }
  }
}

class checkLogin extends StatelessWidget {
  const checkLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return LiveMapScreen();
          } else {
            return authPage();
          }
        });
  }
}
