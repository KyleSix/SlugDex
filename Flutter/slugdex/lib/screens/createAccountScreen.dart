import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class createAccountScreen extends StatefulWidget {
  final VoidCallback showLoginScreen;
  const createAccountScreen({
    Key? key,
    required this.showLoginScreen,
    }) : super(key:key);

  @override
  State<createAccountScreen> createState() => _createAccountScreenState();
}

class _createAccountScreenState extends State<createAccountScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

    Future signUp() async {
      if (_passwordController.text.trim() == _confirmPasswordController.text.trim()) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(), 
          password: _passwordController.text.trim()
        );
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
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email"
                        ),
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password"
                        ),
                      )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Confirm Password"
                        ),
                      )
                    ),
                  ),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 75.0, vertical: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Container(
                          child: Text("Create Account", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),),
                        )
                      ),
                    ),
                  ),
                  onTap: () {
                    signUp();
                  }
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),),
                        Text(" Log in", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.blue),),
                      ],
                    ),
                  ),
                  onTap: widget.showLoginScreen,
                ),
              ],
            ),
          ),
        )
      )
    );
  }
}