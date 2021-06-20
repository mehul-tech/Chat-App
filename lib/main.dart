import 'package:chat_app/helper/helperFunction.dart';
import 'package:chat_app/screens/chat_room_screen.dart';
import 'package:chat_app/screens/sign_in.dart';
import 'package:chat_app/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;
  String s = "";
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    s = "";
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunction.getUserLoggedInSharedPref().then((value) {
      setState(() {
        print(value);
        s = "LoggedIn";
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: s == ""
          ? Container()
          : userIsLoggedIn
              ? ChatRoom()
              : SignIn(),
    );
  }
}
