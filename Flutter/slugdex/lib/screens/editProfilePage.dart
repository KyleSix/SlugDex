import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:slugdex/screens/changeProfileImagePage.dart';
import 'package:slugdex/settings/settingsTools.dart';
import 'package:slugdex/main.dart';
import 'package:slugdex/screens/changeUsernamePage.dart';

const double icon_size = 24.0;

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String displayNameState = displayName;
  Widget profilePicState = profilePic();
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Color.fromARGB(255, 230, 230, 230),
      body: Container(
          padding: EdgeInsets.all(8),
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              new Positioned(
                  top: 100.0,
                  left: 0, //set left 0, to start without margin at left
                  right: 0, //set right 0 to end without margin at right
                  child: WrapperWidget(children: [
                    const SizedBox(height: 40.0),
                    Text(displayNameState,
                        textScaleFactor: 2.0,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10.0),
                    buildUsername(),
                    const SizedBox(height: 10.0),
                    buildAppearance()
                  ])),
              Hero(
                  tag: 'ProfileBtn',
                  child: Container(
                    height: 128.0,
                    width: 128.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(120)
                    ),
                    child: profilePicState
                  )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 60,
                  height: 40,
                  decoration: BoxDecoration(
                    color: slugdex_yellow, 
                    border: Border.all(color: slugdex_yellow),
                    borderRadius: BorderRadius.all(Radius.circular(32.0))
                  ),
                  child: IconButton(
                      icon: Icon(Icons.done),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              )
            ],
          )));

  Widget buildUsername() => SimpleSettingsTile(
        title: "Change Display Name",
        leading:
            IconWidget(icon: Icons.edit, color: Colors.grey, size: icon_size),
        onTap: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => changeUsernamePage()));
          setState(() {
            displayNameState = displayName;
          });
        },
      );

  Widget buildAppearance() => SimpleSettingsTile(
        title: "Change Appearance",
        leading: IconWidget(
            icon: Icons.image_search, color: Colors.grey, size: icon_size),
        onTap: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => changeProfileImagePage()));
          setState(() {
            profilePicState = new profilePic();
          });
        },
      );
}
