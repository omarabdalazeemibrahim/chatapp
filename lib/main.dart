import 'package:chatapp/screens/auth_screen.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/screens/splash_screen.dart';
import 'package:chatapp/widgets/Auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
 await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,

          backgroundColor: Colors.pink,
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.purple,
            textTheme: ButtonTextTheme.primary,shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          )
          ),
          accentColor: Colors.deepPurple,
          accentColorBrightness: Brightness.dark),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx,snapShot) {
          if(snapShot.connectionState==ConnectionState.waiting){
            return SplashScreen();
          }
         if(snapShot.hasData)
           {
             return ChatScreen();
           }
         else{
           return AuthScreen();
         }
      },
      ),
    );
  }
}
