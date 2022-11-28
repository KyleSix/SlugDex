import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:slugdex/db/ManageUserData.dart';
import 'package:slugdex/main.dart';
import 'package:slugdex/Entry/entryReadWrite.dart';
import 'package:slugdex/settings/settingsTools.dart';

class loginScreen extends StatefulWidget {
  final VoidCallback showCreateAccountScreen;
  const loginScreen({
    Key? key,
    required this.showCreateAccountScreen,
  }) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool loginFailed = false;

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      //Initialize entryList and load user's discovered entries into entryList
      entryList = await loadEntry();
      loadUserDiscovered();
      displayName = await getDisplayName();
      profileImageURL = await getProfileImageURL();
    } catch (_) {
      setState(() {
        loginFailed = true;
      });
    }
  }

  Widget getErrorMessage() {
    if (loginFailed) {
      return Text(
        "Email Or Password Is Incorrect",
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, color: Colors.red),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: slugdex_yellow,
        body: SafeArea(
            child: Center(
      child: SingleChildScrollView(
        child:
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            fit: StackFit.passthrough,
            children: [ 
              Positioned(
                top:-150,
                left:10.0,
                child: IconWidget(
                  icon: Icons.catching_pokemon, 
                  color: Colors.transparent,
                  icon_color: Colors.white,
                  radius: 0,
                  size: 700,
                )
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                    child: title
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 3, 20, 3),
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "Email"),
                          )),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 3, 20, 3),
                          child: TextField(
                            obscureText: true,
                            controller: _passwordController,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: "Password"),
                          )),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0.0),
                    child: getErrorMessage(),
                  ),
                  InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                              child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          )),
                        ),
                      ),
                      onTap: () {
                        signIn();
                      }),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          Text(
                            " Create one",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                    onTap: widget.showCreateAccountScreen,
                  ),
                ],
              ),
            ]
          )
      ),
    )));
  }
}
