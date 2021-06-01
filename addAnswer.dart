import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/answers.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:chat_app/model/user.dart';
import 'package:flutter/services.dart';
import 'chatroomscreen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'groupConversation.dart';

class addAnswer extends StatefulWidget {
  final String questionId;
  final String question_username;
  final String tagsString;
  addAnswer({this.questionId,this.question_username,this.tagsString});

  @override
  _addAnswerState createState() => _addAnswerState();
}


class _addAnswerState extends State<addAnswer> {
  @override
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController addAnswerText = new TextEditingController();

  void submit(BuildContext context){
    if(addAnswerText.text.isEmpty) {
      print("ERROR");
    }
    else{
      Map<String, dynamic> addAnswermap = {
        "Answer": addAnswerText.text,
        "Answer_time": DateTime.now().millisecondsSinceEpoch,
        "Answer_username": Constants.myName,
      };
      databaseMethods.addAnswerInfo(group.groupId,addAnswermap,widget.questionId);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AnswerScreen(
                questionId: widget.questionId,
                question_username: widget.question_username,
                tagsString: widget.tagsString,
              )));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('BrainNotFound'),actions: [
          // IconButton(
          //   onPressed: (){
          //     Navigator.pushReplacement(context,
          //         MaterialPageRoute(builder: (context) => AnswerScreen()));
          //   },
          //   icon: Icon(Icons.arrow_back,color: Colors.black,),
          // ),
        ],),
        body: new Container(
          padding: EdgeInsets.all(6.0),
          child: new ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsetsDirectional.only(start: 5.0)),
                  TextField(
                      autocorrect: true,
                      autofocus: true,
                      controller: addAnswerText,
                      maxLength: 256,// TextField(
                  //     autocorrect: true,
                  //     autofocus: true,
                  //     maxLength: 256,
                  //     maxLines: null,
                  //     style: TextStyle(
                  //         color: Colors.black, fontWeight: FontWeight.bold),
                  //     keyboardType: TextInputType.multiline,
                  //     decoration: InputDecoration(
                  //         labelText: "Tags",
                  //         hintText: 'Enter Tags ',
                  //         prefixIcon: Icon(Icons.grade),
                  //         border: OutlineInputBorder(
                  //           borderRadius: BorderRadius.circular(8.0),
                  //         ))),
                      maxLines: 6,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          labelText: "Answer of question!!",
                          hintText: 'Answer...',
                          prefixIcon: Icon(Icons.question_answer),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),))),
                  Padding(
                    padding: EdgeInsetsDirectional.only(top: 10.0),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(top: 10.0),
                  ),
                  RaisedButton(
                    onPressed: ()=> submit(context),
                    child: Text("Sumit"),
                    elevation: 5.0,
                  )
                ],
              ),
            ],
          ),
        )
    );

  }
}
