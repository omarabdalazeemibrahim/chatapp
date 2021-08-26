import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _controller = TextEditingController();
  String _enteredMessage = "";

  _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser;
    final userData =
        await FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
    FirebaseFirestore.instance.collection("chat").add({
      "text": _enteredMessage,
      "createdAt": Timestamp.now(),
      "username":userData["username"],
      "userId":user.uid,
      "userImage":userData["userImage"]
    });
    _controller.clear();
    setState(() {
      _enteredMessage="";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                autocorrect: true,
                enableSuggestions: true,
                textCapitalization: TextCapitalization.sentences,
            controller: _controller,
            decoration: InputDecoration(
                hintText: "Send a message", fillColor: Colors.black,enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor
              )
            )),
            onChanged: (val) {
              setState(() {
                _enteredMessage = val;
              });
            },
          )),
          IconButton(
              color: Theme.of(context).primaryColor,
              disabledColor: Colors.black,
              icon: Icon(Icons.send),
              onPressed: () {
                if (_enteredMessage.trim().isEmpty)
                  return null;
                else {
                  _sendMessage();
                }
              } // _enteredMessage.trim().isEmpty ? null : _sendMessage(),

              )
        ],
      ),
    );
  }
}
