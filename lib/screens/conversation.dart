import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  final String chatRoomId, name;
  Conversation({this.chatRoomId, this.name});
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  TextEditingController messageController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatMessageStream;

  Widget chatMessagesList() {
    return Container(
      margin: EdgeInsets.all(10.0),
      alignment: Alignment.topLeft,
      height: MediaQuery.of(context).size.height * 0.75,
      child: StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshaot) {
          return snapshaot.hasData
              ? ListView.builder(
                  itemCount: snapshaot.data.documents.length,
                  itemBuilder: (context, index) {
                    return messageTile(
                        snapshaot.data.documents[index].data["message"],
                        snapshaot.data.documents[index].data["sendBy"] ==
                            Constants.myName);
                  },
                )
              : Container();
        },
      ),
    );
  }

  Widget messageTile(String message, isSendByMe) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(8.0),
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSendByMe
                  ? [Colors.blue[900], Colors.blue[800]]
                  : [Colors.white24, Colors.white12],
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
                bottomLeft: Radius.circular(isSendByMe ? 25.0 : 0),
                bottomRight: Radius.circular(!isSendByMe ? 25.0 : 0))),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.0,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  @override
  void initState() {
    var val = databaseMethods.getConversationMessages(widget.chatRoomId);
    chatMessageStream = val;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Container(
        color: Colors.black87,
        child: ListView(
          children: [
            chatMessagesList(),
            Container(
              height: MediaQuery.of(context).size.height * 0.13,
                          child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10.0),
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
                            controller: messageController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Message...",
                              hintStyle: TextStyle(
                                color: Colors.white54,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            sendMessage();
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
                              Icons.send,
                              color: Colors.white54,
                              size: 25.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // chatMessagesList(),
          ],
        ),
      ),
    );
  }
}
