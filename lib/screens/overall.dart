import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Overall extends StatefulWidget {
  const Overall({Key? key}) : super(key: key);

  @override
  State<Overall> createState() => _OverallState();
}

class _OverallState extends State<Overall> {
  int tabIndex = 0;
  String _category = '';

  bool _showDropdown = false;


  String description = "Overall Summary";

  List<dynamic> remCategories = [];
  // List<dynamic> transactions = [];

  final List<ChartData> chartData = [
    ChartData('David', 25, const Color.fromRGBO(9, 0, 136, 1)),
    ChartData('Steve', 38, const Color.fromRGBO(147, 0, 119, 1)),
    ChartData('Jack', 34, const Color.fromRGBO(228, 0, 124, 1)),
    ChartData('Others', 52, const Color.fromRGBO(255, 189, 57, 1))
  ];

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _amountController = new TextEditingController();
  TextEditingController _reasonController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();

  DateTime startDate = DateTime(2001);
  bool _start = false;
  bool _end = false;
  DateTime endDate = DateTime(2030);
  DateTime currDate = DateTime(2000);

  List<Color> colors = [
    Color.fromARGB(255, 255, 0, 0), // red
    Color.fromARGB(255, 0, 255, 0), // green
    Color.fromARGB(255, 0, 0, 255), // blue
    Color.fromARGB(255, 255, 165, 0), // orange
    Color.fromARGB(255, 128, 0, 128) // purple
  ];
  // List<dynamic> _transactions = [];

  @override
  Widget build(BuildContext context) {
    final name = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser?.uid.toString())
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {

            //  INITIALIZATIONS
            List<dynamic> firebaseIncomeCategories = snapshot.data?['incomeCategory'];

            List<dynamic> firebasetransactions = snapshot.data?['allTransactions'];
            List<dynamic> firebaseexpensetransactions = snapshot.data?['expenseTransactions'];
            List<dynamic> firebaseincometransactions = snapshot.data?['incomeTransactions'];

            List<dynamic> firebaseExpenseSuperCategories = snapshot.data?['notebooks'];
            List<dynamic> firebaseIncomeSuperCategories = snapshot.data?['incomeCategory'];

            //  SET STATES
            List<dynamic> transactions = snapshot.data?['allTransactions'].where((element) => (
                (remCategories.contains(element['category']) == false) &&
                    (DateTime.fromMillisecondsSinceEpoch(element['fulldate'].seconds*1000).isAfter(startDate)) &&
                    (DateTime.fromMillisecondsSinceEpoch(element['fulldate'].seconds*1000).isBefore(endDate.add(Duration(days: 1))))
            )).toList();

            List<dynamic> expensetransactions = snapshot.data?['expenseTransactions'].where((element) => (
                // (remCategories.contains(element['category']) == false) &&
                    (DateTime.fromMillisecondsSinceEpoch(element['fulldate'].seconds*1000).isAfter(startDate)) &&
                    (DateTime.fromMillisecondsSinceEpoch(element['fulldate'].seconds*1000).isBefore(endDate.add(Duration(days: 1))))
            )).toList();

            List<dynamic> incometransactions = snapshot.data?['incomeTransactions'].where((element) => (
                // (remCategories.contains(element['category']) == false) &&
                    (DateTime.fromMillisecondsSinceEpoch(element['fulldate'].seconds*1000).isAfter(startDate)) &&
                    (DateTime.fromMillisecondsSinceEpoch(element['fulldate'].seconds*1000).isBefore(endDate.add(Duration(days: 1))))
            )).toList();

            Map<String, dynamic> expenses = (expensetransactions.isNotEmpty) ? expensetransactions.reduce((value, element){
              return {
                'amount': int.parse(value['amount'].toString()) + int.parse(element['amount'].toString()),
              };
            }) : {'amount': 0};

            Map<String, dynamic> income = (incometransactions.isNotEmpty) ? incometransactions.reduce((value, element){
              return {
                'amount': int.parse(value['amount'].toString()) + int.parse(element['amount'].toString()),
              };
            }) : {'amount': 0};

            List<int> incomeResult = (incometransactions.isNotEmpty) ? List.generate(firebaseIncomeSuperCategories.length, (i) => incometransactions.where((t) => (t['superiorcategory'] == firebaseIncomeSuperCategories[i])).fold(0, (sum, t) => sum + int.parse(t['amount'].toString()))) : List.filled(firebaseIncomeSuperCategories.length, 0);

            List<ChartData> newIncomeChartData = List
                .generate(firebaseIncomeSuperCategories.length, (i) => ChartData(firebaseIncomeSuperCategories[i],incomeResult[i],colors[i]));

            List<int> expenseResult = (expensetransactions.isNotEmpty) ? List.generate(firebaseExpenseSuperCategories.length, (i) => expensetransactions.where((t) => (t['superiorcategory'] == firebaseExpenseSuperCategories[i])).fold(0, (sum, t) => sum + int.parse(t['amount'].toString()))) : List.filled(firebaseExpenseSuperCategories.length, 0);

            List<ChartData> newExpenseChartData = List
                .generate(firebaseExpenseSuperCategories.length, (i) => ChartData(firebaseExpenseSuperCategories[i],expenseResult[i],colors[i]));


            return GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: SafeArea(
                  // top: false,
                  child: ClipRect(
                    child: Scaffold(
                      backgroundColor: Color(0xFF161927),
                      extendBody: true,
                      body: SingleChildScrollView(
                        child: Container(
                            margin: EdgeInsets.only(top: 24.0, bottom: 32.0),
                            padding: EdgeInsets.only(left: 12.0, right: 12.0),
                            child: Column(children: [
                              //  hEADINGS & tIMELINE
                              Row(
                                children: [
                                  Expanded(
                                            child:
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 16.0, right: 16.0),
                                              decoration: BoxDecoration(
                                                color: Color(0xFF161927),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    offset: Offset(4, 8),
                                                    blurRadius: 16,
                                                  ),
                                                ],
                                              ),
                                              height: 240,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Overall',
                                                    style: TextStyle(
                                                        fontFamily:
                                                        'Montserrat_600',
                                                        fontSize: 24,
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    '${description[0].toUpperCase() + description.substring(1)}',
                                                    style: TextStyle(
                                                        fontFamily:
                                                        'Montserrat_400',
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 16.0, right: 16.0),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF161927),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(4, 8),
                                            blurRadius: 16,
                                          ),
                                        ],
                                      ),
                                      height: 240,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Timeline',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat_600',
                                                fontSize: 24,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            'Set the timeline',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat_400',
                                                color: Colors.white),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              DateTime? dateSelected =
                                              await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2001),
                                                lastDate: DateTime(2030),
                                              );

                                              if (dateSelected != null) {
                                                setState(() {

                                                  startDate = dateSelected;

                                                  transactions = firebasetransactions
                                                      .where((element) => (
                                                      (remCategories.contains(element['category']) == false) &&
                                                          (DateTime.fromMillisecondsSinceEpoch(element['fulldate'].seconds*1000).isAfter(dateSelected)) &&
                                                          (DateTime.fromMillisecondsSinceEpoch(element['fulldate'].seconds*1000).isBefore(endDate.add(Duration(days: 1))))
                                                  )).toList();

                                                  expenses = (transactions.length > 0) ? transactions.reduce((value, element){
                                                    return {
                                                      'amount': int.parse(value['amount'].toString()) + int.parse(element['amount'].toString()),
                                                    };
                                                  }) : {'amount': 0};

                                                  _start = true;
                                                });
                                              }
                                            },
                                            child: Container(
                                              width: 175.0,
                                              margin:
                                              EdgeInsets.only(top: 16.0),
                                              padding: EdgeInsets.only(
                                                  top: 16.0,
                                                  right: 24.0,
                                                  bottom: 16.0,
                                                  left: 24.0),
                                              child: Center(
                                                child: Text(
                                                  _start
                                                      ? '${startDate.day}/${startDate.month}/${startDate.year}'
                                                      : 'Start Date',
                                                  style: TextStyle(
                                                      fontFamily:
                                                      'Montserrat_600',
                                                      color: Colors.white),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(8.0),
                                                border: Border.all(
                                                    color: Colors.white),
                                                color: Color(0xFF1D2135),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              DateTime? dateSelected =
                                              await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2001),
                                                lastDate: DateTime(2030),
                                              );

                                              if (dateSelected != null) {
                                                setState(() {

                                                  endDate = dateSelected;

                                                  transactions = firebasetransactions
                                                      .where((element) => (
                                                      (remCategories.contains(element['category']) == false) &&
                                                          (DateTime.fromMillisecondsSinceEpoch(element['fulldate'].seconds*1000).isAfter(startDate)) &&
                                                          (DateTime.fromMillisecondsSinceEpoch(element['fulldate'].seconds*1000).isBefore(dateSelected.add(Duration(days: 1))))
                                                  )).toList();

                                                  expenses = (transactions.length > 0) ? transactions.reduce((value, element){
                                                    return {
                                                      'amount': int.parse(value['amount'].toString()) + int.parse(element['amount'].toString()),
                                                    };
                                                  }) : {'amount': 0};

                                                  _end = true;
                                                });
                                              }
                                            },
                                            child: Container(
                                              width: 175.0,
                                              margin:
                                              EdgeInsets.only(top: 16.0),
                                              padding: EdgeInsets.only(
                                                  top: 16.0,
                                                  right: 24.0,
                                                  bottom: 16.0,
                                                  left: 24.0),
                                              child: Center(
                                                child: Text(
                                                  _end
                                                      ? '${endDate.day}/${endDate.month}/${endDate.year}'
                                                      : 'End Date',
                                                  style: TextStyle(
                                                      fontFamily:
                                                      'Montserrat_600',
                                                      color: Colors.white),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(8.0),
                                                border: Border.all(
                                                    color: Colors.white),
                                                color: Color(0xFF1D2135),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              SizedBox(
                                height: 48.0,
                              ),

                              //  TABS
                              Container(
                                padding: EdgeInsets.only(bottom: 48.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              tabIndex = 0;
                                            });
                                          },
                                          child: Container(
                                            height: 52.0,
                                            decoration: BoxDecoration(
                                              color: (tabIndex == 0)
                                                  ? Color(0xFF576EE0)
                                                  : Color(0xFF1D2135),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(32),
                                                  bottomLeft:
                                                  Radius.circular(32)),
                                            ),
                                            child: Center(
                                                child: Text(
                                                  'Balance',
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat_600',
                                                      color: Colors.white),
                                                )),
                                          ),
                                        )),
                                    Expanded(
                                        flex: 4,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {

                                              tabIndex = 1;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: (tabIndex == 1)
                                                    ? Color(0xFF576EE0)
                                                    : Color(0xFF1D2135),
                                                border: Border(
                                                    right: BorderSide(
                                                        width: 1.0,
                                                        color: Color(0xFFBABCC4)),
                                                    left: BorderSide(
                                                        width: 1.0,
                                                        color:
                                                        Color(0xFFBABCC4)))),
                                            height: 52.0,
                                            child: Center(
                                                child: Text(
                                                  'Transactions',
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat_600',
                                                      color: Colors.white),
                                                )),
                                          ),
                                        )),
                                    Expanded(
                                        flex: 3,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              tabIndex = 2;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: (tabIndex == 2)
                                                    ? Color(0xFF576EE0)
                                                    : Color(0xFF1D2135),

                                                borderRadius: BorderRadius.only(
                                                    topRight: Radius.circular(32),
                                                    bottomRight:
                                                    Radius.circular(32)),
                                              ),
                                            height: 52.0,
                                            child: Center(
                                                child: Text(
                                                  'Manage',
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat_600',
                                                      color: Colors.white),
                                                )),
                                          ),
                                        )),
                                  ],
                                ),
                              ),

                              if (tabIndex == 0)
                                Container(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Balance',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat_600',
                                            color: Colors.white,
                                            fontSize: 24.0),
                                      ),
                                      Text(
                                        'Get details of current balance here',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat_400',
                                            color: Colors.white),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(top: 32.0),
                                          height: 175,
                                          color: Color(0xFF1D2135),
                                          child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Text(
                                                    'Income',
                                                    style: TextStyle(
                                                        fontFamily:
                                                        'Montserrat_600',
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                  Text(
                                                    ':',
                                                    style: TextStyle(
                                                        fontFamily:
                                                        'Montserrat_600',
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                  Text(
                                                    "₹${income['amount']}",
                                                    style: TextStyle(
                                                        fontFamily:
                                                        'Montserrat_600',
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              ))),
                                      // SizedBox(height: 16.0,),
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 24.0, bottom: 32.0),
                                          height: 175,
                                          color: Color(0xFF1D2135),
                                          child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Text(
                                                    'Expenditure',
                                                    style: TextStyle(
                                                        fontFamily:
                                                        'Montserrat_600',
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                  Text(
                                                    ':',
                                                    style: TextStyle(
                                                        fontFamily:
                                                        'Montserrat_600',
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                  Text(
                                                    "₹${expenses['amount']}",
                                                    style: TextStyle(
                                                        fontFamily:
                                                        'Montserrat_600',
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              ))),
                                    ],
                                  ),
                                ),

                              if (tabIndex == 1)
                                Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Text(
                                          'Transactions',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat_600',
                                              color: Colors.white,
                                              fontSize: 24.0),
                                        ),
                                      ),
                                      Text(
                                        'Get details of past transactions here',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat_400',
                                            color: Colors.white),
                                      ),
                                      // Container(
                                      //     margin: EdgeInsets.only(
                                      //         top: 56.0, bottom: 12.0),
                                      //     child: Text(
                                      //       'Categories',
                                      //       style: TextStyle(
                                      //           fontFamily: 'Montserrat_600',
                                      //           color: Colors.white,
                                      //           fontSize: 20.0),
                                      //     )),
                                    ],
                                  ),
                                ),

                              // if (tabIndex == 1)
                              //   ListView.builder(
                              //       shrinkWrap: true,
                              //       physics: NeverScrollableScrollPhysics(),
                              //       itemCount: firebaseIncomeCategories.length,
                              //       itemBuilder: (context, index) {
                              //         return InkWell(
                              //           onTap: () {
                              //             List<dynamic> newRemCategories =
                              //                 remCategories;
                              //             if (newRemCategories.contains(
                              //                 firebaseIncomeCategories[index])) {
                              //               newRemCategories.removeWhere(
                              //                       (element) =>
                              //                   element ==
                              //                       firebaseIncomeCategories[index]);
                              //             } else {
                              //               newRemCategories
                              //                   .add(firebaseIncomeCategories[index]);
                              //             }
                              //             setState(() {
                              //               remCategories = newRemCategories;
                              //               transactions = firebasetransactions
                              //                   .where((element) => (
                              //                   (remCategories.contains(element['category']) == false) &&
                              //                       (DateTime.fromMillisecondsSinceEpoch(element['fulldate'].seconds*1000).isAfter(startDate)) &&
                              //                       (DateTime.fromMillisecondsSinceEpoch(element['fulldate'].seconds*1000).isBefore(endDate.add(Duration(days: 1))))
                              //               )).toList();
                              //
                              //
                              //               expenses = (transactions.length > 0) ? transactions.reduce((value, element){
                              //                 return {
                              //                   'amount': int.parse(value['amount'].toString()) + int.parse(element['amount'].toString()),
                              //                 };
                              //               }) : {'amount': 0};
                              //
                              //             });
                              //           },
                              //           child: Container(
                              //             margin: EdgeInsets.only(top: 8.0),
                              //             height: 52,
                              //             decoration: BoxDecoration(
                              //               borderRadius:
                              //               BorderRadius.circular(8.0),
                              //               color: ((!remCategories.contains(
                              //                   firebaseIncomeCategories[index]))
                              //                   ? Color(0xFF576EE0)
                              //                   : Color(0xFF1D2135)),
                              //             ),
                              //             child: Center(
                              //               child: Text(
                              //                 // 'hi',
                              //                 '${firebaseIncomeCategories[index]}',
                              //                 style: TextStyle(
                              //                     fontSize: 16.0,
                              //                     fontFamily: 'Montserrat_600',
                              //                     color: Colors.white),
                              //               ),
                              //             ),
                              //           ),
                              //         );
                              //       }),

                              if(tabIndex == 1)
                                SizedBox(height: 32.0,),

                              if (tabIndex == 1)
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: transactions.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          if (index == 0 ||
                                              (DateTime.fromMillisecondsSinceEpoch(
                                                  transactions[index-1]['fulldate']
                                                      .seconds *
                                                      1000)
                                                  .day !=
                                                  DateTime.fromMillisecondsSinceEpoch(
                                                      transactions[index]['fulldate']
                                                          .seconds *
                                                          1000)
                                                      .day) ||
                                              (DateTime.fromMillisecondsSinceEpoch(
                                                  transactions[index-1]
                                                  [
                                                  'fulldate']
                                                      .seconds *
                                                      1000)
                                                  .month !=
                                                  DateTime.fromMillisecondsSinceEpoch(
                                                      transactions[index]
                                                      [
                                                      'fulldate']
                                                          .seconds *
                                                          1000)
                                                      .month) ||
                                              (DateTime.fromMillisecondsSinceEpoch(
                                                  transactions[index-1]
                                                  ['fulldate']
                                                      .seconds *
                                                      1000)
                                                  .year !=
                                                  DateTime.fromMillisecondsSinceEpoch(
                                                      transactions[index]
                                                      ['fulldate']
                                                          .seconds *
                                                          1000)
                                                      .year))
                                            Container(
                                              child: Text(
                                                '${DateTime.fromMillisecondsSinceEpoch(transactions[index]['fulldate'].seconds * 1000).day}/${DateTime.fromMillisecondsSinceEpoch(transactions[index]['fulldate'].seconds * 1000).month}/${DateTime.fromMillisecondsSinceEpoch(transactions[index]['fulldate'].seconds * 1000).year}',
                                                style: TextStyle(
                                                    fontFamily:
                                                    'Montserrat_400',
                                                    color: Colors.white,
                                                    fontSize: 16.0),
                                              ),
                                              padding: EdgeInsets.symmetric(vertical: 8.0),
                                            ),

                                          Container(
                                            margin: EdgeInsets.only(
                                                bottom: 16.0),
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  offset: Offset(4, 8),
                                                  blurRadius: 16,
                                                ),
                                              ],
                                            ),
                                            child: FlipCard(
                                              fill: Fill.fillBack,
                                              // Fill the back side of the card to make in the same size as the front.
                                              direction: FlipDirection
                                                  .HORIZONTAL,
                                              // default
                                              front: Container(
                                                padding:
                                                EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                    horizontal: 16.0),
                                                decoration: BoxDecoration(
                                                    color:
                                                    Color(0xFF1D2135),
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        4.0)),
                                                height: 88,
                                                alignment:
                                                Alignment.center,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          child: Icon(
                                                            // Icons.delete_rounded,
                                                            Icons
                                                                .auto_delete_outlined,
                                                            // Icons.delete_outline_outlined,
                                                            size: 20,
                                                            color: Color(
                                                                0xFF576EE0),
                                                          ),
                                                          onTap: () {

                                                            if(transactions[index]['type']=="expense"){

                                                              dynamic toDelete = transactions[index];

                                                              List<dynamic> changeAllTransactions = firebasetransactions.where((element) => (element['fulldate'] != transactions[index]['fulldate'])).toList();
                                                              List<dynamic> changeExpenseTransactions = firebaseexpensetransactions.where((element) => (element['fulldate'] != transactions[index]['fulldate'])).toList();

                                                              FirebaseFirestore.instance
                                                                  .collection('users')
                                                                  .doc(FirebaseAuth
                                                                  .instance.currentUser?.uid
                                                                  .toString()).update({
                                                                "allTransactions": changeAllTransactions,
                                                                "expenseTransactions": changeExpenseTransactions,
                                                              });

                                                              updateDB(toDelete);
                                                            }
                                                            else{
                                                              dynamic toDelete = transactions[index];

                                                              List<dynamic> changeAllTransactions = firebasetransactions.where((element) => (element['fulldate'] != transactions[index]['fulldate'])).toList();
                                                              List<dynamic> changeIncomeTransactions = firebaseincometransactions.where((element) => (element['fulldate'] != transactions[index]['fulldate'])).toList();

                                                              FirebaseFirestore.instance
                                                                  .collection('users')
                                                                  .doc(FirebaseAuth
                                                                  .instance.currentUser?.uid
                                                                  .toString()).update({
                                                                "allTransactions": changeAllTransactions,
                                                                "incomeTransactions": changeIncomeTransactions,
                                                              });
                                                            }



                                                          },
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                                decoration: BoxDecoration(
                                                                    color: Color(
                                                                        0xFF161927),
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        16)),
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                    6,
                                                                    horizontal:
                                                                    12),
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                      12,
                                                                      width:
                                                                      12,
                                                                      margin: EdgeInsets.only(
                                                                          right:
                                                                          4.0),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius:
                                                                          BorderRadius.circular(6),
                                                                          color: transactions[index]['type'] == "income" ? Colors.greenAccent : Colors.deepOrange),
                                                                    ),
                                                                    Text(
                                                                      // "${snapshot.data?.data?['transactions'][index].amount}",
                                                                      '${transactions[index]['type']}',
                                                                      style: TextStyle(
                                                                          color:
                                                                          Color(0xFFBABCC4),
                                                                          fontFamily: 'Montserrat_400'),
                                                                    )
                                                                  ],
                                                                )),
                                                            Container(
                                                                decoration: BoxDecoration(
                                                                    color: Color(
                                                                        0xFF161927),
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        16)),
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                    6,
                                                                    horizontal:
                                                                    12),
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                      12,
                                                                      width:
                                                                      12,
                                                                      margin: EdgeInsets.only(
                                                                          right:
                                                                          4.0),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius:
                                                                          BorderRadius.circular(6),
                                                                          color: Color(
                                                                              0xFF576EE0)),
                                                                    ),
                                                                    Text(
                                                                      // "${snapshot.data?.data?['transactions'][index].amount}",
                                                                      '${transactions[index]['superiorcategory']}',
                                                                      style: TextStyle(
                                                                          color:
                                                                          Color(0xFFBABCC4),
                                                                          fontFamily: 'Montserrat_400'),
                                                                    )
                                                                  ],
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 12.0,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          '${transactions[index]['reason']}',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontFamily:
                                                              'Montserrat_400',
                                                              fontSize:
                                                              16.0),
                                                        ),
                                                        Text(
                                                          '₹${transactions[index]['amount']}',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontFamily:
                                                              'Montserrat_400',
                                                              fontSize:
                                                              16.0),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              back: SingleChildScrollView(
                                                child: Container(
                                                    height: 88,
                                                    color:
                                                    Color(0xFF1D2135),
                                                    // alignment: Alignment.center,
                                                    padding: EdgeInsets
                                                        .symmetric(
                                                        vertical: 8.0,
                                                        horizontal:
                                                        16.0),
                                                    child: Text(
                                                      '${transactions[index]['description']}',
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFFBABCC4),
                                                          fontFamily:
                                                          'Montserrat_400'),
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),

                              if (tabIndex == 2)
                                SfCircularChart(
                                  // title: ChartTitle(text: 'Sales by sales person'),

                                    title: ChartTitle(text: 'Income',textStyle: TextStyle(fontFamily: 'Montserrat_600', fontSize: 20, color: Colors.white)),
                                    legend: Legend(isResponsive: true,

                                      isVisible: true,
                                      textStyle: TextStyle(fontFamily: 'Montserrat_400', fontSize: 12, color: Colors.white),
                                      title: LegendTitle(text: 'Categories', textStyle: TextStyle(fontFamily: 'Montserrat_600', fontSize: 16, color: Colors.white)),
                                    ),
                                    series: <CircularSeries>[
                                      // Renders doughnut chart
                                      DoughnutSeries<ChartData, String>(
                                        // explode: true,
                                        // explodeIndex: 0,
                                        // dataSource: chartData,
                                          dataSource: newIncomeChartData,
                                          // pointColorMapper: (ChartData data, _) =>
                                          //     data.color,
                                          xValueMapper: (ChartData data, _) =>
                                          data.x,
                                          yValueMapper: (ChartData data, _) =>
                                          data.y,
                                          dataLabelSettings:
                                          const DataLabelSettings(
                                            showZeroValue: false,
                                            textStyle: TextStyle(fontFamily: 'Montserrat_400', fontSize: 12),
                                            isVisible: true,
                                            useSeriesColor: false,
                                          ))
                                    ]),

                              if (tabIndex == 2)
                                SfCircularChart(
                                  // title: ChartTitle(text: 'Sales by sales person'),

                                    title: ChartTitle(text: 'Expense',textStyle: TextStyle(fontFamily: 'Montserrat_600', fontSize: 20, color: Colors.white)),
                                    legend: Legend(isResponsive: true,

                                      isVisible: true,
                                      textStyle: TextStyle(fontFamily: 'Montserrat_400', fontSize: 12, color: Colors.white),
                                      title: LegendTitle(text: 'Categories', textStyle: TextStyle(fontFamily: 'Montserrat_600', fontSize: 16, color: Colors.white)),
                                    ),
                                    series: <CircularSeries>[
                                      // Renders doughnut chart
                                      DoughnutSeries<ChartData, String>(
                                        // explode: true,
                                        // explodeIndex: 0,
                                        // dataSource: chartData,
                                          dataSource: newExpenseChartData,
                                          // pointColorMapper: (ChartData data, _) =>
                                          //     data.color,
                                          xValueMapper: (ChartData data, _) =>
                                          data.x,
                                          yValueMapper: (ChartData data, _) =>
                                          data.y,
                                          dataLabelSettings:
                                          const DataLabelSettings(
                                            showZeroValue: false,
                                            textStyle: TextStyle(fontFamily: 'Montserrat_400', fontSize: 12),
                                            isVisible: true,
                                            useSeriesColor: false,
                                          ))
                                    ]),

                              //  CHILD SCREEN WIDGETS
                            ])),
                      ),
                    ),
                  ),
                ));
          } else {
            return  Scaffold(
              backgroundColor: Color(0xFF161927),
              body: Center(child: CircularProgressIndicator(color: Colors.white)),
            );
          }
        });
  }

  getData() {
    String strUserName = _usernameController.text;
    print('Your UserName $strUserName');
  }

  Future<void> updateDB(dynamic transaction) async {

    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth
          .instance.currentUser?.uid
          .toString())
          .collection("notebooks")
          .doc(transaction['superiorcategory'])
          .get();

      if (docSnapshot.exists) {

        dynamic userData = docSnapshot.data();

        debugPrint(userData['transactions'].toString());
        List<dynamic> updateTransactions = userData['transactions'].where((element) => (element['fulldate'] != transaction['fulldate'])).toList();

        debugPrint(updateTransactions.toString());

        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth
            .instance.currentUser?.uid
            .toString())
            .collection("notebooks")
            .doc(transaction['superiorcategory'])
            .update({
          "transactions": updateTransactions,
        });
      }

    } catch (e) {
      print('Error updating main collection: $e');
    }
  }


}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final int y;
  final Color color;
}