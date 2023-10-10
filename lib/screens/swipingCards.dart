import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:budgetbuddy/screens/add_card.dart';

import 'package:swipe_deck/swipe_deck.dart';

class SwipingCards extends StatefulWidget {
  const SwipingCards({Key? key}) : super(key: key);

  @override
  State<SwipingCards> createState() => _SwipingCardsState();
}

class _SwipingCardsState extends State<SwipingCards> {

  List<dynamic> clrs = [
    Color.fromRGBO(228, 0, 124, 1),
    Color.fromRGBO(255, 189, 57, 1),
    Colors.teal,
    Colors.white30,
  ];

  List<dynamic> newclrs1 = [
    Colors.indigo,
    Colors.red,
    Colors.pink,
    Colors.blueGrey,
    Colors.black
  ];
  List<dynamic> newclrs2 = [
    Colors.purple,
    Colors.blue[700],
    Colors.lime,
    Colors.brown,
    Colors.indigoAccent,
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser?.uid.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> firebasecards = snapshot.data?['cards'];
            var controller = FixedExtentScrollController(
                initialItem: firebasecards.length ~/ 2);
            return Scaffold(
              appBar: AppBar(
                  elevation: 0,
                  centerTitle: true,
                  title: const Text(
                    'Your Card Wallet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'Montserrat_500',
                    ),
                  )),
              backgroundColor: Color(0xFF161927),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 16.0),
                child:

                Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: [
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            gradient: LinearGradient(
                              colors: [
                                newclrs1[index % 5],
                                newclrs2[index % 5]
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                            top: 8,
                            left: 16,
                            child: Image.asset(
                              'assets/images/piggy_bank.png',
                              height: 56,
                              width: 56,
                            )),
                        Positioned(
                            top: 68,
                            left: 16,
                            child: Text(
                              'Flutter Card',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat_600'),
                            )),
                        Positioned(
                            bottom: 84,
                            left: 16,
                            child: Text(
                              '${firebasecards[index]['cardNumber']}',
                              style: TextStyle(
                                  fontFamily: 'Montserrat_500',
                                  color: Colors.white),
                            )),
                        Positioned(
                            bottom: 56,
                            left: 16,
                            child: Row(
                              children: [
                                Text(
                                  'Expire Date : ',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat_500',
                                      color: Colors.white),
                                ),
                                Text(
                                  '${firebasecards[index]['expiryDate']}',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat_500',
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  width: 32,
                                ),
                                Text(
                                  "CVV : ",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat_500',
                                      color: Colors.white),
                                ),
                                Text(
                                  '${firebasecards[index]['cvvCode']}',
                                  style: TextStyle(
                                      fontFamily: 'Aquire',
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                                ),
                              ],
                            )),
                        Positioned(
                            top: 24,
                            left: -8,
                            child: Image.asset(
                              'assets/images/mastercard_logo.png',
                              height: 24,
                              width: 512,
                            )),
                        Positioned(
                            bottom: 28,
                            left: 16,
                            child: Row(
                              children: [
                                Text(
                                  "Card Holder : ",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat_500',
                                      color: Colors.white),
                                ),
                                Text(
                                  '${firebasecards[index]['cardHolderName']}',
                                  style: TextStyle(
                                      fontFamily: 'Aquire',
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                                ),
                              ],
                            )),
                      ],
                    );
                  },
                  itemCount: firebasecards.length,
                  itemWidth: 512.0,
                  itemHeight: 200,
                  layout: SwiperLayout.TINDER,
                ),

              ),
              // bottomNavigationBar: Container(padding: EdgeInsets.symmetric(vertical: 8.0),),
              floatingActionButton: Container(
                child: FloatingActionButton(
                    backgroundColor: Color(0xFF576EE0),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewCard()),
                      );
                    },
                    child: Icon(Icons.credit_score_rounded)),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Color(0xFF161927),
              body:
              Center(child: CircularProgressIndicator(color: Colors.white)),
            );
          }
        });
  }
}
