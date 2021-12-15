import 'dart:io';

import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  bool isLoading = false;

  void _submitAuthForm(
      String email, String username, String password, File imageFile, bool isLogin,BuildContext ctx) async {
    UserCredential _authResult;
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        _authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        _authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance.ref().child('user_image').child(_authResult.user!.uid + '.png');

        await ref.putFile(imageFile);

        final url = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(_authResult.user!.uid).set({
          "username" : username,
          "email" : email,
          "imageUrl": url,
        });
      }
    } on FirebaseAuthException catch (e) {
      var message = "An Error Occurred ! Please Try Again.";
      if (e.message != null) {
        message = e.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        isLoading = false;
      });
    } catch (e){
      print(e);
      setState(() {
        isLoading = true;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          Container(
              width: double.infinity,
              child: Image.asset(
                "assets/signup.png",
                fit: BoxFit.cover,
              )),
          AuthForm(submitForm: _submitAuthForm,isLoading: isLoading),
          Container(
            height: MediaQuery.of(context).size.height * 0.20,
            child: Center(child: Image.asset("assets/logo.png",fit: BoxFit.cover,)),
          ),
        ],
      ),
    );
  }
}
