import 'dart:async';
import 'package:fade_out_particle/fade_out_particle.dart';
import 'package:flutter/material.dart';
import 'package:random_text_reveal/random_text_reveal.dart';
import 'package:budgetbuddy/main.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MyHomePage(title: 'Flutter Demo Home Page')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF161927),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                  child: Image.asset(
                'assets/images/piggy.png',
                height: 256,
                width: 256,
              )),
            ],
          ),
          RandomTextReveal(
            text: 'BudgetBuddy',
            duration: Duration(seconds: 2),
            style: TextStyle(
                fontFamily: 'Aquire',
                fontSize: 24,
                color: Colors.white
            ),
          ),
        ],
      ),
    );
  }
}
