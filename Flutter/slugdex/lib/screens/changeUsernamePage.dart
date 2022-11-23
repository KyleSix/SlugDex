import 'package:flutter/material.dart';
import 'package:slugdex/db/ManageUserData.dart';

class changeUsernamePage extends StatefulWidget {
  @override
  State<changeUsernamePage> createState() => _changeUsernamePageState();
}

class _changeUsernamePageState extends State<changeUsernamePage> {
  final _displayNameController = TextEditingController();

  int errorNum = 0;

  Widget getErrorMessage() {
    if (errorNum == 1) {
      return Text(
        "Display Name Must Be At Least 3 Characters",
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w500, color: Colors.red),
      );
    } else if (errorNum == 2) {
      return Text(
        "Display Name Can Be At Most 15 Characters",
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
          title: const Text("Change Display Name"),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      backgroundColor: Color.fromARGB(255, 230, 230, 230),
      body: SafeArea(
            child: Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
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
                      controller: _displayNameController,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "New Display Name"),
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
                          "Change Name",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    )),
                  ),
                ),
                onTap: () async {
                  String name = _displayNameController.text.trim();
                  if(name.length >= 3 && name.length <= 15){
                    await setDisplayName(name);
                    Navigator.pop(context);
                  } else if (name.length > 15) {
                    setState(() {
                      errorNum = 2;
                    });
                  } else {
                    setState(() {
                      errorNum = 1;
                    });
                  }
                }
            ),
          ],
        ),
      ),
    )));
  }
}