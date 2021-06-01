import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatroomscreen.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';


class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String userName;
  ConversationScreen({this.chatRoomId,this.userName});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                reverse: true,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.documents[index].data["message"],
                      isSendByMe: snapshot.data.documents[index].data["sendBy"] ==
                              Constants.myName);
                })
            : Container();
      },
    );
  }

  getSendersName(String chatRoomId){
    String opponentsName="";
    bool ok=false;
    for(int i=0;i<chatRoomId.length;i++){
      if(chatRoomId[i]=='_'){
        break;
      }
      opponentsName+=chatRoomId[i];
    }
  }
  Stream chatMessageStream;

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
      databaseMethods.updateChatroom(widget.chatRoomId);
    }
  }
  // sendMessage(){
  //   if(messageController.text.isNotEmpty){
  //     Map<String, dynamic> messageMap = {
  //       "message": messageController.text,
  //       "sendBy": Constants.myName,
  //       "time": DateTime.now().millisecondsSinceEpoch
  //     };
  //     databaseMethods.addConversationMessage(widget.chatRoomId,messageMap) ;
  //     messageController.text = "";
  //     databaseMethods.updateChatroom(widget.chatRoomId);
  //   }
  // }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: (){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => ChatScreen()));
                  },
                  icon: Icon(Icons.arrow_back,color: Colors.black,),
                ),

                SizedBox(width: 2,),
                CircleAvatar(
                  child: Text("${widget.userName.substring(0, 1).toUpperCase()}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w500)),
                  backgroundColor: Colors.greenAccent,
                  maxRadius: 20,
                ),
                SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(widget.userName,style: TextStyle( fontSize: 20 ,fontWeight: FontWeight.w600),),
                      SizedBox(height: 6,),
                      Text("Online",style: TextStyle(color: Colors.black, fontSize: 15),),
                    ],
                  ),
                ),
                Icon(Icons.settings,color: Colors.black,),
              ],
            ),
          ),
        ),
      ),
      body:
      Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: chatMessageList(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: textFieldInputDecoration("Message..."),
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0x36FFFFFF),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              // gradient: LinearGradient(colors: [
                              //   const Color(0x36FFFFFF),
                              //   const Color(0x0FFFFFFF)
                              // ]),
                              borderRadius: BorderRadius.circular(35)),
                          padding: EdgeInsets.all(6),
                          child: Image.asset("assets/images/send.png")),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile({this.message, this.isSendByMe});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 14, right: isSendByMe ? 14 : 0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Color(0xff5adced),
          gradient: LinearGradient(
            colors: isSendByMe
                ? [ const Color(0xff5adced), const Color(0xff9845f3)]
                : [const Color(0xfff5bf93), Color(0xffceaaf3)],
          ),
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.black, fontSize: 17),
        ),
      ),
    );
  }
}
