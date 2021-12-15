import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

final Future<FirebaseApp> _initialization = Firebase.initializeApp();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context,snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Something Went Wrong !!"),);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.pink,
                backgroundColor: Colors.pink,
                accentColor: Colors.deepPurple,
                accentColorBrightness: Brightness.dark,
                buttonTheme: ButtonTheme.of(context).copyWith(
                  textTheme: ButtonTextTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  )
                )
              ),
              home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context,userSnapshot) {
                  if(userSnapshot.hasData){
                    return ChatScreen();
                  } else {
                    return AuthScreen();
                  }
                },
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        }
    );
  }
}
