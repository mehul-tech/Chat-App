import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperFunction.dart';
import 'package:chat_app/screens/conversation.dart';
import 'package:chat_app/screens/search.dart';
import 'package:chat_app/screens/sign_in.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomStream;

  Widget chatRoomList() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return chatRoomsTile(
                        snapshot.data.documents[index].data["users"],
                        snapshot.data.documents[index].data["chatRoomId"]);
                  },
                )
              : Container();
        },
      ),
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunction.getUserNameSharedPref();
    Constants.myEmail = await HelperFunction.getUserEmailSharedPref();

    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              size: 30.0,
            ),
            onPressed: () {
              authMethods.signOut();
              HelperFunction.saveUserLoggedInSharedPref(false);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => SignIn()));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchScreen(),
              ));
        },
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black87,
        child: chatRoomList(),
      ),
    );
  }

  Widget chatRoomsTile(List users, String chatRoomId) {
    String username = users[0] == Constants.myName ? users[1] : users[0];
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => Conversation(
                      name: username,
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 11.0),
        alignment: Alignment.center,
        child: Row(
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Text(
                username.substring(0, 1),
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              username,
              style: biggerTextStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
