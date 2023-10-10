import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNotebook extends StatefulWidget {
  const AddNotebook({Key? key}) : super(key: key);

  @override
  State<AddNotebook> createState() => _AddNotebookState();
}

class _AddNotebookState extends State<AddNotebook> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _categoryController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();

  List<Categories> _list = [
    Categories(name: 'Others', showCross: false),
  ];
  List<String> categoryList = ['Others'];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser?.uid.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //  INITIALIZATIONS
            List<dynamic> firebasebooks = snapshot.data?['notebooks'];

            //  SET STATES

            return GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: SafeArea(
                child: Scaffold(
                    backgroundColor: Color(0xFF161927),
                    body: SingleChildScrollView(
                      child: Container(
                        height: (MediaQuery.of(context).size.height - 128),
                        // color: Colors.white,
                        padding:
                            EdgeInsets.only(left: 16.0, right: 16.0, top: 64.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Montserrat_600',
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Notebook',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Montserrat_600',
                                color: Colors.white,
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 32.0),
                                child: TextField(
                                  controller: _nameController,
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    hintText: 'Notebook Name',
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Montserrat_400'),
                                    labelText: 'Notebook Name',
                                    labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat_400'),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.notes,
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
                                )),
                            Container(
                                margin: EdgeInsets.only(top: 24.0),
                                child: TextField(
                                  controller: _descriptionController,
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    hintText: 'Notebook Description',
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Montserrat_400'),
                                    labelText: 'Notebook Description',
                                    labelStyle: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat_400'),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
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
                                    fontSize: 16.0,
                                      fontFamily: 'Montserrat_400'
                                  ),
                                )),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 8.0, right: 8.0, top: 6.0, bottom: 8.0),
                              margin: EdgeInsets.only(top: 24.0),
                              decoration: BoxDecoration(
                                  color: Color(0xFF1D2135),
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    color: Color(0xFF576EE0),
                                  ),
                                  // MaterialGap(size: 16.0),
                                  SizedBox(width: 8.0,),
                                  Text(
                                    'Choose your categories wisely !!',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat_500'),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 56,
                              child: Container(
                                margin: EdgeInsets.only(top: 24.0),
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _list.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        // width: 56,
                                        height: 22,
                                        margin: EdgeInsets.only(right: 16.0),
                                        padding: EdgeInsets.only(
                                            top: 4.0,
                                            right: 8.0,
                                            bottom: 4.0,
                                            left: 8.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                            border: Border.all(
                                              color: Colors.white,
                                            )),
                                        child: Row(
                                          children: [
                                            Text(
                                              '${_list[index].name.toString()}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Montserrat_400',
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4.0,
                                            ),
                                            if (_list[index].showCross)
                                              InkWell(
                                                  onTap: () {
                                                    List<Categories> newarr =
                                                        _list;
                                                    newarr.removeAt(index);
                                                    List<String> xrr =
                                                        categoryList;
                                                    xrr.removeAt(index);
                                                    setState(() {
                                                      _list = newarr;
                                                      categoryList = xrr;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.whatshot_rounded,
                                                    color: Color(0xFF576EE0),
                                                    size: 16.0,
                                                  ))
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 24.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      // color: Colors.white,
                                      child: TextField(
                                        controller: _categoryController,
                                        cursorColor: Colors.white,
                                        decoration: InputDecoration(
                                          hintText: 'Add Category',
                                          hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'Montserrat_400'),
                                          labelText: 'Add Category',
                                          labelStyle: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Montserrat_400'),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                          border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)),
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
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: Colors.black,
                                      child: InkWell(
                                        onTap: () {

                                          if(_categoryController.text.trim() == ""){
                                            final snackBar = SnackBar(
                                              /// need to set following properties for best effect of awesome_snackbar_content
                                              elevation: 0,
                                              behavior: SnackBarBehavior.floating,
                                              backgroundColor: Colors.transparent,
                                              content: AwesomeSnackbarContent(
                                                title: 'Snap !!',
                                                message: 'Empty field detected !',
                                                /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                contentType: ContentType.failure,
                                              ),
                                            );

                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(snackBar);

                                            return ;
                                          }

                                          if(categoryList.contains(_categoryController.text.toString())){
                                            final snackBar = SnackBar(
                                              /// need to set following properties for best effect of awesome_snackbar_content
                                              elevation: 0,
                                              behavior: SnackBarBehavior.floating,
                                              backgroundColor: Colors.transparent,
                                              content: AwesomeSnackbarContent(
                                                title: 'Snap !!',
                                                message: 'Duplicate categories found',
                                                /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                contentType: ContentType.failure,
                                              ),
                                            );

                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(snackBar);
                                            return ;
                                          }

                                          List<Categories> newarr = _list;
                                          List<String> xrr = categoryList;
                                          newarr.add(Categories(
                                              name: _categoryController.text.trim()
                                                  .toString(),
                                              showCross: true));
                                          xrr.add(_categoryController.text.trim()
                                              .toString());
                                          setState(() {
                                            _list = newarr;
                                            categoryList = xrr;
                                          });

                                          _categoryController.clear();
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
                                              'Add',
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontFamily: 'Montserrat_600',
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 24.0),
                              child: InkWell(
                                onTap: () {

                                  if(_nameController.text.trim().isEmpty){
                                    final snackBar = SnackBar(
                                      /// need to set following properties for best effect of awesome_snackbar_content
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: 'Snap !!',
                                        message: 'Notebook name not filled',
                                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                        contentType: ContentType.failure,
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);

                                    return ;
                                  }

                                  if(_descriptionController.text.trim().isEmpty){
                                    final snackBar = SnackBar(
                                      /// need to set following properties for best effect of awesome_snackbar_content
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: 'Snap !!',
                                        message: 'Notebook Description name not filled',
                                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                        contentType: ContentType.failure,
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);

                                    return ;
                                  }

                                  if(firebasebooks.contains(_nameController.text.trim())){
                                    final snackBar = SnackBar(
                                      /// need to set following properties for best effect of awesome_snackbar_content
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: 'Snap !!',
                                        message: 'Notebook already present, use another name !!',
                                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                        contentType: ContentType.failure,
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);

                                    return ;
                                  }

                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.uid
                                          .toString())
                                      .collection('notebooks')
                                      .doc('${_nameController.text.trim().toString()}')
                                      .set({
                                    'id': _nameController.text.trim().toString(),
                                    'categories': categoryList,
                                    'createdAt': Timestamp.now(),
                                    'description':
                                        _descriptionController.text.trim().toString(),
                                    'name': _nameController.text.trim().toString(),
                                    'transactions': [],
                                  });

                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.uid
                                          .toString())
                                      .update({
                                    "notebooks": FieldValue.arrayUnion(
                                        [_nameController.text.trim().toString()])
                                  });

                                  _categoryController.clear();
                                  _nameController.clear();
                                  _descriptionController.clear();


                                  Navigator.pop(context);

                                },
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
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
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

class Categories {
  final String name;
  final bool showCross;
  Categories({required this.name, required this.showCross});
}
