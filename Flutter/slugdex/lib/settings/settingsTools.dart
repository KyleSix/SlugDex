import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

const Color slugdex_yellow = Color.fromARGB(255, 255, 230, 0);
Text logo = Text("SlugDex",
    style: TextStyle(
      fontFamily: "PocketMonk",
      fontSize: 40.0,
      //color: Colors.black,
      foreground: Paint()
        ..strokeWidth = 1
        ..color = Colors.white
        ..style = PaintingStyle.stroke,

      shadows: [
        Shadow(offset: Offset(-1, 1), color: Colors.black),
        Shadow(offset: Offset(1, -1), color: Colors.black),
        Shadow(offset: Offset(1, 1), color: Colors.black),
        Shadow(offset: Offset(-1, -1), color: Colors.black),
      ],
    ));

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
