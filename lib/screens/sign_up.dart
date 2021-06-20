import 'package:chat_app/helper/helperFunction.dart';
import 'package:chat_app/screens/sign_in.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_room_screen.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController usernameEditingController = new TextEditingController();
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  AuthMethods authMethods = new AuthMethods();

  final formKey = GlobalKey<FormState>();

  void validateAndSave() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      signMeUp();
      print('Form is valid');
    } else {
      print('Form is invalid');
    }
  }

  bool isLoading = false;

  DatabaseMethods databaseMethods = new DatabaseMethods();

  signMeUp() async {
    setState(() {
      isLoading = true;
    });

    bool isUserNameExist = false;

    QuerySnapshot searchSnapshot;

    await databaseMethods
        .getUserByUsername(usernameEditingController.text)
        .then((value) {
      print(value);
      setState(() {
        searchSnapshot = value;
      });
    });

    if (searchSnapshot.documents.isEmpty) {
      authMethods
          .signUpWithEmailAndPassword(
              emailEditingController.text, passwordEditingController.text)
          .then((value) {
        print("$value");
        if (value != null) {
          Map<String, String> userInfoMap = {
            "name": usernameEditingController.text,
            "email": emailEditingController.text,
            "password": passwordEditingController.text
          };
          HelperFunction.saveUserLoggedInSharedPref(true);
          HelperFunction.saveUserNameSharedPref(usernameEditingController.text);
          HelperFunction.saveUserEmailSharedPref(emailEditingController.text);
          databaseMethods.toUploadUserInfo(userInfoMap);
          // databaseMethods.addNewUser(usernameEditingController.text);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => ChatRoom()));
        } else {
          HelperFunction.saveUserLoggedInSharedPref(false);
          setState(() {
            isLoading = false;
          });
        }
      });
    } else {
      print("username already exist");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(20.0),
                alignment: Alignment.center,
                color: Colors.black87,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (val) {
                              return RegExp(
                                          r"^(?=.{8,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$")
                                      .hasMatch(val)
                                  ? null
                                  : "Please Enter Correct Username";
                            },
                            controller: usernameEditingController,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("username"),
                          ),
                          TextFormField(
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val)
                                  ? null
                                  : "Please Enter Correct Email";
                            },
                            controller: emailEditingController,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("email"),
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (val) {
                              return val.length > 6
                                  ? null
                                  : "Enter Password 6+ characters";
                            },
                            style: simpleTextStyle(),
                            controller: passwordEditingController,
                            decoration: textFieldInputDecoration("password"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () {
                    //         // Navigator.push(
                    //         //     context,
                    //         //     MaterialPageRoute(
                    //         //         builder: (context) => ForgotPassword()));
                    //       },
                    //       child: Container(
                    //           padding: EdgeInsets.symmetric(
                    //               horizontal: 16, vertical: 8),
                    //           child: Text(
                    //             "Forgot Password?",
                    //             style: simpleTextStyle(),
                    //           )),
                    //     )
                    //   ],
                    // ),
                    SizedBox(
                      height: 66,
                    ),
                    GestureDetector(
                      onTap: () {
                        validateAndSave();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xff007EF4),
                                const Color(0xff2A75BC)
                              ],
                            )),
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Sign Up",
                          style: biggerTextStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Sign Up with Google",
                        style: TextStyle(
                          fontSize: 17,
                          // color: CustomTheme.textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: simpleTextStyle(),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) => SignIn()));
                          },
                          child: Text(
                            "Sign In now",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
