import 'dart:io';

import 'package:chatapp/widgets/Auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _submitAuthForm(String email, String password, String username,
      File image, bool isLogin, BuildContext ctx) async {
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final Reference ref = FirebaseStorage.instance
            .ref()
            .child("user_image")
            .child(_auth.currentUser!.uid + "jpg");
        UploadTask task=  ref.putFile(image);
        var url;
            await task.whenComplete(()  async{
            url = await ref.getDownloadURL();
         });


        await FirebaseFirestore.instance
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .set({
          "email": email,
          "username": username,
          "password": password,
          "userImage":url.toString(),
        });
      }
    } on FirebaseAuthException catch (e) {
      String message = "";
      if (e.code == 'weak-password') {
        message = ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        message = ('The account already exists for that email.');
      } else if (e.code == 'user-not-found') {
        message = ('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        message = ('Wrong password provided for that user.');
      }
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                content: ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text("Exit")),
                title: Text(message),
              ));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                content: ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text("Exit")),
                title: Text(e.toString()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
