import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicapp002/authenticatepage.dart';
import 'package:musicapp002/fauth.dart';
import 'package:musicapp002/homepage.dart';
import 'package:musicapp002/loading.dart';
import 'stylingtextformfield.dart';
import 'spinner.dart';

class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
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
    return loading == true
        ? Spinkit()
        : Scaffold(
            body: Form(
              key: _formkey,
              child: ListView(
                children: [
                  SafeArea(
                    child: Container(
                      color: Colors.black,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.black45),
                            height: height / 2.25,
                            width: width,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: height / 34.15,
                                      ),
                                      Container(
                                        height: height / 2.43,
                                        width: width / 1.87,
                                        color: Colors.black45,
                                        child: Center(
                                          child: Text(
                                            "\n\they\n"
                                            "\t\t\tmuser"
                                            "\t\t\twelcome\n\t\t\tback",
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
                                    height: height / 2.27,
                                    width: width / 2.15,
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
                            height: height / 1.50,
                            width: width,
                            child: Column(
                              children: [
                                // SizedBox(
                                //   height: height / 13.66,
                                // ),
                                Text(
                                  "\nMUSER login",
                                  style: TextStyle(
                                      fontFamily: "Pepsi",
                                      //fontWeight: FontWeight.bold,
                                      fontSize: 25.0),
                                ),
                                SizedBox(
                                  height: height / 38.70,
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
                                              hintText: "Muser Email")),
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
                                              hintText: "Muser Password")),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height / 34.15,
                                ),
                                Column(
                                  children: [
                                    // SizedBox(
                                    //   width: width / 4.11,
                                    // ),
                                    RaisedButton(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      onPressed: () async {
                                        if (_formkey.currentState.validate()) {
                                          print(
                                              "sqdbhbhdbwgdgyw${email} ${password}");
                                          setState(() {
                                            loading = true;
                                          });
                                          dynamic result = await _auth
                                              .LoginInwithEmailandPassword(
                                                  email, password);
                                          // print(
                                          //     "errrrrrrrrrrrrrrrrrrrrrrrrror${result[0]}");
                                          if (result is String) {
                                            if (result ==
                                                "e[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
                                              setState(() {
                                                error =
                                                    'Your password is incorrect please try again';
                                              });
                                            } else if (result ==
                                                "e[firebase_auth/invalid-email] The email address is badly formatted.") {
                                              setState(() {
                                                error =
                                                    'Please enter a valid email id';
                                              });
                                            } else if (result ==
                                                "e[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
                                              error =
                                                  "This account is not a muser's account so please Signup";
                                            } else if (result ==
                                                "e[firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred.") {
                                              error =
                                                  "loading timeout please tryagain";
                                            }
                                          } else {
                                            print("User Logged in");
                                            setState(() {
                                              error = '';
                                            });
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Homepage(
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
                                        "Login",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Pepsi",
                                            // fontWeight: FontWeight.bold,
                                            fontSize: 15.0),
                                      ),
                                    ),
                                    SizedBox(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "if you don't have an account click here to Signup",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: "Pepsi",
                                              // fontWeight: FontWeight.bold,
                                              fontSize: 15.0),
                                        ),
                                      ),
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
                                              builder: (context) =>
                                                  Signuppage(),
                                            ));
                                      },
                                      child: Text(
                                        "SignUp",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Pepsi",
                                            // fontWeight: FontWeight.bold,
                                            fontSize: 15.0),
                                      ),
                                    )
                                  ],
                                ),
                                // SizedBox(
                                //   height: 20,
                                // ),
                                Text(
                                  error,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
