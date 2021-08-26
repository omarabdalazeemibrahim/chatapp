import 'dart:io';

import 'package:chatapp/widgets/pickers/user_image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String username, File image,
      bool isLogin, BuildContext ctx ) isSubmitFn;
  bool isLoading;

  AuthForm(this.isSubmitFn, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}


class _AuthFormState extends State<AuthForm> {

  final _formKey = GlobalKey<FormState>();

  bool _isLogin = true;
  String _email = "";
  String _password = "";
  String _username = "";
  File _userImageFile = File("");

  void _pickImage(File pickedImage) {
    _userImageFile = pickedImage;
  }

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!_isLogin && _userImageFile.path.isEmpty) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text("Please Pick An Image"), backgroundColor: Theme
              .of(context)
              .errorColor,),);
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.isSubmitFn(
          _email.trim(), _password.trim(), _username.trim(),_userImageFile, _isLogin, context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
      SingleChildScrollView(
        child: Card(

            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Column(
                children: [
                  if(_isLogin)
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      child: Image.asset(
                        "images/htttt.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  if(!_isLogin) UserImagePicker(_pickImage),
                  SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(

                        mainAxisSize: MainAxisSize.min,

                        children: [

                          TextFormField(
                            key: ValueKey("email"),
                            validator: (val) {
                              if (val!.isEmpty || !val.contains("@")) {
                                return "Please Enter Valid Email Address";
                              }
                              return null;
                            },
                            autocorrect: false,
                            enableSuggestions: false,
                            textCapitalization: TextCapitalization.none,
                            onSaved: (val) => _email = val!,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Email Address",
                            ),
                          ),
                          if (!_isLogin)
                            TextFormField(
                              key: ValueKey("username"),
                              validator: (val) {
                                if (val!.isEmpty || val.length < 4) {
                                  return "Please Enter at Least 4 Characters";
                                }
                                return null;
                              },
                              autocorrect: true,
                              enableSuggestions: false,
                              textCapitalization: TextCapitalization.words,
                              onSaved: (val) => _username = val!,
                              decoration: InputDecoration(
                                  labelText: "UserName"),
                            ),
                          TextFormField(
                            key: ValueKey("password"),
                            validator: (val) {
                              if (val!.isEmpty || val.length < 7) {
                                return "Password must be at Least 7 Characters";
                              }
                              return null;
                            },
                            onSaved: (val) => _password = val!,
                            decoration: InputDecoration(labelText: "Password"),
                            obscureText: true,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          if(widget.isLoading)

                            CircularProgressIndicator()
                          ,
                          if(!widget.isLoading)

                            ElevatedButton(
                              onPressed: () => _submit(),

                              child: Text(_isLogin ? "Log In" : "Sign Up"),),
                          if(!widget.isLoading)
                            FlatButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(_isLogin
                                    ? "Create New Account "
                                    : "I Already Have an Account")),
                        ],
                      ),
                    ),
                  ),
                ]
            )

        ),
      ),
    );
  }
}
