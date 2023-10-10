import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Notebook extends StatefulWidget {
  const Notebook({Key? key}) : super(key: key);
  // const Notebook({super.key, required this.name});
  // final String name;

  @override
  State<Notebook> createState() => _NotebookState();
}

class _NotebookState extends State<Notebook> {
  int tabIndex = 0;
  String _category = '';

  bool _showDropdown = false;

  List<dynamic> remCategories = [];


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
    debugPrint(name.toString());

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser?.uid.toString())
            .collection('notebooks')
            .doc('$name')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            
            //  INITIALIZATIONS
            List<dynamic> firebasecategories = snapshot.data?['categories'];
            List<dynamic> firebasetransactions = snapshot.data?['transactions'];

            //  SET STATES
            List<dynamic> transactions = snapshot.data?['transactions'].where((element) => (
                (remCategories.contains(element['category']) == false) &&
                    (DateTime.fromMillisecondsSinceEpoch(element['fulldate'].seconds*1000).isAfter(startDate)) &&
                    (DateTime.fromMillisecondsSinceEpoch(element['fulldate'].seconds*1000).isBefore(endDate.add(Duration(days: 1))))
            )).toList();

            Map<String, dynamic> expenses = (transactions.isNotEmpty) ? transactions.reduce((value, element){
              return {
                'amount': int.parse(value['amount'].toString()) + int.parse(element['amount'].toString()),
              };
            }) : {'amount': 0};

            // String cate = transactions.where((element) =>
            // element['category'] == 'me')
            //     .map((element) => element['amount'])
            //     .reduce((value, element){
            //   return {
            //     'amount': int.parse(value['amount'].toString()) + int.parse(element['amount'].toString()),
            //   };
            // });

            // var categoryTotals = transactions.fold<Map<String, int>>({}, (acc, x) {
            //   acc[x['category']] = acc.containsKey(x['category']) ? acc[x['category']]! + int.parse(x['amount'].toString()) : int.parse(x['amount'].toString());
            //   return acc;
            // }).entries.map((entry) {
            //   return {"category": entry.key, "total": entry.value};
            // }).toList();


            List<int> result = (transactions.isNotEmpty) ? List.generate(firebasecategories.length, (i) => transactions.where((t) => (t['category'] == firebasecategories[i])).fold(0, (sum, t) => sum + int.parse(t['amount'].toString()))) : List.filled(firebasecategories.length, 0);

            List<ChartData> newChartData = List
              .generate(firebasecategories.length, (i) => ChartData(firebasecategories[i],result[i]));

            // Set<String> usedCategories = Set();
            // List<int> categoryTotals = [...transactions.map((category) {
            //   usedCategories.add(category['category']);
            //   return category['amount'];
            // }), ...List.generate(5 - transactions.length, (_) => 0)
            //     .where((value) => !usedCategories.contains(firebasecategories[value]))];

            //
            // List<String> list = List.generate(firebasecategories.length, (index) =>
            //   transactions.reduce((prev, curr) {
            //     if (index==(firebasecategories.indexOf(curr["category"]))) {
            //       prev['amount'] += curr["amount"];
            //     }
            //     return prev;
            // });
            //  condition
            // (List.generate(firebasecategories.length, (index) => transactions
            //     .where((element) => element['category'] == firebasecategories[index])
            //     .map((element) => element['amount'])) != []) ?
            //     //  if true
            //     List.generate(firebasecategories.length, (index) => transactions
            //         .where((element) => element['category'] == firebasecategories[index])
            //             .map((element) => element['amount']).reduce((value, element){
            //             return {
            //               'amount': int.parse(value['amount'].toString()) + int.parse(element['amount'].toString()),
            //             };
            //         }
            //       )
            //     )
            // :
            //     //  if false
            // List.generate(firebasecategories.length, (_) => "0");

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
                              // Text('$cate'),
                              // Text('$result'),
                              //  hEADINGS & tIMELINE
                              Row(
                                children: [
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser?.uid
                                              .toString())
                                          .collection('notebooks')
                                          .doc('$name')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          String description =
                                              snapshot.data?['description'];
                                          return Expanded(
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
                                                    '$name',
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
                                                        color: Colors.white,),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      }),
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
                              Row(
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

                                          //   transactions = firebasetransactions
                                          //     .where((element) => (
                                          //     (remCategories.contains(element['category']) == false) &&
                                          //         (DateTime.fromMillisecondsSinceEpoch(element['fulldate'].seconds*1000).isAfter(startDate)) &&
                                          //         (DateTime.fromMillisecondsSinceEpoch(element['fulldate'].seconds*1000).isBefore(endDate.add(Duration(days: 1))))
                                          // )).toList();
                                          //
                                          //   expenses = transactions.reduce((value, element){
                                          //     return {
                                          //       'amount': int.parse(value['amount'].toString()) + int.parse(element['amount'].toString()),
                                          //     };
                                          //   });

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
                                          height: 52.0,
                                          decoration: BoxDecoration(
                                              color: (tabIndex == 2)
                                                  ? Color(0xFF576EE0)
                                                  : Color(0xFF1D2135),
                                              border: Border(
                                                  right: BorderSide(
                                                      width: 1.0,
                                                      color:
                                                          Color(0xFFBABCC4)))),
                                          child: Center(
                                              child: Text(
                                            'Manage',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat_600',
                                                color: Colors.white),
                                          )),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            tabIndex = 3;
                                          });
                                        },
                                        child: Container(
                                          height: 52.0,
                                          decoration: BoxDecoration(
                                            color: (tabIndex == 3)
                                                ? Color(0xFF576EE0)
                                                : Color(0xFF1D2135),
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(32),
                                                bottomRight:
                                                    Radius.circular(32)),
                                          ),
                                          child: Center(
                                              child: Text(
                                            'Add',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat_600',
                                                color: Colors.white),
                                          )),
                                        ),
                                      )),
                                ],
                              ),

                              if (tabIndex == 0)
                                Container(
                                  margin: EdgeInsets.only(top: 32.0),
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
                                  margin: EdgeInsets.only(top: 42.0),
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
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 56.0, bottom: 12.0),
                                          child: Text(
                                            'Categories',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat_600',
                                                color: Colors.white,
                                                fontSize: 20.0),
                                          )),
                                    ],
                                  ),
                                ),

                              if (tabIndex == 1)
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: firebasecategories.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          List<dynamic> newRemCategories =
                                              remCategories;
                                          if (newRemCategories.contains(
                                              firebasecategories[index])) {
                                            newRemCategories.removeWhere(
                                                (element) =>
                                                    element ==
                                                    firebasecategories[index]);
                                          } else {
                                            newRemCategories
                                                .add(firebasecategories[index]);
                                          }
                                          setState(() {
                                            remCategories = newRemCategories;
                                            transactions = firebasetransactions
                                                .where((element) => (
                                                (remCategories.contains(element['category']) == false) &&
                                                    (DateTime.fromMillisecondsSinceEpoch(element['fulldate'].seconds*1000).isAfter(startDate)) &&
                                                    (DateTime.fromMillisecondsSinceEpoch(element['fulldate'].seconds*1000).isBefore(endDate.add(Duration(days: 1))))
                                            )).toList();


                                            expenses = (transactions.length > 0) ? transactions.reduce((value, element){
                                              return {
                                                'amount': int.parse(value['amount'].toString()) + int.parse(element['amount'].toString()),
                                              };
                                            }) : {'amount': 0};

                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(top: 8.0),
                                          height: 52,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            color: ((!remCategories.contains(
                                                    firebasecategories[index]))
                                                ? Color(0xFF576EE0)
                                                : Color(0xFF1D2135)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              // 'hi',
                                              '${firebasecategories[index]}',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontFamily: 'Montserrat_600',
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),

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
                                                                MainAxisAlignment
                                                                    .spaceBetween,
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
                                                                  dynamic toDelete = transactions[index];

                                                                  List<dynamic> changeArr = firebasetransactions.where((element) => (element['fulldate'] != transactions[index]['fulldate'])).toList();

                                                                    FirebaseFirestore.instance
                                                                        .collection('users')
                                                                        .doc(FirebaseAuth
                                                                        .instance.currentUser?.uid
                                                                        .toString())
                                                                        .collection('notebooks')
                                                                        .doc('$name') .update({
                                                                      "transactions": changeArr
                                                                    });

                                                                    updateDB(toDelete);

                                                                  // var db = FirebaseFirestore.instance;
                                                                  // final docRef = db.collection("users").doc(FirebaseAuth.instance.currentUser?.uid.toString());
                                                                  // docRef.get().then(
                                                                  //       (DocumentSnapshot doc) {
                                                                  //     final data = doc.data() as Map<String, dynamic>;
                                                                  //     var alltransactions = data['allTransactions'];
                                                                  //     var expensetransactions = data['expenseTransactions'];
                                                                  //
                                                                  //     List<dynamic> changeAllArr = alltransactions.where((element) => (element['fulldate'] != transactions[index]['fulldate'])).toList();
                                                                  //     List<dynamic> changeExpenseArr = expensetransactions.where((element) => (element['fulldate'] != transactions[index]['fulldate'])).toList();
                                                                  //
                                                                  //     FirebaseFirestore.instance
                                                                  //         .collection('users')
                                                                  //         .doc(FirebaseAuth
                                                                  //         .instance.currentUser?.uid
                                                                  //         .toString())
                                                                  //         .update({
                                                                  //       "allTransactions": changeAllArr,
                                                                  //       "expenseTransactions": changeExpenseArr
                                                                  //     });
                                                                  //   },
                                                                  //   onError: (e) => print("Error getting document: $e"),
                                                                  // );


                                                                },
                                                              ),
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
                                                                            color: Colors.greenAccent),
                                                                      ),
                                                                      Text(
                                                                        // "${snapshot.data?.data?['transactions'][index].amount}",
                                                                        '${transactions[index]['category']}',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Color(0xFFBABCC4),
                                                                            fontFamily: 'Montserrat_400'),
                                                                      )
                                                                    ],
                                                                  ))
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
                                      dataSource: newChartData,
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

                              if (tabIndex == 3)
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        // color: Colors.greenAccent,
                                        borderRadius: BorderRadius.circular(48),
                                        border: Border.all(color: Colors.white),
                                      ),
                                      margin: EdgeInsets.only(top: 48.0),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      height: 52,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _showDropdown = !_showDropdown;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              (_category == ''
                                                  ? 'Dropdown Button'
                                                  : _category),
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontFamily: 'Montserrat_400',
                                                  color: Colors.white),
                                            ),
                                            Icon(
                                              (_showDropdown
                                                  ? Icons.arrow_drop_up
                                                  : Icons.arrow_drop_down),
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (_showDropdown)
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(FirebaseAuth
                                                  .instance.currentUser?.uid
                                                  .toString())
                                              .collection('notebooks')
                                              .doc('$name')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              List<dynamic> firebasecategories =
                                                  snapshot.data?['categories'];
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 16.0),
                                                padding: EdgeInsets.only(
                                                    right: 16.0,
                                                    left: 16.0,
                                                    bottom: 16.0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  // color: Color(0xFF1D2135),
                                                  color: Color(0xFF161927),
                                                ),
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount:
                                                        firebasecategories
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            _category =
                                                                firebasecategories[
                                                                    index];
                                                            _showDropdown =
                                                                false;
                                                          });
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16.0,
                                                                  vertical:
                                                                      8.0),
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  0xFF1D2135),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black26,
                                                                  offset:
                                                                      Offset(
                                                                          1, 2),
                                                                  blurRadius: 4,
                                                                ),
                                                              ]),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 8.0),
                                                          child: Text(
                                                            '${firebasecategories[index]}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'Montserrat_400',
                                                                fontSize: 16.0),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              );
                                            } else {
                                              return CircularProgressIndicator();
                                            }
                                          }),
                                    Container(
                                      margin: EdgeInsets.only(top: 24.0),
                                      child: TextField(
                                          controller: _amountController,
                                          cursorColor: Colors.white,
                                          decoration: InputDecoration(
                                            hintText: 'Amount',
                                            hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'Montserrat_400'),
                                            labelText: 'Amount',
                                            labelStyle: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Montserrat_400'),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            prefixIcon: Icon(
                                              Icons.currency_rupee_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                          textAlign: TextAlign.left,
                                          keyboardType: TextInputType.number,
                                          textCapitalization: TextCapitalization.sentences,
                                          // keyboardAppearance: ,
                                          style: TextStyle(
                                            fontFamily: 'Montserrat_400',
                                            color: Colors.white,
                                            fontSize: 16.0,
                                          ),
                                          onSubmitted: (value) {
                                            getData();
                                          }),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 24.0),
                                      child: TextField(
                                          controller: _reasonController,
                                          cursorColor: Colors.white,
                                          decoration: InputDecoration(
                                            hintText: 'Crisp Reason',
                                            hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'Montserrat_400'),
                                            labelText: 'Crisp Reason',
                                            labelStyle: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Montserrat_400'),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            prefixIcon: Icon(
                                              Icons.catching_pokemon,
                                              color: Colors.white,
                                            ),
                                          ),
                                          textAlign: TextAlign.left,
                                          keyboardType: TextInputType.text,
                                          textCapitalization: TextCapitalization.sentences,
                                          // keyboardAppearance: ,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Montserrat_400',
                                            fontSize: 16.0,
                                          ),
                                          onSubmitted: (value) {
                                            getData();
                                          }),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 24.0),
                                      child: TextField(
                                          controller: _descriptionController,
                                          cursorColor: Colors.white,
                                          decoration: InputDecoration(
                                            hintText: 'Description',
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
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
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
                                            fontFamily: 'Montserrat_400',
                                            fontSize: 16.0,
                                          ),
                                          onSubmitted: (value) {
                                            getData();
                                          }),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 24.0),
                                      child: InkWell(
                                        onTap: () {

                                          if(_amountController.text.trim().isEmpty || _reasonController.text.trim().isEmpty || (_category == '')){
                                            final snackBar = SnackBar(
                                              /// need to set following properties for best effect of awesome_snackbar_content
                                              elevation: 0,
                                              behavior: SnackBarBehavior.floating,
                                              backgroundColor: Colors.transparent,
                                              content: AwesomeSnackbarContent(
                                                title: 'Snap !!',
                                                message: 'Fill out all the fields !!',
                                                /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                contentType: ContentType.failure,
                                              ),
                                            );

                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(snackBar);
                                            return ;
                                          }

                                          // Pattern pattern = r'^\d+(\.\d{1,2})?$';
                                          RegExp regex = new RegExp(r'^[1-9][0-9]*(\.[0-9]{1,2})?$');

                                          if (!regex.hasMatch(_amountController.text)) {
                                            final snackBar = SnackBar(
                                              /// need to set following properties for best effect of awesome_snackbar_content
                                              elevation: 0,
                                              behavior: SnackBarBehavior.floating,
                                              backgroundColor: Colors.transparent,
                                              content: AwesomeSnackbarContent(
                                                title: 'Snap !!',
                                                message: 'Invalid Amount !!',
                                                /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                contentType: ContentType.failure,
                                              ),
                                            );

                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(snackBar);
                                            return ;
                                          }

                                          var latest = {
                                            'amount': _amountController.text
                                                .toString(),
                                            'category': _category,
                                            'superiorcategory': name,
                                            'type': "expense",
                                            'description':
                                            _descriptionController.text.trim()
                                                .toString(),
                                            'reason': _reasonController.text.trim()
                                                .toString(),
                                            'fulldate': Timestamp.now(),
                                          };

                                          List<dynamic> newTransactions = [
                                            latest,
                                            ...firebasetransactions
                                          ];

                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(FirebaseAuth
                                              .instance.currentUser?.uid
                                              .toString())
                                              .collection('notebooks')
                                              .doc('$name')
                                              .update({
                                            "transactions": newTransactions
                                          });

                                          var db = FirebaseFirestore.instance;
                                          final docRef = db.collection("users").doc(FirebaseAuth.instance.currentUser?.uid.toString());
                                          docRef.get().then(
                                                (DocumentSnapshot doc) {
                                              final data = doc.data() as Map<String, dynamic>;
                                              var alltransactions = data['allTransactions'];
                                              var expensetransactions = data['expenseTransactions'];
                                              // ...
                                              List<dynamic> newAllTransactions = [
                                                latest,
                                                ...alltransactions
                                              ];

                                              List<dynamic> newExpenseTransactions = [
                                                latest,
                                                ...expensetransactions
                                              ];

                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(FirebaseAuth
                                                  .instance.currentUser?.uid
                                                  .toString())
                                                  .update({
                                                "allTransactions": newAllTransactions,
                                                "expenseTransactions": newExpenseTransactions
                                              });


                                                },
                                            onError: (e) => print("Error getting document: $e"),
                                          );



                                          final snackBar = SnackBar(
                                            /// need to set following properties for best effect of awesome_snackbar_content
                                            elevation: 0,
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.transparent,
                                            content: AwesomeSnackbarContent(
                                              title: 'Hi User!',
                                              message:
                                                  'Transaction added successfully',

                                              /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                              contentType: ContentType.success,
                                            ),
                                          );

                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(snackBar);

                                          setState(() {
                                            _amountController.clear();
                                            _reasonController.clear();
                                            _descriptionController.clear();
                                            _category = '';
                                          });
                                        },
                                        child: Container(
                                          height: 56,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
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
                                      ),
                                    )
                                  ],
                                )

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
          .get();

      if (docSnapshot.exists) {

        dynamic userData = docSnapshot.data();

        debugPrint(userData['allTransactions'].toString());
        List<dynamic> updateAllTransactions = userData['allTransactions'].where((element) => (element['fulldate'] != transaction['fulldate'])).toList();
        List<dynamic> updateExpenseTransactions = userData['expenseTransactions'].where((element) => (element['fulldate'] != transaction['fulldate'])).toList();

        debugPrint(updateAllTransactions.toString());
        debugPrint(updateExpenseTransactions.toString());

        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth
            .instance.currentUser?.uid
            .toString())
            .update({
          "allTransactions": updateAllTransactions,
          "expenseTransactions": updateExpenseTransactions
        });
      }

    } catch (e) {
      print('Error updating main collection: $e');
    }
  }


}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final int y;
}