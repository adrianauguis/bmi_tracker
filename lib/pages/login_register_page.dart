import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async{
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text
      );
      print(_controllerEmail.text);
    } on FirebaseAuthException catch (e){
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async{
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title(){
    return Text("Login");
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ){
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _errorMessage(){
    return Text (errorMessage == '' ? '' : "Hmmmmm? $errorMessage");
  }

  Widget _submitButton(){
    return ElevatedButton(
        onPressed: isLogin? signInWithEmailAndPassword : createUserWithEmailAndPassword,
        child: Text(isLogin ? 'Login' : 'Register')
    );
  }


  Widget _loginOrRegisterButton(){
    return TextButton(
        onPressed: (){
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(isLogin ? "Register Instead " : "Login Instead")
    );
  }
  Widget _optionMessage(){
    return const Text ("Sign in with Google");
  }

  Widget _googleImage(){
    return SizedBox(
      height: 50,
      width: 200,
      child: InkWell(
        child: Container(
            child: const Image(
              image: AssetImage("assets/google_logo.png"),
            ),
          ),
        onTap: (){
          Auth().signInWithGoogle();
        },

        ),
      );
  }

  Widget _logoImage(){
    return SizedBox(
      height: 250,
      width: 300,
      child: InkWell(
        child: Container(
          child: const Image(
            image: AssetImage("assets/splash logo.png"),
          ),
        ),
        onTap: (){
          Auth().signInWithGoogle();
        },

      ),
    );
  }

  @override


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00FFDE),
      body: ListView(
          children: [
                SizedBox(
                  child:
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _logoImage(),
                          _entryField('Email', _controllerEmail),
                          _entryField('Password', _controllerPassword),
                          _errorMessage(),
                          _submitButton(),
                          _loginOrRegisterButton(),
                          _optionMessage(),
                          _googleImage(),
                        ]
                    ),
                    ),
                ),
          ],
        ),
    );
  }
}
