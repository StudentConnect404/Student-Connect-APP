import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/addAnswer.dart';
import 'package:chat_app/views/groupConversation.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/views/addquestion.dart';
import 'package:chat_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';

class AnswerScreen extends StatefulWidget {
  final String questionId;
  final String question_username;
  final String tagsString;
  AnswerScreen({this.questionId,this.question_username ,this.tagsString });
  @override
  _AnswerScreenState createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Widget answerList() {
    question.questionId=widget.questionId;
    return StreamBuilder(
      stream: Firestore.instance.collection("groups").document(group.groupId).collection("question").document(widget.questionId).collection("answer").orderBy("Answer_time" ,descending: true).snapshots(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Container(
              child: ListView.builder(
              itemCount: snapshot.data.documents.length,
              // reverse: true,
              itemBuilder: (context, index) {
                return AnswerTile(
                    answer : snapshot.data.documents[index].data["Answer"],
                    answer_username: snapshot.data.documents[index].data["Answer_username"],
                    answer_Time: snapshot.data.documents[index].data["Answer_time"].toString(),
                );}),
            )
            : Container();
      },
    );
  }

  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text(group.groupId),
        leading:
        GestureDetector(
          onTap: () {

            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => GroupConversationScreen(
                  groupId: group.groupId,
                )));
          },
          child: Container(

              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.arrow_back)),
        ),
        // Row(
        //   children: [
        //     IconButton(
        //       icon:   const Icon(Icons.question_answer_outlined),
        //       tooltip: 'Add Answer',
        //       onPressed: () {
        //         Navigator.push(context,
        //           MaterialPageRoute(builder: (context) => addAnswer(
        //             questionId:widget.questionId,
        //             question_username: widget.question_username,
        //             tagsString: widget.tagsString,
        //           )));
        //         }),
        //   ],
        // ),
        ),
      body:Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
             child: ExpandableNotifier(
                  child: Padding(

                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(width: 1.0, color: Colors.black),
                          ),
                      ),
                      // clipBehavior: Clip.antiAlias,
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
                              child: Text(" @"+widget.question_username,style: TextStyle(fontSize: 20, color: Colors.black),),
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
                                                width: 2,
                                              ),
                                            ),
                                            width: 300,
                                            child: Text("  Tags: "+ widget.tagsString,
                                              style: TextStyle(fontSize: 18, color: Colors.black,),
                                            ),
                                          )),
                                    ],
                                  )),
                              collapsed: Text("Question: "+
                                  widget.questionId,
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
                                          widget.questionId,
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
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => addAnswer(
                                    questionId:widget.questionId,
                                    question_username: widget.question_username,
                                    tagsString: widget.tagsString,
                                  )));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF8F48F7),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.touch_app),
                                  Text('Answer',style: TextStyle(fontSize: 16),),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
          ),
          Expanded(
            child: answerList(),
          ),
        ],
      ),

    );
  }
}

class AnswerTile extends StatelessWidget {
  final dynamic answer;
  final String answer_username;
  final String answer_Time;

  AnswerTile({this.answer,this.answer_username,this.answer_Time});
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            elevation: 10,
            // clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF8F48F7),
                      shape: BoxShape.rectangle,
                    ),
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
                    header: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "@" + answer_username,
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                        )),
                    collapsed: Text(
                      answer,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                answer, style: TextStyle(fontSize: 15),
                                softWrap: true,
                                overflow: TextOverflow.fade,
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
              ],
            ),
          ),
        ));
      Column(
      children: [
        Container(
            width: MediaQuery.of(context).size.width-50,
            alignment: false ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: true
                        ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                        : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
                  ),
                  borderRadius: true
                      ? BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomLeft: Radius.circular(23),
                      bottomRight: Radius.circular(23))
                      : BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomRight: Radius.circular(23)),
                  border: Border.all(
                    color: Colors.greenAccent,
                    width: 5,
                  )),
              child: Text(
                "@"+answer_username+"\n"+answer,
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            )),
      ],
    );
  }
}