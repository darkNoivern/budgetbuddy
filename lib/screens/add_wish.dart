import 'dart:math';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../notification.dart';

class AddWish extends StatefulWidget {
  const AddWish({Key? key}) : super(key: key);

  @override
  State<AddWish> createState() => _AddWishState();
}

class _AddWishState extends State<AddWish> {

    TextEditingController _billNameController = new TextEditingController();
    TextEditingController _amountController = new TextEditingController();
    DateTime _dueDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 23, 59, 59);

    @override
    Widget build(BuildContext context) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser?.uid.toString())
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
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
                          // height: (MediaQuery.of(context).size.height ),
                          // color: Colors.white,
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 128.0),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Montserrat_600',
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'New Wish',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Montserrat_600',
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 32.0),
                                child:
                                TextField(
                                  controller: _billNameController,
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    hintText: 'Example : Buy a car',
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Montserrat_400'),
                                    labelText: 'Title',
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
                                      Icons.description_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                  textAlign: TextAlign.left,
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.sentences,
                                  // keyboardAppearance: ,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontFamily: 'Montserrat_400'
                                  ),
                                ),
                              ),

                              SizedBox(height: 16.0,),
                              Container(
                                child: TextField(
                                  maxLines: 5,
                                  controller: _amountController,
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    hintText: 'What you actually want to do',
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Montserrat_400'),
                                    labelText: 'Description',
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
                                    // prefixIcon: Icon(
                                    //   Icons.description_outlined,
                                    //   color: Colors.white,
                                    // ),
                                  ),
                                  textAlign: TextAlign.left,
                                  // keyboardType: TextInputType.number,
                                  textCapitalization: TextCapitalization.sentences,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontFamily: 'Montserrat_400'
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 16.0,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 24.0),
                                child: InkWell(
                                  child: Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Color(0xFF576EE0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontFamily: 'Montserrat_600',
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  onTap: () {

                                    if(_billNameController.text.trim().isEmpty){
                                      final snackBar = SnackBar(
                                        /// need to set following properties for best effect of awesome_snackbar_content
                                        elevation: 0,
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        content: AwesomeSnackbarContent(
                                          title: 'Snap!',
                                          message: 'Please fill out the title !!',
                                          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                          contentType: ContentType.failure,
                                        ),
                                      );

                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(snackBar);
                                      return ;
                                    }

                                    if(_amountController.text.trim().isEmpty){
                                      final snackBar = SnackBar(
                                        /// need to set following properties for best effect of awesome_snackbar_content
                                        elevation: 0,
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        content: AwesomeSnackbarContent(
                                          title: 'Snap !!',
                                          message: 'Please fill out description !!',
                                          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                          contentType: ContentType.failure,
                                        ),
                                      );

                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(snackBar);
                                      return ;
                                    }

                                    // var rng = new Random();
                                    // int randomNumber =
                                    //     rng.nextInt(900000) + 100000;
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth.instance.currentUser?.uid
                                        .toString())
                                        .update({
                                      'wishes': FieldValue.arrayUnion([
                                        {
                                          'title': _billNameController.text.trim().toString(),
                                          'description': _amountController.text.trim().toString(),
                                          'createdAt': Timestamp.now(),
                                        }
                                      ])
                                    });

                                    // DateTime scheduleTime = DateTime(_dueDate.year, _dueDate.month, _dueDate.day, 8, 0, 0);
                                    // debugPrint('Notification Scheduled for $scheduleTime');
                                    // if(DateTime.now().isBefore(scheduleTime.subtract(const Duration(days: 3)))){
                                    //   debugPrint('Notification Scheduled for ${scheduleTime.subtract(const Duration(days: 3))}');
                                    //   NotificationService().scheduleNotification(
                                    //       title: 'Pending Bills',
                                    //       body: 'Reminder: Your ${_billNameController.text.toString().trim()} is due in 3 days. Please make a payment to avoid any disruption in your service',
                                    //       scheduledNotificationDateTime: scheduleTime.subtract(const Duration(days: 3)));
                                    // }
                                    //
                                    // if(DateTime.now().isBefore(scheduleTime)) {
                                    //   debugPrint('Notification Scheduled for $scheduleTime');
                                    //   NotificationService().scheduleNotification(
                                    //       title: 'Pending Bills',
                                    //       body: 'Your ${_billNameController.text.toString().trim()} is due today. Make a payment now to avoid late fees and any interruption in service.',
                                    //       scheduledNotificationDateTime: scheduleTime);
                                    // }

                                    _amountController.clear();
                                    _billNameController.clear();
                                    setState(() {
                                      _dueDate = DateTime.now();
                                    });

                                    final snackBar = SnackBar(
                                      /// need to set following properties for best effect of awesome_snackbar_content
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: 'Hi User!',
                                        message: 'Your wish was successfully',
                                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                        contentType: ContentType.success,
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);

                                    Navigator.pop(context);

                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      )));
            } else {
              return  Scaffold(
                backgroundColor: Color(0xFF161927),
                body: Center(child: CircularProgressIndicator(color: Colors.white)),
              );
            }
          });
  }
}
