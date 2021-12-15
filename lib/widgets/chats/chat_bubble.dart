import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String username;
  final String userImage;
  const ChatBubble({Key? key,required this.message,required this.isMe,required this.username,required this.userImage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe ? Colors.grey.shade300  : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14.0),
                    topRight: Radius.circular(14.0),
                    bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(14.0),
                    bottomRight: isMe ? Radius.circular(0) : Radius.circular(14.0)
                ),
              ),
              width: 200,
              padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 10.0),
              margin: EdgeInsets.symmetric(horizontal: 8.0,vertical: 16.0),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(username,style: TextStyle(
                          color: isMe ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0
                      ),),
                  SizedBox(height: 5.0,),
                  Text(message,style: TextStyle(color: isMe ? Colors.black : Colors.white),),
                ],
              ),
            ),
          ],
        ),
        Positioned(
            top: 0,
            left: isMe ? null : 180,
            right: isMe ? 180 : null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(userImage),
            )
        ),
      ],
      clipBehavior: Clip.none,
    );
  }
}
