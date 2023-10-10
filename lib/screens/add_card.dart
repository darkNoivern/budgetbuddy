import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/custom_card_type_icon.dart';
import 'package:flutter_credit_card/glassmorphism_config.dart';

class NewCard extends StatefulWidget {
  const NewCard({Key? key}) : super(key: key);

  @override
  State<NewCard> createState() => _NewCardState();
}

class _NewCardState extends State<NewCard> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

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
                    // resizeToAvoidBottomInset: false,
                    body: Container(
                      decoration: const BoxDecoration(
                        // image: DecorationImage(
                        //   image: ExactAssetImage('assets/bg.png'),
                        //   fit: BoxFit.fill,
                        // ),
                        color: Color(0xFF161927),
                      ),
                      child: SafeArea(
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 30,
                            ),
                            CreditCardWidget(
                              glassmorphismConfig: useGlassMorphism
                                  ? Glassmorphism.defaultConfig()
                                  : null,
                              cardNumber: cardNumber,
                              expiryDate: expiryDate,
                              cardHolderName: cardHolderName,
                              cvvCode: cvvCode,
                              bankName: 'Axis Bank',
                              frontCardBorder: !useGlassMorphism
                                  ? Border.all(color: Colors.grey)
                                  : null,
                              backCardBorder: !useGlassMorphism
                                  ? Border.all(color: Colors.grey)
                                  : null,
                              showBackView: isCvvFocused,
                              obscureCardNumber: true,
                              obscureCardCvv: true,
                              isHolderNameVisible: true,
                              cardBgColor: Color(0xFF576EE0),
                              backgroundImage: useBackgroundImage
                                  ? 'assets/images/creditbackground.jpg'
                                  : null,
                              isSwipeGestureEnabled: true,
                              onCreditCardWidgetChange:
                                  (CreditCardBrand creditCardBrand) {},
                              customCardTypeIcons: <CustomCardTypeIcon>[
                                CustomCardTypeIcon(
                                  cardType: CardType.mastercard,
                                  cardImage: Image.asset(
                                    'assets/mastercard.png',
                                    height: 48,
                                    width: 48,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    CreditCardForm(
                                      formKey: formKey,
                                      obscureCvv: true,
                                      obscureNumber: true,
                                      cardNumber: cardNumber,
                                      cvvCode: cvvCode,
                                      isHolderNameVisible: true,
                                      isCardNumberVisible: true,
                                      isExpiryDateVisible: true,
                                      cardHolderName: cardHolderName,
                                      expiryDate: expiryDate,
                                      themeColor: Colors.blue,
                                      textColor: Colors.white,
                                      cardNumberDecoration: InputDecoration(
                                        labelText: 'Number',
                                        hintText: 'XXXX XXXX XXXX XXXX',
                                        hintStyle: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat_400',
                                        ),
                                        labelStyle: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat_400',
                                        ),
                                        focusedBorder: border,
                                        enabledBorder: border,
                                      ),
                                      expiryDateDecoration: InputDecoration(
                                        hintStyle: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat_400',
                                        ),
                                        labelStyle: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat_400',
                                        ),
                                        focusedBorder: border,
                                        enabledBorder: border,
                                        labelText: 'Expired Date',
                                        hintText: 'XX/XX',
                                      ),
                                      cvvCodeDecoration: InputDecoration(
                                        hintStyle: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat_400',
                                        ),
                                        labelStyle: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat_400',
                                        ),
                                        focusedBorder: border,
                                        enabledBorder: border,
                                        labelText: 'CVV',
                                        hintText: 'XXX',
                                      ),
                                      cardHolderDecoration: InputDecoration(
                                        hintStyle: const TextStyle(
                                            color: Colors.white),
                                        labelStyle: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat_400',
                                        ),
                                        focusedBorder: border,
                                        enabledBorder: border,
                                        labelText: 'Card Holder',
                                      ),
                                      onCreditCardModelChange:
                                          onCreditCardModelChange,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          const Text(
                                            'Glassmorphism',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat_400',
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const Spacer(),
                                          Switch(
                                            value: useGlassMorphism,
                                            inactiveTrackColor: Colors.grey,
                                            activeColor: Colors.white,
                                            activeTrackColor: Color(0xFF576EE0),
                                            onChanged: (bool value) =>
                                                setState(() {
                                              useGlassMorphism = value;
                                            }),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          const Text(
                                            'Card Image',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat_400',
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const Spacer(),
                                          Switch(
                                            value: useBackgroundImage,
                                            inactiveTrackColor: Colors.grey,
                                            activeColor: Colors.white,
                                            activeTrackColor: Color(0xFF576EE0),
                                            onChanged: (bool value) =>
                                                setState(() {
                                              useBackgroundImage = value;
                                            }),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    GestureDetector(
                                      onTap: (){

                                        if(cardHolderName == "" || cardNumber == "" || cvvCode == "" || expiryDate ==""){
                                          final snackBar = SnackBar(
                                            /// need to set following properties for best effect of awesome_snackbar_content
                                            elevation: 0,
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.transparent,
                                            content: AwesomeSnackbarContent(
                                              title: 'Snap !!',
                                              message: "Fill out Holder's Name",
                                              /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                              contentType: ContentType.failure,
                                            ),
                                          );

                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(snackBar);

                                          return ;
                                        }

                                        _onValidate();
                                        },
                                        child: Container(
                                        margin: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                        color: Color(0xFF576EE0),
                                        borderRadius:
                                        BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                        width: double.infinity,
                                        alignment: Alignment.center,
                                        child: const Text(
                                        'Validate',
                                        style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat_600',
                                        fontSize: 16,
                                        // package: 'flutter_credit_card',
                                        ),
                                        )

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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

  void _onValidate() {
    if (formKey.currentState!.validate()) {
      print('valid!');

      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid
          .toString())
          .update({
        'cards': FieldValue.arrayUnion([
          {
            'cardHolderName': cardHolderName,
            'cvvCode': cvvCode,
            'cardNumber': cardNumber,
            'expiryDate': expiryDate,
          }
        ])
      });

      final snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Hi User!',
          message: 'Card added succesfully',
          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      Navigator.pop(context);
      // pushReplacement(context,
      //     MaterialPageRoute(builder: (context) => MyHomePage(title: 'Flutter Demo Home Page')
      //     ));

    } else {
      final snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Snap !!',
          message: "Inputs doesn't follow guidelines",
          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
