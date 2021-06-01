import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:chat_app/model/user.dart';
import 'chatroomscreen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'groupConversation.dart';

const List<StaggeredTile> _staggeredTiles = <StaggeredTile>[
  StaggeredTile.count(2, 3),
  StaggeredTile.count(2, 2),
  StaggeredTile.count(2, 3),
  StaggeredTile.count(2, 2),
  StaggeredTile.count(2, 3),
  StaggeredTile.count(2, 2),
  StaggeredTile.count(2, 3),
  StaggeredTile.count(2, 2),
  StaggeredTile.count(2, 3),
  StaggeredTile.count(2, 2),
  StaggeredTile.count(2, 1),
];

const List<Widget> _tiles = <Widget>[
  groupTile(Colors.green, Icons.widgets,"Competitive Programming"),
  groupTile(Colors.lightBlue, Icons.wifi,"Web Development"),
  groupTile(Colors.amber, Icons.panorama_wide_angle,"Android Development"),
  groupTile(Colors.brown, Icons.map,"Data Science"),
  groupTile(Colors.deepOrange, Icons.send,"Machine Learning"),
  groupTile(Colors.indigo, Icons.airline_seat_flat,"Artificial intelligence"),
  groupTile(Colors.red, Icons.bluetooth,"Robotics"),
  groupTile(Colors.pink, Icons.battery_alert,"Automation"),
  groupTile(Colors.purple, Icons.desktop_windows,"Aerodynamics"),
  groupTile(Colors.blue, Icons.radio,"Organic Chemistry"),
  groupTile(Colors.blue, Icons.radio,"Thermodynamics"),
];

class chatGroups extends StatefulWidget {
  @override
  _chatGroupsState createState() => _chatGroupsState();
}

class _chatGroupsState extends State<chatGroups> {
  @override
  AuthMethods authMethods = new AuthMethods();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Connect'), actions: [
        GestureDetector(
          onTap: () {
            authMethods.signOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Authenticate()));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.exit_to_app),
          ),
        ),
        Container(
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
      ]),
      body:
          Padding(
              padding: const EdgeInsets.only(top: 12),
              child: StaggeredGridView.count(
                crossAxisCount: 4,
                staggeredTiles: _staggeredTiles,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                padding: const EdgeInsets.all(4),
                children: _tiles,
              )),
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
        animationCurve: Curves.easeIn,
        onTap: (index){
          indexInfo.storedIndex=index;
          if(index==0){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => chatGroups()));
          }
          else if(index==1){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatScreen()));
          }
          else if(index==2){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => (Container())));
          }
        },
      ),
    );
  }
}
class groupTile extends StatelessWidget {
  @override
  const groupTile(this.backgroundColor, this.iconData, this.groupId);
  final Color backgroundColor;
  final IconData iconData;
  final String groupId;
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: InkWell(
        onTap: () {
          group.groupId=groupId;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GroupConversationScreen(
                    groupId: groupId,
                  )));
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: Icon(
                    iconData,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(groupId,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: Colors.white),textAlign: TextAlign.center,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

