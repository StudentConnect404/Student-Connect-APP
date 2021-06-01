import 'package:chat_app/model/user.dart';
import 'package:chat_app/views/chatroomscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/views/interest.dart';
import 'package:chat_app/helper/constants.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUPState createState() => _SignUPState();
}

class _SignUPState extends State<SignUp> {
  List<String> options = <String>[ 'year','First', 'Second','Third', 'Four'];
  String year = 'year';
  List<String> option = <String>[ 'branch','CSE', 'Mechanical','Chemical'];
  String batch = 'branch';
  bool isLoading = false;
  // BackendMethods methods = new BackendMethods();
  // BackendMethods methods = new BackendMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Helperfunctions helperfunctions = new Helperfunctions();

  final formkey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController =
  new TextEditingController();
  TextEditingController emailTextEditingController =
  new TextEditingController();
  TextEditingController passwordTextEditingController =
  new TextEditingController();
  // BackendMethods authService = new BackendMethods();
  AuthMethods authMethods = new AuthMethods();

  void addData(String name, String email){
    Info.user_Name= name;
    Constants.myName=name;
    Info.user_email = email;
    Info.year =year;
    Info.branch = batch;
    print("this is infoname ${Info.user_Name}");
  }
  okSignMUp() {
    if (formkey.currentState.validate()) {

      setState(() {
        isLoading = true;
      });

      authMethods
          .signUpWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text)

          .then((val) {
        print("harsh");
        Helperfunctions.saveUserEmailSharedPreference(
            emailTextEditingController.text);
        Helperfunctions.saveUserNameSharedPreference(
            userNameTextEditingController.text);

        Helperfunctions.saveUserLoggedInSharedPreference(true);
        addData(userNameTextEditingController.text,emailTextEditingController.text
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Interest()));
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
        child: Center(child: CircularProgressIndicator()),
      )
          : SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 30,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      TextFormField(
                          validator: (val) {
                            return val.isEmpty || val.length < 6
                                ? "This is not working"
                                : null;
                          },
                          controller: userNameTextEditingController,
                          style: textStyle(),
                          decoration:
                          textFieldInputDecoration("username")),
                      TextFormField(
                          controller: emailTextEditingController,
                          style: textStyle(),
                          decoration: textFieldInputDecoration("email")),
                      TextFormField(
                          obscureText: true,
                          validator: (val) {
                            return val.length > 6
                                ? null
                                : "Password must be greater than 6";
                          },
                          controller: passwordTextEditingController,
                          style: textStyle(),
                          decoration:
                          textFieldInputDecoration("password")),
                    ],
                  ),
                ),
                Container(
                    height:5
                ),
                Container(

                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.blue),
                        hintText: "Name",
                        fillColor: Colors.blue),
                    value: year,
                    onChanged: (String newValue) {
                      setState(() {
                        year = newValue;
                      });
                    },

                    style: const TextStyle(color: Colors.blue),
                    selectedItemBuilder: (BuildContext context) {
                      return options.map((String value) {
                        return Text(
                          year,
                          style: const TextStyle(color: Colors.white),
                        );
                      }).toList();
                    },
                    items: options.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                    height:5
                ),
                Container(

                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30.0),
                          ),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.blue[800]),
                        hintText: "Name",
                        fillColor: Colors.blue),
                    value: batch,
                    onChanged: (String value) {
                      setState(() {
                        batch = value;
                      });
                    },

                    style: const TextStyle(color: Colors.blue),
                    selectedItemBuilder: (BuildContext context) {
                      return options.map((String value) {
                        return Text(
                          batch,
                          style: const TextStyle(color: Colors.white),
                        );
                      }).toList();
                    },
                    items: option.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  child: Text("Forgot Password?", style: textStyle()),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    okSignMUp();
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
                      child: Text("Next", style: textStyle1())),
                ),
                SizedBox(height: 16),
                Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0xff007EF4),
                          const Color(0Xff2A75BC)
                        ]),
                        borderRadius: BorderRadius.circular(19)),
                    child:
                    Text("Sign In with Google", style: textStyle1())),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have account? ",
                      style: textStyle1(),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Text(
                        "SignIn now",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            decoration: TextDecoration.underline),
                      ),
                    ),
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