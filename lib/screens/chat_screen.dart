import 'package:chat_app/widgets/chats/messages.dart';
import 'package:chat_app/widgets/chats/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  void initState() {
    FirebaseMessaging.instance.requestPermission();
    super.initState();
    FirebaseMessaging.onMessage.listen ((RemoteMessage message) {
      print(message.notification!.title);
      return;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(message.notification!.title);
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MetaGram "),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
                icon: Icon(Icons.more_vert,color: Colors.white,),
                items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: const [
                        Icon(Icons.exit_to_app,color: Colors.black,),
                        SizedBox(width: 10.0,),
                        Text("Logout"),
                  ],
                ),
              ),
              value: "logout",
            ),
            ],
              onChanged: (itemIdentifier){
                  if(itemIdentifier=="logout"){
                    FirebaseAuth.instance.signOut();
                  }
              },
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
