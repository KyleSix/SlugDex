import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:slugdex/auth/authPage.dart';
import 'package:slugdex/settings/settingsTools.dart';
import 'package:slugdex/screens/editProfilePage.dart';
import 'package:slugdex/main.dart';

const double spacing = 16.0;
const double icon_size = 24.0;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Get User info
  final User? user = FirebaseAuth.instance.currentUser;

  // Configure settings
  bool logoutEnabled = (FirebaseAuth.instance.currentUser != null)
      ? true
      : false; // Check to see if we're logged in
  // Store settings
  static const keyDevMode = "key-dev-mode";

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
          centerTitle: false,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        backgroundColor: Color.fromARGB(255, 230, 230, 230),
        body: ListView(
          padding: EdgeInsets.all(8),
          children: [
            ////// The User profile Icon and Name ///////
            WrapperWidget(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                        tag: 'SettingsBtn',
                        child: Container(
                          height: 80.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(120)),
                          child: profilePic,
                        )),
                    const SizedBox(width: 24.0),
                    Text(displayName,
                        textScaleFactor: 2.0,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
              background_color: slugdex_yellow,
            ),
            ////// The First Group of Settings ////
            SettingsGroup(
              title: "ACCOUNT",
              titleTextStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: <Widget>[
                const SizedBox(height: 4),
                WrapperWidget(children: [
                  const SizedBox(height: 2),
                  buildEditProfile(), // Edit Profile Button
                  const SizedBox(height: spacing),
                  buildLogout(), // Logout Button
                  const SizedBox(height: spacing),
                  buildDeleteAccount(), // Delete Account Button
                  const SizedBox(height: 2),
                ]),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            ////// The Second Group of Settings ////
            SettingsGroup(
              title: "MISC",
              titleTextStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: <Widget>[
                const SizedBox(height: 4),
                WrapperWidget(children: [
                  const SizedBox(height: 2),
                  buildBugReport(), // Bug Report Button
                  const SizedBox(height: spacing),
                  buildFeedback(), // Feedback Button
                  const SizedBox(height: spacing),
                  buildDevMode(), // Dev Mode Button
                  const SizedBox(height: 2),
                ]),
              ],
            ),
          ],
        ),
      );

  /// Edit Profile Settings ///
  Widget buildEditProfile() => SimpleSettingsTile(
        title: "Edit Profile",
        subtitle: "Appearance, Display Name",
        leading: IconWidget(
            icon: Icons.edit_note, color: Colors.greenAccent, size: icon_size),
        enabled: logoutEnabled,
        child: EditProfilePage(),
      );

  /// Logout Setting ///
  Widget buildLogout() => SimpleSettingsTile(
      title: "Logout",
      subtitle: "",
      leading: IconWidget(
          icon: Icons.logout, color: Colors.blueAccent, size: icon_size),
      enabled: logoutEnabled,
      onTap: () async {
        if (!logoutEnabled) return; // Only works if we're signed in
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Logging Out..."),
              duration: const Duration(milliseconds: 2000)),
        );
        logoutEnabled = false; // Set our logout flag to disable setting
        await FirebaseAuth.instance.signOut(); // do sign out
        Navigator.popUntil(
            context, (route) => false); // Go back to sign-in screen
        Navigator.push(context, MaterialPageRoute(builder: (context) => checkLogin()));
      });

  /// Delete Account Setting ///
  Widget buildDeleteAccount() => SimpleSettingsTile(
      title: "Delete Account",
      subtitle: "",
      leading: IconWidget(
          icon: Icons.delete_forever, color: Colors.grey, size: icon_size),
      enabled: logoutEnabled,

      /// On Tap displays Alert Dialog for deletion confirmation ///
      onTap: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Account Deletion Warning'),
              content:
                  const Text('Are you sure you would to delete your account?'),
              actions: <Widget>[
                /// Account deletion canceled ///
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),

                /// Account deletion confirmed ///
                TextButton(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Deleting Account..."),
                          duration: const Duration(milliseconds: 2000)),
                    );
                    logoutEnabled = false;
                    await user?.delete(); // do account deletion
                    Navigator.popUntil(
                        context, (route) => false); // Go back to sign-in screen
                    Navigator.push(context, MaterialPageRoute(builder: (context) => checkLogin()));
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          ));

  Widget buildBugReport() => SimpleSettingsTile(
        title: "Report A Bug",
        leading: IconWidget(
            icon: Icons.bug_report, color: Colors.grey, size: icon_size),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Feature in progress..."),
                duration: const Duration(milliseconds: 2000)),
          );
        },
      );

  Widget buildFeedback() => SimpleSettingsTile(
        title: "Send Feedback",
        leading:
            IconWidget(icon: Icons.email, color: Colors.grey, size: icon_size),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Feature in progress..."),
                duration: const Duration(milliseconds: 2000)),
          );
        },
      );

  Widget buildDevMode() => SwitchSettingsTile(
        title: "Developer Mode",
        subtitle: "",
        settingKey: keyDevMode,
        leading: IconWidget(
            icon: Icons.developer_mode, color: Colors.grey, size: icon_size),
        onChange: (value) async {
          await Settings.setValue<bool>(keyDevMode, value);
          debugPrint(keyDevMode + ": $value");
        },
      );
}
