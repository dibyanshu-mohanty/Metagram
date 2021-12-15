import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = "";

  final _controller = TextEditingController();

  void sendMessage() async{
    FocusScope.of(context).unfocus();
    var userID = FirebaseAuth.instance.currentUser!.uid;
    var userName = await FirebaseFirestore.instance.collection('users').doc(userID).get();
    FirebaseFirestore.instance
        .collection('chat')
        .add({
      "text": _enteredMessage,
      "sentAt": Timestamp.now(),
      "userId": userID,
      "username": userName['username'],
      "userImage": userName['imageUrl']
        });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      padding: EdgeInsets.all(8.0),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 5.0,
        margin: EdgeInsets.all(6.0),
        child: Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    hintText: "Message...", border: InputBorder.none),
                onChanged: (value) {
                  setState(() {
                    _enteredMessage = value;
                  });
                },
              ),
            )),
            IconButton(
                onPressed: _enteredMessage.trim().isEmpty ? null : sendMessage,
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).primaryColor,
                ))
          ],
        ),
      ),
    );
  }
}
