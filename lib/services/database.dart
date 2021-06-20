import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods {
//   addNewUser(username) async{
//     await Firestore.instance.collection("Username").add({'name': username}).catchError((e) {
//       print(e);
//     });
//   }

  // getUsersName(String username) async {
  //   return await Firestore.instance
  //       .collection("Username")
  //       .where("name", isEqualTo: username)
  //       .getDocuments()
  //       .catchError((e) {
  //     print(e.toString());
  //   });
  // }

  Future getUserByUsername(String username) async {
    return Firestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  Future getUserByUserEmail(String useremail) async {
    return Firestore.instance
        .collection("users")
        .where("email", isEqualTo: useremail)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }

  toUploadUserInfo(userMap) {
    Firestore.instance.collection("users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .setData(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e);
    });
  }

  getConversationMessages(String chatRoomId) {
    return Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String username) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: username)
        .snapshots();
  }
}
