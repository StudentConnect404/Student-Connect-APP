import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/views/chatroomscreen.dart';
import 'package:chat_app/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/helper/authenticate.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class interestTopic {
  int id;
  String name;

  interestTopic({this.id, this.name});
}
class Interest extends StatefulWidget {
  @override
  _InterestState createState() => _InterestState();
}

class _InterestState extends State<Interest> {
  bool isLoading = false;
  static List<interestTopic> _Topic = [
    interestTopic(id: 1, name: "Competitive Programming"),
    interestTopic(id: 2, name: "Web Development"),
    interestTopic(id: 3, name: "Android Development"),
    interestTopic(id: 4, name: "Data Science"),
    interestTopic(id: 5, name: "Machine Learning"),
    interestTopic(id: 6, name: "Artificial intelligence"),
    interestTopic(id: 7, name: "Robotics"),
    interestTopic(id: 8, name: "Automation"),
    interestTopic(id: 9, name: "Aerodynamics"),
    interestTopic(id: 10, name: "Organic Chemistru"),
    interestTopic(id: 11, name: "Thermodynamics"),
  ];
  confirm(){
    setState(() {
      isLoading = true;
    });
    String name = Info.user_Name;
    print( '${name}');
    String email = Info.user_email;
    List searchSkill = [];
    List indexList = [];
    _selectedItems2
        .forEach((item) => searchSkill.add(item.name));
    for(int i=0;i<searchSkill.length;i++){
      indexList.add(searchSkill[i].toLowerCase());
      List<String>splitList=searchSkill[i].split(" ");
      //List<String>indexList=[];

      for(int i=0;i<splitList.length;i++){
        for(int j=1;j<splitList[i].length + 1;j++){
          indexList.add(splitList[i].substring(0,j).toLowerCase());
        }
      }
    }
    List<String>splitList=Info.user_Name.split(" ");

    for(int i=0;i<splitList.length;i++){
      for(int j=1;j<splitList[i].length + 1;j++){
        indexList.add(splitList[i].substring(0,j).toLowerCase());
      }
    }
    String x=Info.user_Name.toLowerCase();
    indexList.add(x);
    print( '${indexList}');
    print("this is infoname ${Info.user_Name}");
    Firestore.instance.collection('users').document().setData({'name':name, 'email':email,'searchKey': indexList, 'interestsList': searchSkill,'Branch': Info.branch,"year":Info.year});

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ChatScreen()));

  }
  final _items = _Topic
      .map((item) => MultiSelectItem<interestTopic>(item, item.name))
      .toList();
  List<interestTopic> _selectedItems2 = [];
  List<interestTopic> _selectedItems3 = [];
  final _multiSelectKey = GlobalKey<FormFieldState>();
  String Preligion = "Select your Interest";

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(child: Center(child: CircularProgressIndicator())): Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            MultiSelectBottomSheetField<interestTopic>(
              initialChildSize: 0.7,
              maxChildSize: 0.95,
              listType: MultiSelectListType.CHIP,
              checkColor: Colors.black,
              selectedColor: Colors.blue[400],
              selectedItemsTextStyle: TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
              unselectedColor: Colors.purple[100],
             buttonIcon: Icon(
                Icons.add,
                color: Color(0xFF8F48F7),
              ),
              searchHintStyle: TextStyle(
                fontSize: 20,
              ),
              searchable: true,
              buttonText: Text(
                'Select your Interests', //"????",
                style: TextStyle(
                  fontSize: 23,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
              ),
              title: Text(
                "Select Interests",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              items: _items,
              onConfirm: (values) {
                print('${values}');
                setState(() {
                  _selectedItems2 = values;
                });
                print(_selectedItems2);

                _selectedItems2
                    .forEach((item) => print("${item.id} ${item.name}"));
                /*senduserdata(
                    'partnerreligion', '${_selectedItems2.toString()}');*/
              },
              chipDisplay: MultiSelectChipDisplay(
                textStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                onTap: (value) {

                  print(_selectedItems2);
                  setState(() {
                    _selectedItems2.remove(value);
                  });
                  print(_selectedItems2);
                  print('removed: ${_selectedItems2.toString()}');
                  print('selected : ${_selectedItems2}');
                },
              ),
            ),
            _selectedItems2 == null || _selectedItems2.isEmpty
                ? MultiSelectChipDisplay(
              onTap: (item) {
                setState(() {
                  _selectedItems3.remove(item);
                  print('removed below: ${_selectedItems3.toString()}');
                  //FormFieldValidator()
                });
                _multiSelectKey.currentState.validate();
              },
            )
                : MultiSelectChipDisplay(),
            SizedBox(
              height: 100,
            ),
            GestureDetector(
              onTap: (){
                // confirm();
                if(_selectedItems2.isEmpty){
                  Text("Please enter your skill", style: textStyle(),);
                  print("Please enter your skill");
                }
                else{
                  confirm();
                }

              },
              child: Container(alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        const Color(0xff007EF4),
                        const Color(0Xff2A75BC)
                      ]),
                      borderRadius: BorderRadius.circular(25)),
                  child: Text("Sign In",  style: TextStyle(color: Colors.white, fontSize: 22)),
            ),) ],
        ),

      ),
    );
  }
}