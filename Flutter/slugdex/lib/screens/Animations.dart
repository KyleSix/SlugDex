import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:slugdex/screens/LiveMapScreen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:zwidget/zwidget.dart';
import 'dart:math' as math;

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedSplashScreen(
          splash: Image.asset('assets/Loading.png'),
          duration: 900,
          splashIconSize: 1000,
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.transparent,
          nextScreen: LiveMapScreen()),
    );
  }
}

class DiscoveryAnimation extends StatefulWidget {
  final int id;
  DiscoveryAnimation(this.id) {}
  DiscoveryAnimationState createState() => new DiscoveryAnimationState(id);
}

class DiscoveryAnimationState extends State<StatefulWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation zRotation;
  late final Animation imgOpacity;

  final int entryID;
  final List DiscoveryMessage = <String>[
    "You Discovered \nA New Location!",
  ];
  DiscoveryAnimationState(this.entryID) {}

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 6),
    );
    zRotation = Tween<double>(begin: 0, end: (2 * math.pi) * 3)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.elasticInOut));
    imgOpacity = Tween<double>(begin: 0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
          child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top:  (MediaQuery.of(context).size.height / 2.90) - 130,
            child: Container(
              width: 225.0,
              height: 225.0,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 3.0),
                shape: BoxShape.circle,
                
              )
            )
          ),
          //// Rotating Zwidget!
          Positioned(
            top:  (MediaQuery.of(context).size.height / 2.90) - 130,
            child: ZWidget.bothDirections(
              depth: 50,
              rotationX: 0.0,
              rotationY: zRotation.value,
              layers: 5,
              midChild: Container(
                width: 225.0,
                height: 225.0,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3.0),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      opacity: imgOpacity.value,
                      fit: BoxFit.fill,
                      image: AssetImage("assets/images/${entryID}.png"),
                    )),
              ),
            ),
          ),
          
          /// Flashing text
          Positioned(top: 400, child: buildAnimatedText(context)),
        ],
      )),
    );
  }

  Widget buildAnimatedText(context) => AnimatedTextKit(
        animatedTexts: [
          for (var i = 0; i < DiscoveryMessage.length; i++) buildText(i),
        ],
        repeatForever: false,
        displayFullTextOnTap: false,
        stopPauseOnTap: false,
        onFinished: () {
          // Goes to the LiveMapScreen and removes all previous navigation
          Navigator.pop(context);
        },
      );

  buildText(int index) {
    return FadeAnimatedText(DiscoveryMessage[index],
        textAlign: TextAlign.center,
        textStyle: const TextStyle(
          fontSize: 40.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'PocketMonk',
          color: Colors.yellow,
        ));
  }
}
