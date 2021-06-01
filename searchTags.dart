import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/answers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/widget.dart';
import 'conversation_screen.dart';
import 'package:expandable/expandable.dart';

class QuestionSearchPlatform extends StatefulWidget {
  final String groupId;
  QuestionSearchPlatform({this.groupId});
  @override
  _QuestionSearchPlatformState createState() => _QuestionSearchPlatformState();
}

class _QuestionSearchPlatformState extends State<QuestionSearchPlatform> {

  var queryResultSet=[];
  var tempSearchStore=[];

  TextEditingController searchTagTextEditingcontroller =
  new TextEditingController();
  Helperfunctions helperfunctions = new Helperfunctions();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  QuerySnapshot searchSnapshot;
  QuerySnapshot snapshotUserInfo;

  initaiteSearch(){
    databaseMethods
        .getQuestionsbyTags(searchTagTextEditingcontroller.text,widget.groupId)
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
            question: searchSnapshot.documents[index].data["Question"],
            question_username: searchSnapshot.documents[index].data["Question_username"],
            tags: searchSnapshot.documents[index].data["Question_tags"],
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
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                chatRoomId: chatRoomId,
                userName: userName,
              )));
    } else {
      Container();
    }
  }

  Widget searchTile({String question, String question_username, List<dynamic>tags}) {
    String tagsString="";
    print(tags);
    for(int i=0;i<tags.length;i++){
      tagsString+="#";
      tagsString+=tags[i];
      tagsString+=" ";
    }
    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 28,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                    child: Text(" @"+question_username,style: TextStyle(fontSize: 20, color: Colors.black),),
                  ),
                ),
                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                    ),

                    header:Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 3,
                                  ),
                                ),
                                width: 300,
                                child :Text("  Tags: "+ tagsString,
                                  style: TextStyle(fontSize: 18, color: Colors.black,),
                                )),
                          ],
                        )),
                    collapsed: Text("Question: "+
                        question,
                      softWrap: true,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16,color: Colors.black),
                    ),
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text("Question: "+
                                question,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                              style: TextStyle(fontSize: 17,color: Colors.black),
                            )),
                      ],
                    ),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          theme: const ExpandableThemeData(crossFadePoint: 0),
                        ),
                      );
                    },
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AnswerScreen(
                              questionId: question,
                              question_username: question_username,
                              tagsString: tagsString,
                            )));
                  },
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Icon(Icons.touch_app),
                        Text('Answer'),
                      ],
                    ), //Row
                  ), //Padding
                ), //RaisedButton

              ],
            ),
          ),
        ));
      Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "@"+question_username+ "\n"+question,
                style: textStyle1(),
              ),
              // Text(
              //   userEmail,
              //   style: textStyle(),
              // )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AnswerScreen(
                        questionId: question,
                      )));
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Text(
                "Check Answers",
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
                      controller: searchTagTextEditingcontroller,
                      decoration: textFieldInputDecoration("Search Username..."),
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
