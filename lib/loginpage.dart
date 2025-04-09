import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibercare/language_manager.dart';
import 'package:fibercare/language_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:fluttertoast/fluttertoast.dart';
import 'squaretile.dart';
import 'mybutton.dart';
import 'mytextfield.dart';
import 'signuppage.dart';
import 'homepage.dart';
import 'auth_services.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final AuthServices _auth = AuthServices(); // to gain access to auth services

  // taking inputs
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emailforresetController =
      TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _emailforresetController.dispose();
    super.dispose();
  }

  // sign user in method (used latter)
  // for data
  void _signin() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Check if any field is empty
    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: languageManager.translate("fillAllFields"),
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        fontSize: 16,
      );
      return;
    }

    // Proceed with signup
    try {
      User? user = await _auth.SigninWithEmailandPass(email, password);
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Homepage(),
          ),
        );

        Fluttertoast.showToast(
          msg: languageManager.translate("loginSuccess"),
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 3,
          fontSize: 16,
        );
      } else {
        Fluttertoast.showToast(
          msg: languageManager.translate("loginFailed"),
          backgroundColor: Colors.red,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 3,
          fontSize: 16,
        );
        return;
      }
    } catch (e) {
      // Handle signup error
      Fluttertoast.showToast(
        msg:languageManager.translate("tryAgain"),
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        fontSize: 16,
      );
    }
  } //

  @override
  Widget build(BuildContext context) {
    // colors of the app
    Color primaryColor = Theme.of(context).colorScheme.primary; // dark blue
    Color secondary = Theme.of(context).colorScheme.secondary; //  green
    Color tertiary = Theme.of(context).colorScheme.tertiary; // light blue
    Color inversePrimary =
        Theme.of(context).colorScheme.inversePrimary; // black

    // To make the code fit for any screen size
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFd4e8eb),
      // Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                 const Row( mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                     Padding(
                       padding: EdgeInsets.symmetric(horizontal: 30),
                       child: LanguageSwitch(),
                     ),
                   ],
                 ), // Add this line
                // logo
                Image.asset(
                  "lib/images/fibrocare logo removebg.png",
                  height: screenHeight * 0.25,
                  width: screenWidth * 0.50,
                  fit: BoxFit.contain,
                ),

                // welcoming
                Text(languageManager.translate("welcome"),
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),

               

                SizedBox(height: screenHeight * 0.025),

                // username textfield
                MyTextField(
                  controller: _emailController,
                  hintText: languageManager.translate("email"),
                  obscureText: false,
                ),

                SizedBox(height: screenHeight * 0.020),

                // password textfield
                MyTextField(
                  controller: _passwordController,
                  hintText: languageManager.translate("password"),
                  obscureText: true,
                ),

                SizedBox(height: screenHeight * 0.010),

                // forget password

                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.075),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // add method to send to email ===========================================
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                title:  Center(
                                  child: Text(
                                    languageManager.translate("enterEmail"),
                                    textAlign: TextAlign.center,
                                    style:const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                content: TextField(
                                  controller: _emailforresetController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration:  InputDecoration(
                                    labelText: languageManager.translate("email"),
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                                actions: <Widget>[
                                  Center(
                                    child: TextButton(
                                      onPressed: () async {
                                        if (_emailforresetController
                                            .text.isNotEmpty) {
                                          bool isValidEmail =
                                              await checkEmailInCollections(
                                                  _emailforresetController
                                                      .text);
                                          if (isValidEmail == false) {
                                            Fluttertoast.showToast(
                                              msg: languageManager.translate("invalidEmail"),
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              gravity: ToastGravity.TOP,
                                              toastLength: Toast.LENGTH_SHORT,
                                              timeInSecForIosWeb: 3,
                                              fontSize: 16,
                                            );
                                            return;
                                          }

                                          try {
                                            await FirebaseAuth.instance
                                                .sendPasswordResetEmail(
                                                    email:
                                                        _emailforresetController
                                                            .text);
                                            Navigator.of(context).pop();
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  title:  Center(
                                                    child: Text(
                                                      languageManager.translate("passwordResetSent"),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:const TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    Center(
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          languageManager.translate("ok"),
                                                          style: const TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } catch (e) {
                                            Navigator.of(context).pop();
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  title:  Center(
                                                    child: Text(
                                                     languageManager.translate("tryAgain"),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style:const TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    Center(
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child:  Text(
                                                          languageManager.translate("ok"),
                                                          style:const TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        }
                                      },
                                      child: Text(
                                        languageManager.translate("send"),
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          languageManager.translate("forgotPassword"),
                          style: TextStyle(
                            color: secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // sign up button
                SizedBox(height: screenHeight * 0.020),
                MyButton(
                  buttonTitle: languageManager.translate("login"),
                  onTap: _signin,
                ),

                // create account
                SizedBox(height: screenHeight * 0.035),

                // or you are new user?
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: primaryColor,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.10),
                        child: Text(
                          languageManager.translate("newUser"),
                          style: TextStyle(
                            color: tertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.75,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.025),

                // space --------------------------------
                // ignore: prefer_const_constructors

                // new user button
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  GestureDetector(
                    child: SquareTile(
                      icon: Icon(
                        Icons.person_add_alt_1,
                        size: 40,
                        color: primaryColor,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Signuppage(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Text(
                    languageManager.translate("createAccount"),
                    style: TextStyle(
                      color: secondary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: screenWidth * 0.25),

                  
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // check if the accout that the user wanted to reset it password exist or not
  Future<bool> checkEmailInCollections(String email) async {
    final usersCollection = FirebaseFirestore.instance.collection('users');

    final userSnapshot = await usersCollection
        .where('email', isEqualTo: email.toLowerCase())
        .get();

    // Combine existence checks using OR operator
    return userSnapshot.docs.isNotEmpty;
  }
}
