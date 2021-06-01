// import 'dart:html';
import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation_screen.dart';
import 'package:chat_app/views/sigin.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/views/groups.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Helperfunctions helperfunctions = new Helperfunctions();

  Stream chatRoomStream;

  Widget chatRoomList()  {
    print("Constants.myNmae");
    print(Constants.myName);
    // Constants.myName=Info.user_Name;
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    print(snapshot.data.documents[index].data["chatroomId"]);
                    return ChatRoomTile(
                        snapshot.data.documents[index].data["chatroomId"]
                            .toString()
                            .replaceAll("_", "")
                            .replaceAll(Constants.myName, ""),
                        snapshot.data.documents[index].data["chatroomId"]);
                  })
              : Container();
        });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await Helperfunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomStream = value;
        // print(
        //     "we got the data + ${chatRoomStream.toString()} this is name  ${Constants.myName}");
      });
    });
    // setState(() {});
  }
  getprint() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("USEREMAILKEY"));
    print(prefs.getString("USERNAMEKEY"));
  }

  Widget build(BuildContext context) {
    print("Username");
    print(Info.user_Name);
    if(Info.user_Name==null){
      return Container(
        child: TextButton(child: Text('Error! Please Sign In Again'),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            }),

      );
    }
    return Scaffold(
        appBar: AppBar(title:Text('Student Connect'), actions: [
          GestureDetector(
            onTap: () {
              getprint();
              authMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          ),
          GestureDetector(
            child: Container(
              width: 65,
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text("${Info.user_Name.substring(0, 1).toUpperCase()}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        ]),
        body: chatRoomList(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF8F48F7),
          child: Icon(Icons.search,),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchPlatform()));
          },
        ),
        bottomNavigationBar: CurvedNavigationBar(
          height: 60,
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Color(0xFF8F48F7),
        items: <Widget>[
          Icon(Icons.group,size: 20,color : Colors.blueGrey,),
          Icon(Icons.chat,size: 20,color : Colors.blueGrey,),
          Icon(Icons.settings,size: 20,color : Colors.blueGrey,),

          ],
          animationDuration: Duration(
            milliseconds: 500
          ),
          // animationCurve: Curves.easeIn,
          onTap: (index) {
            print(index);
            indexInfo.storedIndex = index;
            if (index == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => chatGroups()));
            }
            else if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatScreen()));
            }
            else if (index == 2) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => (Container())));
            }
          },
          index: 1,
        ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ConversationScreen(
                        chatRoomId: chatRoomId,
                        userName:userName,
                      )));
        },
        child: Container(
          height: 80,
          width: 70,
          decoration: BoxDecoration(
              // gradient: LinearGradient(
              //   colors: [Colors.blue, Colors.red],
              //   stops: [0.1,1],),
              // color: const Color.fromARGB(255, 133, 200, 198),
              // color: Color(0xffffde03),
              color: Colors.amber,
              // boxShadow: [
              //   BoxShadow(blurRadius: 0.3,spreadRadius: 1.5),
              // ],
              borderRadius: BorderRadius.circular(30)),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: Color(0xFF8F48F7),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Text("${userName.substring(0, 1).toUpperCase()}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w500)),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                userName,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('AppBar Demo'),
//         actions: <Widget>[
//           IconButton(
//             icon:   const Icon(Icons.add_alert),
//             tooltip: 'Show Snackbar',
//             onPressed: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('This is a snackbar'))
//               );
//             },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.search),
//         onPressed: () {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (context) => SearchPlatform()));
//         },
//       ),
//     );
//   }
// }

