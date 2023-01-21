import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth.dart';
import '../deco/themehelper.dart';
import '../deco/header.dart';
import 'home_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerAge = TextEditingController();
  var gender;
  bool checkedValue = false;
  bool checkboxValue = false;
  String? errorMessage = '';

  Widget _errorMessage(){
    return Text (errorMessage == '' ? '' : "Hmmmmm? $errorMessage");
  }

  Future<void> createUserWithEmailAndPassword() async{
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
          age: int.parse(_controllerAge.text),
          fullName: _controllerName.text,
          gender: gender
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00FFDE),
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
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 30,),
                        const SizedBox(height: 30,),
                        const SizedBox(height: 30,),
                        SizedBox(
                          height: 150,
                          width: 150,
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
                            decoration: ThemeHelper().textInputDecoration('Email', 'Enter your email'),
                            validator: (val) {
                              if(!(val!.isEmpty) && !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)){
                                return "Enter a valid email address";
                              }
                            },
                          ),

                        ),
                        const SizedBox(height: 30,),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: _controllerPassword,
                            decoration: ThemeHelper().textInputDecoration('Password', 'Enter your password'),
                            validator: (value) {
                              return (value == '') ? 'Please enter your password' : null;
                            },
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: _controllerName,
                            decoration: ThemeHelper().textInputDecoration('Name', 'Enter your name'),
                            validator: (value) {
                              return (value == '') ? 'Please enter your name' : null;
                            },
                          ),

                        ),
                        const SizedBox(height: 30,),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: _controllerAge,
                            decoration: ThemeHelper().textInputDecoration('Age', 'Enter your age'),
                            validator: (value) {
                              return (value == '') ? 'Please enter your Age' : null;
                            },
                          ),
                        ),
                        const SizedBox(height: 30,),
                        Container(
                            decoration: ThemeHelper().inputBoxDecorationShaddow(),
                            height: 60,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(border: OutlineInputBorder()),
                              hint: Text('Gender'),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Male',
                                    child: Text('Male'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Female',
                                    child: Text('Female'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Other',
                                    child: Text('Other'),
                                  )
                                ],
                                onChanged: (g1){
                                  gender = g1.toString();

                                }
                            ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            decoration: ThemeHelper().textInputDecoration(
                                "Mobile Number",
                                "Enter your mobile number"),
                            keyboardType: TextInputType.phone,
                            validator: (val) {
                              if(!(val!.isEmpty) && !RegExp(r"^(\d+)*$").hasMatch(val)){
                                return "Enter a valid phone number";
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        FormField<bool>(
                          builder: (state) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: checkboxValue,
                                        onChanged: (value) {
                                          setState(() {
                                            checkboxValue = value!;
                                            state.didChange(value);
                                          });
                                        }),
                                    const Text("I accept all terms and conditions.", style: TextStyle(color: Colors.grey),),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    state.errorText ?? '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Theme.of(context).errorColor,fontSize: 12,),
                                  ),
                                )
                              ],
                            );
                          },
                          validator: (value) {
                            if (!checkboxValue) {
                              return 'You need to accept terms and conditions';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Register".toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                createUserWithEmailAndPassword();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const HomePage()
                                    ),
                                        (Route<dynamic> route) => false
                                );
                              }
                            },
                          ),
                        ),
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
