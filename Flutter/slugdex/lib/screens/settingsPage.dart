import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

const double spacing = 16.0;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool logoutEnabled = true; // Do some check to see if we're logged in
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
          padding: EdgeInsets.all(24),
          children: [
            ////// The User profile Icon and Name ///////
            WrapperWidget(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                        tag: 'SettingsBtn',
                        child: IconWidget(
                          icon: Icons.person,
                          color: Colors.white,
                          size: 64.0,
                          radius: 64.0,
                          icon_color: Colors.black,
                        )),
                    const SizedBox(width: 24.0),
                    Text("Sammy Slug",
                        textScaleFactor: 2.0,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
              background_color: Color.fromARGB(255, 255, 208, 0),
            ),
            ////// The First Group of Settings ////
            SettingsGroup(
              title: "GENERAL",
              children: <Widget>[
                const SizedBox(height: 4),
                WrapperWidget(children: [
                  const SizedBox(height: 10),
                  buildLogout(), // Logout Button
                  const SizedBox(height: spacing),
                  buildDeleteAccount(), // Delete Account Button
                  const SizedBox(height: 10),
                ]),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            ////// The Second Group of Settings ////
            SettingsGroup(
              title: "MISC",
              children: <Widget>[
                const SizedBox(height: 4),
                WrapperWidget(children: [
                  const SizedBox(height: 10),
                  buildDevMode(),
                  const SizedBox(height: 10),
                ]),
              ],
            ),
          ],
        ),
      );

  Widget buildLogout() => SimpleSettingsTile(
      title: "Logout",
      subtitle: "",
      leading:
          IconWidget(icon: Icons.logout, color: Colors.blueAccent, size: 30.0),
      enabled: logoutEnabled,
      onTap: () {
        if (!logoutEnabled) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Logging Out...")),
        );
        logoutEnabled = false;
      });
  Widget buildDeleteAccount() => SimpleSettingsTile(
      title: "Delete Account",
      subtitle: "",
      leading: IconWidget(
          icon: Icons.delete_forever, color: Colors.redAccent, size: 30.0),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Deleting Account...")),
        );
      });
  
  Widget buildDevMode() => SwitchSettingsTile(
        title: "Developer Mode",
        settingKey: keyDevMode,
        leading: IconWidget(icon: Icons.developer_mode, color: Colors.grey),
        onChange: (value) {
          debugPrint(keyDevMode + ": $value");
        },
      );
}

// This class wraps an Icon in a container of a specific shape and color
// Usage: IconWidget(icon: Icons.menu, color: Colors.black)
class IconWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double radius;
  final Color icon_color;

  const IconWidget(
      {Key? key,
      required this.icon,
      required this.color,
      this.size = 24.0,
      this.radius = 16.0,
      this.icon_color = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
          ),
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          color: color,
        ),
        child: Icon(
          icon,
          color: icon_color,
          size: size,
        ),
      );
}

// This class wraps any collections of setting tile in a white container with rounded edges
class WrapperWidget extends StatelessWidget {
  final List<Widget> children;
  final Color background_color;
  const WrapperWidget({
    Key? key,
    required this.children,
    this.background_color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(
            color: background_color,
          ),
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          color: background_color,
        ),
        child: Column(
          children: children,
        ),
      );
}
