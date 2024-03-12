import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:budgetbuddy/screens/income.dart';
import 'package:budgetbuddy/screens/overall.dart';
import 'package:budgetbuddy/screens/upgrade.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

import 'package:budgetbuddy/screens/home.dart';
import 'package:budgetbuddy/screens/notebooks.dart';
import 'package:budgetbuddy/screens/onboarding.dart';

import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:iconify_flutter/icons/mdi.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isOpened = false;

  final GlobalKey<SideMenuState> _sideMenuKey = GlobalKey<SideMenuState>();
  final GlobalKey<SideMenuState> _endSideMenuKey = GlobalKey<SideMenuState>();

  final auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  var index = 1;
  final screens = [
    Home(),
    Overall(),
    Notebooks(),
    Income(),
    Upgrade(),
  ];

  toggleMenu([bool end = false]) {
    if (end) {
      final _state = _endSideMenuKey.currentState!;
      if (_state.isOpened) {
        _state.closeSideMenu();
      } else {
        _state.openSideMenu();
      }
    } else {
      final _state = _sideMenuKey.currentState!;
      if (_state.isOpened) {
        _state.closeSideMenu();
      } else {
        _state.openSideMenu();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Color _color1 = Color(0xFF161927);
    Color _color2 = Color(0xFF576EE0);

    final items = <Widget>[
      Icon(
        Icons.home,
        size: 24,
      ),
      Icon(
        Icons.pending_actions,
        size: 24,
      ),
      Icon(
        Icons.credit_score_sharp,
        size: 24,
      ),
      Icon(
        Icons.currency_rupee_rounded,
        size: 24,
      ),
      Icon(
        Icons.link_rounded,
        size: 24,
      )
    ];

    Future<bool> _getHasSeenOnboarding() async {
      final prefs = await SharedPreferences.getInstance();
      bool? hasSeenOnboarding = prefs.getBool('hasSeenOnboarding');
      if (prefs.getBool('hasSeenOnboarding') == null) {
        hasSeenOnboarding = false;
      }
      if (!hasSeenOnboarding!) {
        prefs.setBool('hasSeenOnboarding', true);
      }
      return hasSeenOnboarding;
    }

    return FutureBuilder(
      future: _getHasSeenOnboarding(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data) {
          return SideMenu(
            key: _endSideMenuKey,
            inverse: true, // end side menu
            // background: Colors.green[700],
            background: Color(0xFF576EE0),
            type: SideMenuType.slideNRotate,
            menu: Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: buildMenu(),
            ),
            onChange: (_isOpened) {
              setState(() => isOpened = _isOpened);
            },
            child: SideMenu(
              background: Color(0xFF576EE0),
              key: _sideMenuKey,
              menu: buildMenu(),
              type: SideMenuType.slideNRotate,
              onChange: (_isOpened) {
                setState(() => isOpened = _isOpened);
              },
              child: IgnorePointer(
                ignoring: isOpened,
                child: SafeArea(
                  top: false,
                  child: ClipRect(
                    child: Scaffold(
                      extendBody: true,
                      appBar: AppBar(
                        leading: IconButton(
                          icon: const Icon(Icons.menu_rounded),
                          onPressed: () => toggleMenu(),
                        ),
                        actions: [
                          IconButton(
                            icon: Iconify(
                              // Ri.logout_circle_r_line
                              // Mdi.exit_run
                              MaterialSymbols.directions_run_rounded,
                              color: Colors.white, size: 24,
                            ), // widget

                            // Icon(Icons.run_circle_outlined, size: 28,),
                            onPressed: () {
                              auth
                                  .signOut()
                                  .then((value) => {})
                                  .onError((error, stackTrace) => {
                                        // debugPrint(error);
                                      });
                            },
                          )
                        ],
                        centerTitle: true,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'BudgetBuddy',
                              style: TextStyle(
                                fontFamily: 'Montserrat_400',
                                fontSize: 16.0,
                                color: Colors.white,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Image.asset('assets/images/915.png'),
                            Container(
                                margin: EdgeInsets.only(left: 8.0),
                                height: 48,
                                width: 48,
                                child: Image.asset('assets/images/piggy.png')),
                          ],
                        ),
                      ),
                      body: screens[index],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          // return ShowCase();
          return WithBuilder();
        }
      },
    );
  }

  Widget buildMenu() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 48.0),
      child: Container(
        color: Color(0xFF576EE0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CircleAvatar(
                  //   // backgroundColor: Colors.white,
                  //   backgroundColor: Color(0xFF161927),
                  //   radius: 24.0,
                  //     child: Image.asset('assets/images/discord2.png')
                  // ),
                  randomAvatar(
                    FirebaseAuth.instance.currentUser!.uid.toString(),
                    // DateTime.now().toIso8601String(),
                    height: 48,
                    width: 48,
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    // color: Colors.black,
                    height: 20,
                    child: ListView(
                      // shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: [
                        Text(
                          "Hello, ",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat_500'),
                        ),
                        Text( (FirebaseAuth.instance.currentUser?.email != null) ?
                            "${FirebaseAuth.instance.currentUser?.email.toString()}"
                            :
                            "guest_${FirebaseAuth.instance.currentUser?.uid.toString().substring(0, 4)}",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat_600')),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  index = 0;
                });
                toggleMenu();
              },
              leading: Icon(Icons.home,
                  size: 20.0,
                  color: (index == 0) ? Color(0xFF161927) : Colors.white),
              title: Text(
                "Home",
                style: TextStyle(
                    fontFamily: 'Montserrat_500',
                    fontSize: 15,
                    color: (index == 0) ? Color(0xFF161927) : Colors.white),
              ),
              textColor: Colors.white,
              dense: true,
            ),
            ListTile(
              onTap: () {
                setState(() {
                  index = 1;
                });
                toggleMenu();
              },
              leading: Icon(Icons.monetization_on,
                  size: 20.0,
                  color: (index == 1) ? Color(0xFF161927) : Colors.white),
              title: Text(
                "Overall",
                style: TextStyle(
                    fontFamily: 'Montserrat_500',
                    fontSize: 15,
                    color: (index == 1) ? Color(0xFF161927) : Colors.white),
              ),
              textColor: Colors.white,
              dense: true,

              // padding: EdgeInsets.zero,
            ),
            ListTile(
              onTap: () {
                setState(() {
                  index = 2;
                });
                toggleMenu();
              },
              leading: Icon(Icons.dashboard_rounded,
                  size: 20.0,
                  color: (index == 2) ? Color(0xFF161927) : Colors.white),
              title: Text(
                "Notebooks",
                style: TextStyle(
                    fontFamily: 'Montserrat_500',
                    fontSize: 15,
                    color: (index == 2) ? Color(0xFF161927) : Colors.white),
              ),
              textColor: Colors.white,
              dense: true,

              // padding: EdgeInsets.zero,
            ),
            ListTile(
              onTap: () {
                setState(() {
                  index = 3;
                });
                toggleMenu();
              },
              leading: Icon(Icons.verified_user,
                  size: 20.0,
                  color: (index == 3) ? Color(0xFF161927) : Colors.white),
              title: Text(
                "Income",
                style: TextStyle(
                    fontFamily: 'Montserrat_500',
                    fontSize: 15,
                    color: (index == 3) ? Color(0xFF161927) : Colors.white),
              ),
              textColor: Colors.white,
              dense: true,

              // padding: EdgeInsets.zero,
            ),
            if(user!=null && user!.isAnonymous)
              ListTile(
                onTap: () {
                  setState(() {
                    index = 4;
                  });
                  toggleMenu();
                },
                leading: Icon(Icons.link_rounded,
                    size: 20.0,
                    color: (index == 4) ? Color(0xFF161927) : Colors.white),
                title: Text(
                  "Upgrade Profile",
                  style: TextStyle(
                      fontFamily: 'Montserrat_500',
                      fontSize: 15,
                      color: (index == 4) ? Color(0xFF161927) : Colors.white),
                ),
                textColor: Colors.white,
                dense: true,

                // padding: EdgeInsets.zero,
              ),
          ],
        ),
      ),
    );
  }
}
