import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:slugdex/Entry/entryReadWrite.dart';
import 'package:slugdex/db/ManageUserData.dart';
import 'package:slugdex/main.dart';

class createAccountScreen extends StatefulWidget {
  final VoidCallback showLoginScreen;
  const createAccountScreen({
    Key? key,
    required this.showLoginScreen,
  }) : super(key: key);

  @override
  State<createAccountScreen> createState() => _createAccountScreenState();
}

class _createAccountScreenState extends State<createAccountScreen> {
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  int errorNum = 0;

  Future signUp() async {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());

        String name = _displayNameController.text.trim();

        //Initialize entryList and create userData, then upload it
        entryList = await loadEntry();
        initializeDiscovered();
        createDatabaseForUser();
        updateUserData();
        setDisplayName(name);
        displayName = await getDisplayName();
      } on FirebaseAuthException catch (error) {
        if (error.code == 'email-already-in-use') {
          setState(() {
            errorNum = 2;
          });
        } else if (error.code == 'weak-password') {
          setState(() {
            errorNum = 3;
          });
        } else {
          setState(() {
            errorNum = -1;
          });
        }
      }
    } else {
      setState(() {
        errorNum = 1;
      });
    }
  }

  Widget getErrorMessage() {
    if (errorNum == 1) {
      return Text(
        "Passwords Do Not Match",
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, color: Colors.red),
      );
    } else if (errorNum == 2) {
      return Text(
        "Email Is Already In Use",
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, color: Colors.red),
      );
    } else if (errorNum == 3) {
      return Text(
        "Password Must Be At Least 6 Characters",
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, color: Colors.red),
      );
    } else if (errorNum == -1) {
      return Text(
        "Please Enter A Valid Email And Password",
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                  child: const Text('SlugDex',
                      style: TextStyle(
                          inherit: true,
                          color: Colors.white,
                          fontSize: 75,
                          shadows: [
                            Shadow(
                                offset: Offset(-1.5, 1.5), color: Colors.black),
                            Shadow(
                                offset: Offset(1.5, -1.5), color: Colors.black),
                            Shadow(
                                offset: Offset(1.5, 1.5), color: Colors.black),
                            Shadow(
                                offset: Offset(-1.5, -1.5),
                                color: Colors.black),
                          ])),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 3, 20, 3),
                        child: TextField(
                          controller: _displayNameController,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: "Display Name"),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 10.0),
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 3, 20, 3),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: "Password"),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 3, 20, 3),
                        child: TextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Confirm Password"),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 0.0),
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
                              "Create Account",
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
                      signUp();
                    }),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        Text(
                          " Log in",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  onTap: widget.showLoginScreen,
                ),
              ],
            ),
          ),
        )));
  }
}
