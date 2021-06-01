import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:chat_app/model/user.dart';
import 'package:flutter/services.dart';
import 'chatroomscreen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'groupConversation.dart';

class addQuestion extends StatefulWidget {
  @override
  _addQuestionState createState() => _addQuestionState();
}


class _addQuestionState extends State<addQuestion> {
  @override
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController addQuestionText = new TextEditingController();
  TextEditingController tagcontroller = new TextEditingController();

  void submit(BuildContext context){
    if(addQuestionText.text.isEmpty) {
      print("ERROR");
      Text("Error");
    }
    else{
      List<String>splitList=tagcontroller.text.split(" ");
      List<String>tagsList=[];

      for(int i=0;i<splitList.length;i++){
        for(int j=1;j<splitList[i].length + 1;j++){
          tagsList.add(splitList[i].substring(0,j).toLowerCase());
        }
      }
      List<String>like=['empty'];
      int likes=0;
      Map<String, dynamic> addQuestionmap = {
        "Question": addQuestionText.text,
        "Question_time": DateTime.now().millisecondsSinceEpoch,
        "Question_username": Constants.myName,
        "Tags":tagsList,
        "Question_tags":splitList,
        "Like_list": like,
        "Question_likes": likes,
      };
      databaseMethods.addQuestionInfo(group.groupId,addQuestionmap,addQuestionText.text);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GroupConversationScreen(
                groupId: group.groupId,
              )));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BrainNotFound')),
        body: new Container(
        padding: EdgeInsets.all(6.0),
          child: new ListView(
            children: <Widget>[
              Column(

                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsetsDirectional.only(start: 5.0)),
                  TextFormField(
                    autocorrect: true,
                    autofocus: true,
                    controller: addQuestionText,
                    maxLength: 500,
                    maxLines: 7,
                    style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                    labelText: "Question us anything!!!",
                    hintText: 'Write question here ',
                    prefixIcon: Icon(Icons.question_answer),
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),))),
                  Padding(
                    padding: EdgeInsetsDirectional.only(top: 10.0),
              ),
                TextField(
                  autocorrect: true,
                  autofocus: true,
                  controller: tagcontroller,
                  maxLength: 256,
                  maxLines: null,
                  style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                  labelText: "Tags",
                  hintText: 'Enter Tags ',
                  prefixIcon: Icon(Icons.grade),
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ))),
                  Padding(

                    padding: EdgeInsetsDirectional.only(top: 10.0),
                  ),
                  RaisedButton(
                    onPressed: ()=> submit(context),
                    child: Text("Sumit"),
                    elevation: 5.0,),
               ],
              ),
            ],
          ),
        )
    );

  }
}
