import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicapp002/account.dart';
import 'package:musicapp002/fauth.dart';
import 'package:musicapp002/loading.dart';
import 'package:musicapp002/login.dart';
import 'package:musicapp002/spinner.dart';
import 'stylingtextformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:musicapp002/homepage.dart';
import 'package:musicapp002/fauth.dart';

class Signuppage extends StatefulWidget {
  @override
  _SignuppageState createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  String email = '';
  String password = '';
  bool loading = false;
  String error = '';
  final _formkey = GlobalKey<FormState>();
  final Fauth _auth = Fauth();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(height);
    print(width);
    return loading == true
        ? Spinkit()
        : Scaffold(
            body: Form(
              key: _formkey,
              child: ListView(
                children: [
                  Container(
                    color: Colors.black,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.black),
                          height: height / 2,
                          width: width,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                        //  height: 20,
                                        ),
                                    Container(
                                      height: height / 2,
                                      width: width / 2,
                                      color: Colors.black45,
                                      child: Center(
                                        child: Text(
                                          "\n\t\tSignUp\n"
                                          "\t\t\t\t\t and \n"
                                          "\t\t\t become\n"
                                          "\t\t\t\t\t a\n"
                                          "\t\t Muser\n",
                                          style: TextStyle(
                                              fontFamily: "Pepsi",
                                              //fontWeight: FontWeight.bold,
                                              fontSize: 30.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: height / 2,
                                  width: width / 2,
                                  color: Colors.black45,
                                  child: Image.network(
                                      "https://i.pinimg.com/originals/75/eb/b2/75ebb2356439e1bbddad8db9d6abde99.jpg"),
                                )
                              ],
                            ),
                          ),
                          //      color: Colors.blue,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50.0),
                                  topRight: Radius.circular(50.0)),
                              color: Color(0xFF414345)),
                          height: height / 1.60,
                          width: width,
                          child: Column(
                            children: [
                              Text(
                                "\nMUSER SignUp",
                                style: TextStyle(
                                    fontFamily: "Pepsi",
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 25.0),
                              ),
                              SizedBox(
                                height: height / 17.86,
                                child: Text(
                                  "\ncreate   your   muser   account   here ",
                                  style: TextStyle(
                                      fontFamily: "Pepsi",
                                      color: Colors.grey,
                                      //fontWeight: FontWeight.bold,
                                      // fontStyle: FontStyle.italic,
                                      fontSize: 10.0),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 33.0, right: 33.0),
                                    child: TextFormField(
                                        validator: (val) {
                                          return val.isEmpty
                                              ? 'please enter your email address'
                                              : null;
                                        },
                                        onChanged: (val) => email = val,
                                        decoration: styling.copyWith(
                                            hintText: "Email")),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height / 32.51,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 33.0, right: 33.0),
                                    child: TextFormField(
                                        obscureText: true,
                                        validator: (val) {
                                          return val.length < 6
                                              ? 'Password should contain atleast 6 charachters'
                                              : null;
                                        },
                                        onChanged: (val) => password = val,
                                        decoration: styling.copyWith(
                                            hintText: "Password")),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height / 34.15,
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    width: width / 4.11,
                                  ),
                                  RaisedButton(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    onPressed: () async {
                                      if (_formkey.currentState.validate()) {
                                        setState(() {
                                          loading = true;
                                        });
                                        print(
                                            "sqdbhbhdbwgdgyw${email} ${password}");
                                        dynamic result = await _auth
                                            .SignupwithEmailandPassword(
                                                email, password);
                                        print(result);
                                        if (result is String) {
                                          if (result ==
                                              "[firebase_auth/email-already-in-use] The email address is already in use by another account.") {
                                            setState(() {
                                              error =
                                                  'This Account is already in use try';
                                            });
                                          } else if (result ==
                                              "[firebase_auth/invalid-email] The email address is badly formatted.") {
                                            setState(() {
                                              error =
                                                  'please enter a valid email id';
                                            });
                                          }
                                        } else {
                                          print("user signed in");
                                          setState(() {
                                            error = '';
                                          });
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Homepage(
                                                  username: result.email,
                                                ),
                                              ));
                                        }
                                        setState(() {
                                          loading = false;
                                        });
                                        print('tcftygwudgygewdguwgedd');
                                        print(result);
                                        print(error);
                                      }
                                    },
                                    child: Text(
                                      "SignUp",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Pepsi",
                                          //fontWeight: FontWeight.bold,
                                          fontSize: 15.0),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width / 16.45,
                                  ),
                                  RaisedButton(
                                    color: CupertinoColors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Loginpage(),
                                          ));
                                    },
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Pepsi",
                                          //fontWeight: FontWeight.bold,
                                          fontSize: 15.0),
                                    ),
                                  ),
                                ],
                              ),
                              // SizedBox(
                              //   height: 20,
                              // ),
                              Text(
                                error,
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
