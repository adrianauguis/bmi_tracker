import 'package:final_bmi/pages/reg_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';
import '../deco/header.dart';
import '../deco/themehelper.dart';
import 'home_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;

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

  Widget _submitButton(BuildContext context){
    return Container(
      decoration: ThemeHelper().buttonBoxDecoration(context),
      child: ElevatedButton(
          style: ThemeHelper().buttonStyle(),
          onPressed: (){
            if (_formKey.currentState!.validate()) {
              signInWithEmailAndPassword();
            }
          },
          child: Text('Login'.toUpperCase(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )
      ),
    )
    );
  }

  Widget _loginOrRegisterButton(){
    return TextButton(
        onPressed: (){
          setState(() {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const RegistrationPage()));
          });
        },
        child: const Text("Register Instead")
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00FFDE),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 150,
              child: const HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key:_formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 30,),
                        const SizedBox(height: 30,),
                        const SizedBox(height: 30,),
                        SizedBox(
                          height: 300,
                          width: 300,
                          child: InkWell(
                            child: Container(
                              child: const Image(
                                image: AssetImage("assets/splash logo.png"),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                          controller: _controllerEmail,
                          decoration: ThemeHelper().textInputDecoration('Email', 'Enter your first name'),
                          validator: (val) {
                            if(!(val!.isEmpty) && !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)){
                              return "Enter a valid email address";
                            }
                            return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: _controllerPassword,
                            decoration: ThemeHelper().textInputDecoration('Password', 'Enter your password'),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        _errorMessage(),
                        _submitButton(context),
                        _loginOrRegisterButton(),
                        _optionMessage(),
                        _googleImage(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

      ),
    );
  }
}
