import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:budgetbuddy/screens/add_notebook.dart';
import 'package:budgetbuddy/screens/notebook.dart';

import 'add_wish.dart';

class Wishlist extends StatefulWidget {
  static const files = [
    '_file1',
    '_file2',
    '_file3',
    '_file4',
    '_file5',
  ];

  const Wishlist({Key? key}) : super(key: key);

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {

  final Stream<QuerySnapshot> _usersStream =
  FirebaseFirestore.instance.collection('users').snapshots();

  Stream documentStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
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

          return Scaffold(
            extendBody: true,
            backgroundColor: Color(0xFF161927),
            body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 24.0, bottom: 32.0),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        'Wishlist',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontFamily: 'Montserrat_500',
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          'Write down your wishes',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat_400',
                          ),
                        ),
                      ),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser?.uid
                              .toString())
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<dynamic> listData =
                              snapshot.data?['wishes'];
                              return ListView.separated(
                                shrinkWrap: true,
                                reverse: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: listData.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 24.0,
                                          right: 16.0,
                                          bottom: 24.0,
                                          left: 16.0),
                                      height: 225,
                                      // width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(4.0),
                                        color: Color(0xFF1D2135),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '${listData[index]['title']}',
                                                    style: TextStyle(
                                                        fontFamily: 'Montserrat_600',
                                                        fontSize: 20,
                                                        color: Color(0xFF576EE0)),
                                                  ),
                                                  Spacer(),
                                                  InkWell(
                                                      onTap: () {
                                                        List<dynamic> newarr = listData;
                                                        newarr.remove(listData[index]);
                                                        FirebaseFirestore.instance
                                                            .collection('users')
                                                            .doc(FirebaseAuth.instance.currentUser?.uid.toString())
                                                            .update({"wishes": newarr});
                                                      },
                                                      child: Icon(Icons.clear,color: Color(0xFF576EE0))
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 24,),
                                              Text(
                                                '${listData[index]['description']}',
                                                  style: TextStyle(
                                                  fontFamily: 'Montserrat_400',
                                                  fontSize: 16,
                                                  color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    height: 24,
                                  );
                                },
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          })
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: Container(
              child: FloatingActionButton(
                  backgroundColor: Color(0xFF576EE0),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddWish()),
                    );
                  },
                  child: Icon(Icons.stars)),
            ),
          );
        });
  }
}
