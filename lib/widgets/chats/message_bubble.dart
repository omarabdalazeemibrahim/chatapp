import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final Key key;
  final String message;
  final String userName;
  final String userImage;
  final bool isMe;

  MessageBubble(
      {
        required this.key,
        required this.message,
        required this.userImage,
        required this.userName,
        required this.isMe
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 11),
      child: Stack(

        children: [
          Row(

            mainAxisAlignment: isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              Container(

                decoration: BoxDecoration(
                    color: isMe? Theme.of(context).primaryColor : Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(14),
                      topLeft: Radius.circular(14),
                      bottomLeft: isMe ? Radius.circular(0) : Radius.circular(16),
                      bottomRight: !isMe ? Radius.circular(0) : Radius.circular(16),
                    )
                ),
                width: 140,
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 16),
                margin: EdgeInsets.symmetric(vertical: 2,horizontal: 8),
                child: Column(
                  crossAxisAlignment: isMe ? CrossAxisAlignment.start :CrossAxisAlignment.end,
                  children: [
                    Text(userName
                      ,style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMe?Theme.of(context).accentTextTheme.headline6!.color:Colors.black
                      ),
                    ),
                    Text(message
                      ,style: TextStyle(
                          color: isMe ? Theme.of(context).accentTextTheme.headline6!.color:Colors.black
                      ),
                      textAlign: isMe ? TextAlign.start:TextAlign.end,
                    )
                  ],
                ),
              )
            ],
          ),
          Positioned(
            child: CircleAvatar(

              backgroundImage: NetworkImage(userImage),

          ),
          top: -10,
          left: isMe ? 120 :null,right: !isMe ? 120:null,
          )
        ],
        overflow: Overflow.visible,

      ),
    );
  }
}
