import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:slugdex/screens/LiveMapScreen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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

class DiscoveryAnimation extends StatelessWidget {
  final List DiscoveryMessage = <String>[
    "You Discovered A New Location!",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildAnimatedText(context),
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
        onFinished: () { // Goes to the LiveMapScreen and removes all previous navigation
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => LiveMapScreen()));
        },
      );

  buildText(int index) {
    return FadeAnimatedText(
        DiscoveryMessage[index],
        textAlign: TextAlign.center,
        textStyle: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, fontFamily: '', color: Colors.yellow,)
    );
  }
}
