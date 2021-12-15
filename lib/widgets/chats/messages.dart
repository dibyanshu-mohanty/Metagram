import 'package:chat_app/widgets/chats/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.value(FirebaseAuth.instance.currentUser!.uid),
      builder: (context,futureSnapshot)
        {
          if (futureSnapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('chat').orderBy("sentAt",descending: true).snapshots(),
              builder: (context,chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }
                return ListView.builder(
                    reverse: true,
                    itemCount: chatSnapshot.data!.docs.length,
                    itemBuilder: (context,index) =>
                        ChatBubble(
                          key: ValueKey(chatSnapshot.data!.docs[index].id),
                          message:chatSnapshot.data!.docs[index]['text'],
                          isMe: chatSnapshot.data!.docs[index]['userId'] == futureSnapshot.data,
                          username: chatSnapshot.data!.docs[index]['username'],
                          userImage: chatSnapshot.data!.docs[index]['userImage'],
                        )
                );
              }
          );
        }
    );
  }
}
