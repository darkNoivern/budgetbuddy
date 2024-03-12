import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
  bool _loading2 = false;
  bool toggle = true;
  bool _see = false;

  final Stream<QuerySnapshot> _usersRefStream = FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {

    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

    void signup() async {
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
            message: 'Registered Successfully',

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        await usersRef.doc(FirebaseAuth.instance.currentUser?.uid).set({
          'uid': FirebaseAuth.instance.currentUser?.uid,
          'password': _passwordController.text.trim().toString(),
          'email': _emailController.text.trim().toString(),
          'notebooks': [],
          'incomeCategory': categoryList,
          'incomeTransactions': [],
          'expenseTransactions': [],
          'allTransactions': [],
          'reminders': [],
          'isAnon': false,
          'isIncomeCategorySet': false,
        });

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

    void signupanon() async {

      setState(() {
        _loading2 = true;
      });

      try {
        final UserCredential user = await _auth.signInAnonymously();

        final snackBar = await SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Congratulations!',
            message: 'Signed In Successfully',

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        await usersRef.doc(FirebaseAuth.instance.currentUser?.uid).set({
          'uid': FirebaseAuth.instance.currentUser?.uid,
          'password': '',
          'email': '',
          'notebooks': [],
          'incomeCategory': categoryList,
          'incomeTransactions': [],
          'expenseTransactions': [],
          'allTransactions': [],
          'reminders': [],
          'isAnon': true,
          'isIncomeCategorySet': false,
        });

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
        _loading2 = false;
      });

    }

    void login() async {
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
        await _auth.signInWithEmailAndPassword(
            email: _emailController.text.trim().toString(),
            password: _passwordController.text.trim().toString());

        final snackBar = await SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Congratulations!',
            message: 'LoggedIn Successfully',

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      } catch (error) {
        final snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Snap !!',
            message: '$error',

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
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
              body: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  // color: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  // margin: EdgeInsets.only(top: 128.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              setState(() {
                                toggle = true;
                              });
                            },
                            child: Container(
                                padding:
                                    EdgeInsets.only(top: 16.0, bottom: 16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: toggle
                                      ? Color(0xFF576EE0)
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: Text(
                                    'Sign-Up',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat_500',
                                        fontSize: 16.0),
                                  ),
                                )),
                          )),
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              setState(() {
                                _login = false;
                                toggle = false;
                              });
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            child: Container(
                                padding:
                                    EdgeInsets.only(top: 16.0, bottom: 16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: toggle
                                      ? Colors.transparent
                                      : Color(0xFF576EE0),
                                  // color: Color(0xFF576EE0),
                                ),
                                child: Center(
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat_500',
                                        fontSize: 16.0),
                                  ),
                                )),
                          )),
                        ],
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
                      if (toggle)
                        Container(
                          margin: EdgeInsets.only(top: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have a account ? ',
                                style: TextStyle(
                                    fontFamily: 'Montserrat_500',
                                    color: Colors.white),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    toggle = false;
                                  });
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Color(0xFF576EE0),
                                      fontFamily: 'Montserrat_600'),
                                ),
                              )
                            ],
                          ),
                        ),
                      if (toggle)
                        Container(
                          margin: EdgeInsets.only(top: 24.0),
                          child: InkWell(
                            onTap: () {
                              signup();
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
                                  'Sign-Up',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Montserrat_600',
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (toggle)
                        Container(
                          margin: EdgeInsets.only(top: 24.0),
                          child: Text(
                            '- OR -',
                            style: TextStyle(
                                fontFamily: 'Montserrat_500',
                                color: Colors.white),
                            ),
                        ),
                      if (toggle)
                        Container(
                          margin: EdgeInsets.only(top: 24.0),
                          child: InkWell(
                            onTap: () {
                              signupanon();
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
                                child: _loading2
                                    ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                    : Text(
                                  'Sign-In as Guest',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Montserrat_600',
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (!toggle)
                        Container(
                          margin: EdgeInsets.only(top: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have a account ? ",
                                style: TextStyle(
                                    fontFamily: 'Montserrat_500',
                                    color: Colors.white),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    toggle = true;
                                  });
                                },
                                child: Text(
                                  'Sign-Up',
                                  style: TextStyle(
                                      color: Color(0xFF576EE0),
                                      fontFamily: 'Montserrat_600'),
                                ),
                              )
                            ],
                          ),
                        ),
                      if (!toggle)
                        Container(
                          margin: EdgeInsets.only(top: 24.0),
                          child: InkWell(
                            onTap: () {
                              login();
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
                                          'Login',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Montserrat_600'),
                                        )),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class Categories {
  final String name;
  final bool showCross;
  Categories({required this.name, required this.showCross});
}
