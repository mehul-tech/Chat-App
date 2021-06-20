import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'conversation.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTextEditingController =
      new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  initiateSearch() async {
    await databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  createChatRoomAndStartConversation(
      {String username, String email, int index}) {
    // print("email: ${Constants.myEmail}");
    // print("name: ${Constants.myName}");
    if (email != Constants.myEmail) {
      String chatRoomId = getChatRoomId(email, Constants.myEmail);

      List<String> users = [username, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId
      };
      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => Conversation(chatRoomId: chatRoomId, name: username)));
    } else {
      print("it's you");
    }
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                username: searchSnapshot.documents[index].data["name"],
                email: searchSnapshot.documents[index].data["email"],
                index: index,
              );
            })
        : Container();
  }

  QuerySnapshot searchSnapshot;

  Widget searchTile({String username, String email, int index}) {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        // color: Colors.white12,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: biggerTextStyle(),
              ),
              Text(
                email,
                style: simpleTextStyle(),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(
                  username: username, email: email, index: index);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("Message"),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        children: [
          Container(
            color: Colors.black87,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white10,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchTextEditingController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Search Username",
                            hintStyle: TextStyle(
                              color: Colors.white54,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          initiateSearch();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white24,
                                Colors.white10,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Icon(
                            Icons.search,
                            color: Colors.white54,
                            size: 25.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                searchList(),
              ],
            ),
          ),
        ],
      )),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
