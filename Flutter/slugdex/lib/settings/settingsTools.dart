import 'package:flutter/material.dart';
import 'package:slugdex/main.dart';

// App Accent Color
const Color slugdex_yellow = Color.fromARGB(255, 255, 230, 0);
Map<int, Color> slugdex_yellow_map = {
  50: slugdex_yellow.withOpacity(.1),
  100: slugdex_yellow.withOpacity(.2),
  200: slugdex_yellow.withOpacity(.3),
  300: slugdex_yellow.withOpacity(.4),
  400: slugdex_yellow.withOpacity(.5),
  500: slugdex_yellow.withOpacity(.6),
  600: slugdex_yellow.withOpacity(.7),
  700: slugdex_yellow.withOpacity(.8),
  800: slugdex_yellow.withOpacity(.9),
  900: slugdex_yellow.withOpacity(1),
};

// Logo Formatting
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

Text title = Text("SlugDex",
    style: TextStyle(
      fontFamily: "PocketMonk",
      fontSize: 80.0,
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

class profilePic extends StatefulWidget {
  @override
  State<profilePic> createState() => profilePicState();
}

class profilePicState extends State<profilePic> {
  String imageUrlState = profileImageURL;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(120.0),
        clipBehavior: Clip.antiAlias,
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
          image: NetworkImage(imageUrlState),
          fit: BoxFit.cover,
        ))));
  }
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
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          color: background_color,
        ),
        child: Column(
          children: children,
        ),
      );
}
