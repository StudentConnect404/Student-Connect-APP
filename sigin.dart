import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/model/user.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/widget.dart';
import 'chatroomscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<SignIn> {
  Helperfunctions helperfunctions = new Helperfunctions();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();

  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  saveSharedPreference (String userName)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("USERNAMEKEY", userName);
    print("pls come");
    print(prefs.getString("USERNAMEKEY"));
  }

  signIn() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      databaseMethods
          .getUserbyUserEmail(emailTextEditingController.text)
          .then((val) {
        snapshotUserInfo = val;
        saveSharedPreference(snapshotUserInfo.documents[0].data["name"]);
        print(snapshotUserInfo.documents[0].data["name"]);
        Info.user_Name=snapshotUserInfo.documents[0].data["name"];
        print("i dont knoe");
      });
      setState(() {
        isLoading = true;
      });
      authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        if (val != null) {
          Helperfunctions.saveUserLoggedInSharedPreference(true);
          Constants.myName=Info.user_Name;
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatScreen(
          )));
        }
      });
    }
  }
  fun() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('AppFirstTimeUse', false);
    print(prefs.getBool('AppFirstTimeUse'));
  }

  @override
  Widget build(BuildContext context) {
    fun();
    return  Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 30,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@ahduni.edu.in+")
                                    .hasMatch(val)
                                ? null
                                : "Provide a valid Email Id";
                          },
                          controller: emailTextEditingController,
                          style: textStyle(),
                          decoration: textFieldInputDecoration("email")),
                      TextFormField(
                          obscureText: true,
                          validator: (val) {
                            return val.isNotEmpty || val.length > 8
                                ? null
                                : "Please provide a valid Password with 6+ character";
                          },
                          controller: passwordTextEditingController,
                          style: textStyle(),
                          decoration: textFieldInputDecoration("password")),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    child: Text("Forgot Password?", style: textStyle()),
                  ),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    signIn();
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            const Color(0xff007EF4),
                            const Color(0Xff2A75BC)
                          ]),
                          borderRadius: BorderRadius.circular(19)),
                      child: Text("Sign In", style: textStyle1())),
                ),
                SizedBox(height: 16),
                // Container(
                //     alignment: Alignment.center,
                //     width: MediaQuery.of(context).size.width,
                //     padding: EdgeInsets.symmetric(vertical: 20),
                //     decoration: BoxDecoration(
                //         gradient: LinearGradient(colors: [
                //           const Color(0xff007EF4),
                //           const Color(0Xff2A75BC)
                //         ]),
                //         borderRadius: BorderRadius.circular(19)),
                //     child: Text("Sign In with Google", style: textStyle1())),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have account? ",
                      style: textStyle1(),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Create now",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
