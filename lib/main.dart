import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'package:budgetbuddy/screens/login.dart';
import 'package:budgetbuddy/screens/splash.dart';
import 'package:budgetbuddy/wrapper.dart';

import 'firebase_options.dart';
import 'notification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationService().initNotification();
  tz.initializeTimeZones();
  Stripe.publishableKey =
  'pk_test_51MTnCWSIUAFS1RWiJuTzDBROERZ3lMIw8kZ8EpkPf8OLlyv8Z9ybiVoTZe7XzmVjtsPVobKzqWICU2UP18OM9Qk900kNhaK4hD';
  runApp(const MyApp());
}

// Converts hex string to color
class HexColor extends Color {
  static int _getColor(String hex) {
    String formattedHex = "FF" + hex.toUpperCase().replaceAll("#", "");
    return int.parse(formattedHex, radix: 16);
  }

  HexColor(final String hex) : super(_getColor(hex));
}

MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          headline1: TextStyle(fontFamily: 'Montserrat_500'),
          // bodyLarge: TextStyle(fontFamily: 'Montserrat_500'),
        ),
        snackBarTheme: SnackBarThemeData(
          contentTextStyle: TextStyle(fontFamily: "Montserrat_500"),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // visualDensity: VisualDensity.standard,
        primarySwatch: buildMaterialColor(Color(0xFF161927)),
      ),
      home: Splash(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF161927),
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Wrapper();
            } else {
              return Login();
            }
          },
        ));
  }
}
