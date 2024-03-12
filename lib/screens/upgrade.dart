import 'dart:math';
import 'package:budgetbuddy/screens/overall.dart';
import 'package:budgetbuddy/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class Upgrade extends StatefulWidget {
  const Upgrade({Key? key}) : super(key: key);

  @override
  State<Upgrade> createState() => _UpgradeState();
}

class _UpgradeState extends State<Upgrade> {
  bool _login = false;
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  TextEditingController _categoryController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();

  List<Categories> _list = [
    Categories(name: 'Others', showCross: false),
  ];

  List<String> categoryList = ['Others'];

  FirebaseAuth _auth = FirebaseAuth.instance;

  bool _loading = false;
  bool toggle = true;
  bool _see = false;

  final Stream<QuerySnapshot> _usersRefStream = FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {

    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

    void upgrade() async {
      if (_emailController.text.trim().isEmpty) {
        final snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Snap !!',
            message: 'Fill the email field',

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        return;
      }

      if (_passwordController.text.trim().isEmpty) {
        final snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Snap !!',
            message: 'Fill the password field',

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        return;
      }

      setState(() {
        _loading = true;
      });

      try {

        final prevuid = FirebaseAuth.instance.currentUser?.uid.toString();

        final UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim().toString(),
          password: _passwordController.text.trim().toString(),
        );

        final snackBar = await SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Congratulations!',
            message: 'Upgraded Successfully',

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        await usersRef.doc(prevuid).update({
          'password': _passwordController.text.trim().toString(),
          'email': _emailController.text.trim().toString(),
          'isAnon': false,
        });

        // Get the snapshot of the source document
        DocumentSnapshot sourceSnapshot = await FirebaseFirestore.instance.collection("users").doc(prevuid).get();

        // Check if the source document exists
        if (sourceSnapshot.exists) {
          // Get the data from the source document
          Map<String, dynamic> data = sourceSnapshot.data() as Map<String, dynamic>;

          // Write the data to the destination document
          await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid.toString()).set(data);

          await FirebaseFirestore.instance.collection("users").doc(prevuid).delete();
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Wrapper()),
        );

        print("Successfully created new user: ${user.toString()}");
      } catch (error) {
        _emailController.clear();
        _passwordController.clear();

        final snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Snap!',
            message: '$error',

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        print("Error creating new user: ${error.toString()}");
      }

      setState(() {
        _loading = false;
      });
    }

    return StreamBuilder<QuerySnapshot>(
        stream: _usersRefStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              backgroundColor: Color(0xFF161927),
              body: Center(
                  child: Text(
                    'Something went wrong',
                    style: TextStyle(
                        fontFamily: 'Montserrat_400',
                        fontSize: 24,
                        color: Colors.white),
                  )),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: Color(0xFF161927),
              body:
              Center(child: CircularProgressIndicator(color: Colors.white)),
            );
          }

          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Scaffold(
              backgroundColor: Color(0xFF161927),
              body:
              // SingleChildScrollView(
              //   child:
                Container(
                  height: MediaQuery.of(context).size.height,
                  // color: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  // margin: EdgeInsets.only(top: 128.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Upgrade your Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat_400',
                          fontSize: 24.0),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 24.0),
                        child: TextField(
                            controller: _emailController,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Montserrat_400'),
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat_400'),
                              floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                              ),
                              prefixIcon: Icon(
                                Icons.alternate_email,
                                color: Colors.white,
                              ),
                            ),
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.text,

                            // keyboardAppearance: ,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'Montserrat_400'),
                            onSubmitted: (value) {
                              // getData();
                            }),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 24.0),
                        child: TextField(
                          obscureText: !_see,
                          controller: _passwordController,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: 'Montserrat_400'),
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat_400'),
                              floatingLabelBehavior:
                              FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                              ),
                              prefixIcon: Icon(
                                Icons.password_rounded,
                                color: Colors.white,
                              ),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    bool currSee = _see;
                                    _see = !currSee;
                                  });
                                },
                                child: Icon(
                                  _see
                                      ? Icons.close
                                      : Icons.remove_red_eye_rounded,
                                  color: Colors.white,
                                ),
                              )),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.text,
                          // keyboardAppearance: ,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'Montserrat_400'),
                        ),
                      ),

                      Container(
                          margin: EdgeInsets.only(top: 24.0),
                          child: InkWell(
                            onTap: () {
                              upgrade();
                              FocusScopeNode currentFocus =
                              FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Color(0xFF576EE0),
                              ),
                              child: Center(
                                child: _loading
                                    ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                    : Text(
                                  'Upgrade Profile',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Montserrat_600',
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            // ),
          );
        });
  }
}

class Categories {
  final String name;
  final bool showCross;
  Categories({required this.name, required this.showCross});
}
