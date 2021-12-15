import 'dart:io';

import 'package:chat_app/widgets/picker/image_preview.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String userName, String password, File imageFile, bool isLogin,BuildContext context) submitForm;
  final bool isLoading;
  const AuthForm({Key? key, required this.submitForm,required this.isLoading}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var isLogin = true;
  String _userEmail = "";
  String _userPassword = "";
  String _userName = "";
  File? userImage;

  void _pickedImage(File pickedImg){
    userImage = pickedImg;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (userImage == null ){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Upload an Image !"), backgroundColor: Theme.of(context).errorColor,));
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitForm(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        userImage!,
        isLogin,
        context
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(!isLogin)
                      ImagePreview(imagePickFn: _pickedImage,),
                    TextFormField(
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains("@")) {
                          return "Please Enter a Valid Email Address";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email Address",
                      ),
                      onSaved: (value) {
                        _userEmail = value!;
                      },
                    ),
                    if(!isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 3) {
                          return "Username must be more than 2 characters";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: "Username",
                      ),
                      onSaved: (value) {
                        _userName = value!;
                      },
                    ),
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return "Password must be more than 5 characters";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: "Password",
                      ),
                      obscureText: true,
                      onSaved: (value) {
                        _userPassword = value!;
                      },
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    widget.isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(onPressed: _trySubmit, child: isLogin ? Text("Login") : Text("Signup")),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: isLogin
                            ? Text("Not yet on MetaGram ? Join now !")
                            : Text("Have an Account on MetaGram ? Login !"))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
