import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/widget.dart';
import 'conversation_screen.dart';
import 'package:getwidget/getwidget.dart';

class SearchPlatform extends StatefulWidget {
  @override
  _SearchPlatformState createState() => _SearchPlatformState();
}

class _SearchPlatformState extends State<SearchPlatform> {

  var queryResultSet=[];
  var tempSearchStore=[];

  TextEditingController searchTextEditingcontroller =
      new TextEditingController();
  Helperfunctions helperfunctions = new Helperfunctions();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  QuerySnapshot searchSnapshot;
  QuerySnapshot snapshotUserInfo;

  initaiteSearch(){
    databaseMethods
        .getUserbySearchKey(searchTextEditingcontroller.text)
        .then((val) async {
      print(val.toString());
      setState(() {
        searchSnapshot = val;
        print(searchSnapshot);
      });
    });
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                userName: searchSnapshot.documents[index].data["name"],
                userEmail: searchSnapshot.documents[index].data["email"],
                Interests: searchSnapshot.documents[index].data["interestsList"],
                branch: searchSnapshot.documents[index].data["Branch"],
                year: searchSnapshot.documents[index].data["year"],
              );
            })
        : Container();
  }

  createChatroomAndStartConversation(String userName) {
    if (userName != Constants.myName) {
      List<String> users = [Constants.myName, userName];
      String chatRoomId = getChatRoomId(Constants.myName, userName);
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                    chatRoomId: chatRoomId,
                userName: userName,
                  )));
      }
      else {
      Container();
    }
  }

  Widget searchTile({String userName, String userEmail,List<dynamic> Interests, String branch,String year}) {
    String interestString="";
    for(int i=0;i<Interests.length;i++){
      interestString+=Interests[i];
      if(i+1==Interests.length){
        break;
      }
      interestString+=', ';
    }
    if(userName==Constants.myName){
      return Container();
    }
    return Container(
      child: GFCard(
        boxFit: BoxFit.cover,
        imageOverlay: AssetImage('your asset image'),
        title: GFListTile(
          avatar: Container(
            width: 55,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text("${userName.substring(0, 1).toUpperCase()}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w500)),
            ),
          ),
          title: Text(userName, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          subTitle: Text(userEmail),
        ),
        content: Column(
          children: [
            Row(
              children: [
                Text("Interests: " ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                Container(
                    width: MediaQuery.of(context).size.width-170,
                    child: Text(interestString)),
              ],
            ),
            Row(
              children: [
                Text("\nBranch: " ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                Container(
                    width: MediaQuery.of(context).size.width-180,
                    child: Text("\n"+branch),
                )
              ],
            ),
            Row(
              children: [
                Text("\nYear of Study: " ,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                Container(
                    width: MediaQuery.of(context).size.width-200,
                    child: Text("\n"+year + " Year")),
              ],
            ),
          ],
        ),
        buttonBar: GFButtonBar(
        children: <Widget>[
          GFButton(
            onPressed: () {
              createChatroomAndStartConversation(userName);
            },
            text: 'Message',
            color: Color(0xFF8F48F7),
          )
        ],
      ),
      ),
    );
    Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: textStyle1(),
              ),
              Text(
                userEmail,
                style: textStyle(),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndStartConversation(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Text(
                "Message",
                style: TextStyle(fontSize: 15),
              ),
            ),
          )
        ],
      ),
    );
  }

  String searchString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
          child: Column(children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value){
                    setState(() {
                      searchString=value.toLowerCase();
                      initaiteSearch();
                    });
                  },
                  controller: searchTextEditingcontroller,
                  decoration: textFieldInputDecoration("Search Username/Interests..."),
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              GestureDetector(
                // onTap: () {
                //   initaiteSearch();
                // },
                child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Color(0xFF8F48F7),
                        // gradient: LinearGradient(colors: [
                        //   const Color(0x36FFFFFF),
                        //   const Color(0x0FFFFFFF)
                        // ]),
                        borderRadius: BorderRadius.circular(40)),
                    padding: EdgeInsets.all(8),
                    child: Image.asset("assets/images/search_white.png")),
              ),
            ],
          ),
        ),
            Expanded( child: searchList(),)
      ])),
    );
  }
}




getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
