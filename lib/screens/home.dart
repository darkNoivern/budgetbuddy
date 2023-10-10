import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      color: Color(0xFF161927),
      child: Padding(
          padding: const EdgeInsets.only(
              top: 8.0, right: 16.0, bottom: 8.0, left: 16.0),
          child: Column(
            children: [
              Container(
                child: Text(
                  "Money moves from those who don't manage it to those who do;",
                  style: TextStyle(
                    color: Color(0xFFBABCC4),
                    fontSize: 32,
                    fontFamily: 'Montserrat_600',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                margin: EdgeInsets.only(bottom: 24),
                padding: EdgeInsets.only(top: 32, bottom: 32),
              ),
              Container(
                  height: 320,
                  width: 320,
                  padding: EdgeInsets.only(left: 72, right: 48, top: 48, bottom: 48),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/leaf.png'),
                      fit: BoxFit.contain,
                    ),
                    // color: Colors.deepPurple,
                  ),
                  child: Image.asset('assets/images/piggy.png',)),
            ],
          )),
    ),
  );
}
