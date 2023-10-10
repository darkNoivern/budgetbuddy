import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:budgetbuddy/screens/add_bill.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Color _color1 = Color(0xFF161927);
  Color _color2 = Color(0xFF576EE0);
  bool _loading = false;
  Map<String, dynamic>? paymentIntent;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser?.uid.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<dynamic> firebasebills = snapshot.data?['bills'];
            return Scaffold(
              backgroundColor: _color1,
              body: SingleChildScrollView(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  child: Column(
                    children: [
                      Text(
                        'Pending Bills',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat_500',
                            fontSize: 24),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 16),
                          child: Text(
                            'Pay them now',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat_400'),
                          )),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: firebasebills.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Color(0xFF1D2135),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0),
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.money,
                                      color: Color(0xFF576EE0),
                                    )),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${firebasebills[index]['name']}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Montserrat_600'),
                                      ),
                                      SizedBox(
                                        height: 2.0,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'ID: ${firebasebills[index]['id']}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Montserrat_400',
                                                fontSize: 12),
                                          ),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          Text(
                                            'Date : ${DateTime.fromMillisecondsSinceEpoch(firebasebills[index]['dueDate'].seconds * 1000).day}/${DateTime.fromMillisecondsSinceEpoch(firebasebills[index]['dueDate'].seconds * 1000).month}/${DateTime.fromMillisecondsSinceEpoch(firebasebills[index]['dueDate'].seconds * 1000).year}',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'Montserrat_400',
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  // onTap: () async {
                                  //   await makePayment(index, firebasebills);
                                  // },
                                  onTap: () {
                                    List<dynamic> newarr = firebasebills;
                                    newarr.remove(firebasebills[index]);
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser?.uid
                                            .toString())
                                        .update({"bills": newarr});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: _color2,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 24),
                                    child: _loading
                                        ? CircularProgressIndicator()
                                        : Text(
                                            // 'Pay ${firebasebills[index]['amount']}',
                                            'Paid',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat_400',
                                                color: Colors.white),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 16,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: Container(
                child: FloatingActionButton(
                    backgroundColor: Color(0xFF576EE0),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddBill()),
                      );
                    },
                    child: Icon(Icons.paypal)),
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

  Future<void> makePayment(int index, List<dynamic> bills) async {
    try {
      paymentIntent =
          await createPaymentIntent('${bills[index]['amount']}', 'INR');
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  applePay: const PaymentSheetApplePay(
                    merchantCountryCode: '+91',
                  ),
                  googlePay: const PaymentSheetGooglePay(
                      testEnv: true,
                      currencyCode: "INR",
                      merchantCountryCode: "+91"),
                  style: ThemeMode.dark,
                  merchantDisplayName: 'noivern'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet(index, bills);
    } catch (e, s) {
      final snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Snap!',
          message: "$e$s",

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      // print('exception:$e$s');
    }
  }

  displayPaymentSheet(int index, List<dynamic> bills) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        final snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Congratulations!',
            message: 'Payment Successfull',

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        // showDialog(
        //     context: context,
        //     builder: (_) =>
        //         AlertDialog(
        //       content: Column(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           Row(
        //             children: const [
        //               Icon(Icons.check_circle, color: Colors.green,),
        //               Text("Payment Successfull"),
        //             ],
        //           ),
        //         ],
        //       ),
        //     )
        // );
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntent = null;

        List<dynamic> newarr = bills;
        newarr.remove(bills[index]);
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid.toString())
            .update({"bills": newarr});
      }).onError((error, stackTrace) {
        final snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Snap!',
            message: "$error $stackTrace",

            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        // print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));

      final snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Snap!',
          message: "$e",

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } catch (e) {
      final snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Snap!',
          message: "$e",

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'description': 'Software development services',
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51MTnCWSIUAFS1RWiXw5zWeTOtRw6hjhQoU1cj1wGs29jTXcycAE13WtqGPaoP07kRT2Z2MRnixrV4QaLP4BMu4Fy00SvWHgcs9',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}
