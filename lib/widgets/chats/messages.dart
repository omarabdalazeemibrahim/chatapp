import 'package:chatapp/widgets/chats/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chat")
            .orderBy("createdAt", descending: false)
            .snapshots(),
        builder:
            (BuildContext ctx, AsyncSnapshot<QuerySnapshot> asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          final docs = asyncSnapshot.data!.docs;
          return ListView.builder(
            //   reverse:  true,
            itemCount: docs.length,
            itemBuilder: (ctx, index) => MessageBubble(
              userName: docs[index]["username"],
              key: ValueKey(docs[index].id),
              userImage: docs[index]["userImage"],
              message: docs[index]["text"],
              isMe: docs[index]["userId"]==FirebaseAuth.instance.currentUser!.uid,
              
            ),
          );
        },
      ),
    );
  }
}
