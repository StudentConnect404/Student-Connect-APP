import 'dart:ui';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/answers.dart';
import 'package:chat_app/views/searchTags.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/views/addquestion.dart';
import 'package:chat_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/widgets.dart';
import 'package:like_button/like_button.dart';

class GroupConversationScreen extends StatefulWidget {
  final String groupId;
  GroupConversationScreen({this.groupId });
  @override
  _GroupConversationScreenState createState() => _GroupConversationScreenState();
}

class _GroupConversationScreenState extends State<GroupConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Widget questionList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("groups")
          .document(group.groupId)
          .collection("question")
          .orderBy("Question_time", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // print(snapshot.data.documents["JAq454dBJebvwJmmkahm"].data.toString());
        return snapshot.data != null
            ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return QuestionTile(
                  question: snapshot.data.documents[index].data["Question"],
                  question_username: snapshot.data.documents[index].data["Question_username"],
                  question_Time: snapshot.data.documents[index].data["Question_time"].toString(),
                  tags: snapshot.data.documents[index].data["Question_tags"],
                  likes : snapshot.data.documents[index].data["Question_likes"],
                  likedList: snapshot.data.documents[index].data["Like_list"],
                // snapshot.data.documents[index].data["sendBy"] == Constants.myName);
              );
            })
            : Container();
      },
    );
  }

  Stream questionStream;

  // sendMessage() {
  //   if (messageController.text.isNotEmpty) {
  //     Map<String, dynamic> messageMap = {
  //       "message": messageController.text,
  //       "sendBy": Constants.myName,
  //       "time": DateTime.now().millisecondsSinceEpoch
  //     };
  //     databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
  //     messageController.text = "";
  //   }
  // }

  @override
  void initState() {
    databaseMethods.getQuestions(group.groupId).then((value) {
      setState(() {
        questionStream = value;
        // print(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.groupId), actions: [
          Column(
            children: [
              IconButton(
                  icon:   const Icon(Icons.queue_sharp),
                  tooltip: 'Add Question',
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => addQuestion(
                        )));
                  }),
              // Text("Add Question" ,style: TextStyle(color: Colors.white),)
            ],
          ),
        ]),
      body:questionList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF8F48F7),
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => QuestionSearchPlatform(
                groupId: widget.groupId,
              )));
        },
      ),

    );
  }
}

void liketapped(bool isLiked,int likes,String question,List<dynamic> likedList){
  if(isLiked){
    likes--;
  }
  else{
    likes++;
  }
  print(likes);
  Firestore.instance.collection("groups").document(group.groupId).collection("question").document(question).updateData({'Question_likes': likes, 'Like_list': likedList});
}

class QuestionTile extends StatelessWidget {
  final String question;
  final String question_username;
  final String question_Time;
  final int likes;
  final List<dynamic>likedList;
  List<dynamic>tags;
  String loremIpsum =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
  String tagsString="";

  QuestionTile({this.question,this.question_username,this.question_Time,this.tags,this.likes,this.likedList});
  @override
  Widget build(BuildContext context) {
    print(tags);
    bool isLiked;
    for(int i=0;i<tags.length;i++){
      tagsString+="#";
      tagsString+=tags[i];
      tagsString+=" ";
    }
    if(likedList.length!=null){
      print(likedList);
      for(int i=0;i<likedList.length;i++)[
        if(likedList[i]==Constants.myName)
          isLiked=true
        else
          isLiked=false
      ];
    };
    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            elevation: 10,
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
                              width: 1,
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
                                child :Container(
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    // shape: BoxShape.,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                  ),
                                  width: 300,
                                  child: Text("  Tags: "+ tagsString,
                              style: TextStyle(fontSize: 18, color: Colors.black,),
                            ),
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
                  color:  Color(0xFF8F48F7),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.touch_app),
                            Text('Show Answers',style: TextStyle(fontSize: 16,),),
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            if(isLiked){
                              likedList.remove(Info.user_Name);
                            }
                            else{
                              likedList.add(Info.user_Name);
                            }
                            liketapped(isLiked,likes,question,likedList);
                            isLiked=!isLiked;
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                child: Icon(Icons.favorite_outlined, color: isLiked ? Colors.red:Colors.black ),
                              ),
                              Text(likes.toString()),
                            ],
                          ),
                        ),
                      ],
                    ), //Row
                  ), //Padding
                ), //RaisedButton

              ],
            ),
          ),
        ));
      Center(
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              // question.questionId=question;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AnswerScreen(
                        questionId: question,
                      )));
            },
            child: Container(
                // decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       colors: true
                //           ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                //           : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
                //     ),
                //     borderRadius: true
                //         ? BorderRadius.only(
                //         topLeft: Radius.circular(23),
                //         topRight: Radius.circular(23),
                //         bottomLeft: Radius.circular(23),
                //         bottomRight: Radius.circular(23))
                //         : BorderRadius.only(
                //         topLeft: Radius.circular(23),
                //         topRight: Radius.circular(23),
                //         bottomRight: Radius.circular(23)),
                //     border: Border.all(
                //       color: Colors.greenAccent,
                //       width: 5,
                //     )),
                width: MediaQuery.of(context).size.width-50,
                alignment: false ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Text(
                    "@"+question_username+"\n"+question,
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                )),
          // child: const SizedBox(
          //   width: 300,
          //   height: 100,
          //   child: Text('A card that can be tapped'),
          // ),
        ),
      ),
    );
    //   Container(
    //     margin: EdgeInsets.all(5),
    //     child: GestureDetector(
    //       onTap: () {
    //         // question.questionId=question;
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => AnswerScreen(
    //               questionId: question,
    //             )));
    //     },
    //     child: Container(
    //       margin: EdgeInsets.symmetric(vertical: 8),
    //       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    //
    //     decoration: BoxDecoration(
    //       color: const Color(0xFF93C2DE),
    //       borderRadius: BorderRadius.circular(30)),
    //
    //     child: Row(
    //       children: [
    //       Container(
    //         height: 35,
    //         width: 35,
    //         decoration: BoxDecoration(
    //         color: Colors.blue,
    //         borderRadius: BorderRadius.circular(35),
    //       ),
    //       child: Text("${question_username.substring(0, 1).toUpperCase()}",
    //         textAlign: TextAlign.center,
    //         style: TextStyle(
    //         color: Colors.white,
    //         fontSize: 28,
    //         fontFamily: 'OverpassRegular',
    //         fontWeight: FontWeight.w500)),
    //       ),
    //       SizedBox(
    //         width: 10,
    //       ),
    //       Container(
    //           width: MediaQuery.of(context).size.width,
    //           child: Text(
    //       question_username+"\n"+question,
    //       style: textStyle1(),
    //       ))
    //       ],
    //     ),
    //   ),
    // ));
  }
}
