import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fibercare/auth_services.dart';
import 'package:fibercare/language_manager.dart';
import 'package:fibercare/mybutton.dart';
import 'package:fibercare/mytextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:fluttertoast/fluttertoast.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  final AuthServices _auth = AuthServices(); // to gain access to services

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _tallController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _tallController.dispose();
    _weightController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // colors of the app
    Color primaryColor = Theme.of(context).colorScheme.primary; // dark grey
    Color secondary = Theme.of(context).colorScheme.secondary; // light grey
    Color tertiary = Theme.of(context).colorScheme.tertiary; // white
    Color inversePrimary =
        Theme.of(context).colorScheme.inversePrimary; // black

    // To make the code fit for any screen size
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: tertiary,
        ), // change the drawer color
        title: Text(
          languageManager.translate('createAccount'),
          style: TextStyle(
            color: tertiary,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        elevation: 10.0,
        centerTitle: true,
        backgroundColor: primaryColor,
      ),

      backgroundColor: const Color(0xFFd4e8eb), // shade 300
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.016,
                    vertical: screenHeight * 0.016),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.025),
                    Text(
                      languageManager.translate('happyToHaveYou'),
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: screenHeight * 0.030),

                    SizedBox(height: screenHeight * 0.015),
                    MyTextField(
                      controller: _usernameController,
                      hintText: languageManager.translate('name'),
                      obscureText: false,
                    ),
                    SizedBox(height: screenHeight * 0.035),

                    SizedBox(height: screenHeight * 0.015),
                    MyTextField(
                      controller: _emailController,
                      hintText: languageManager.translate('email'),
                      obscureText: false,
                    ),
                    SizedBox(height: screenHeight * 0.035),

                    SizedBox(height: screenHeight * 0.015),
                    MyTextField(
                      controller: _passwordController,
                      hintText: languageManager.translate('password'),
                      obscureText: true,
                    ),
                    SizedBox(height: screenHeight * 0.035),

                    SizedBox(height: screenHeight * 0.015),
                    MyTextField(
                      controller: _confirmpasswordController,
                      hintText: languageManager.translate('confirmPassword'),
                      obscureText: true,
                    ),
                    SizedBox(height: screenHeight * 0.035),

                    SizedBox(height: screenHeight * 0.015),
                    MyTextField(
                      controller: _ageController,
                      hintText: languageManager.translate('age'),
                      obscureText: false,
                    ),
                    SizedBox(height: screenHeight * 0.035),

                    SizedBox(height: screenHeight * 0.015),
                    MyTextField(
                      controller: _tallController,
                      hintText: languageManager.translate('height'),
                      obscureText: false,
                    ),
                    SizedBox(height: screenHeight * 0.035),

                    SizedBox(height: screenHeight * 0.015),
                    MyTextField(
                      controller: _weightController,
                      hintText:languageManager.translate('weight'),
                      obscureText: false,
                    ),

                    SizedBox(height: screenHeight * 0.035),

                    MyButton(buttonTitle:languageManager.translate('createAccount'), onTap: _signup),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // for data
  void _signup() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmpassword = _confirmpasswordController.text;
    int age = int.parse(_ageController.text);
    int tall = int.parse(_tallController.text);
    int weight = int.parse(_weightController.text); 

    // Check if any field is empty
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmpassword.isEmpty) {
      Fluttertoast.showToast(
        msg: languageManager.translate('fillAllFields'),
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        fontSize: 16,
      );
      return;
    }

    // Check if passwords match
    if (password != confirmpassword) {
      Fluttertoast.showToast(
        msg: languageManager.translate("passwordsNotMatch"),
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        fontSize: 16,
      );
      return;
    }

    // Check if password is at least 8 characters long
    if (password.length < 8) {
      Fluttertoast.showToast(
        msg: languageManager.translate("passwordRequirements"),
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        fontSize: 16,
      );
      return;
    }

    // Check if password contains both letters and digits
    bool hasLetter = password.contains(RegExp(r'[a-zA-Z]'));
    bool hasDigit = password.contains(RegExp(r'\d'));
    if (!hasLetter || !hasDigit) {
      Fluttertoast.showToast(
        msg: languageManager.translate("passwordRequirements"),
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        fontSize: 16,
      );
      return;
    }

    // Function to check if the input is a valid email format
    bool isValidEmail(String email) {
      // Regular expression for validating email format
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      return emailRegex.hasMatch(email);
    }

// Example usage
    if (!isValidEmail(email)) {
      Fluttertoast.showToast(
        msg:languageManager.translate("invalidEmail"),
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        fontSize: 16,
      );
    }

    // check if username availability

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    if (querySnapshot.size != 0) {
      // Returns true if username does exist
      Fluttertoast.showToast(
        msg: languageManager.translate('usernameExists'),
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        fontSize: 16,
      );

      return;
    }

    // check if email availability

    final querySnapshotemail = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshotemail.size != 0) {
      // Returns true if username does exist
      Fluttertoast.showToast(
        msg: languageManager.translate("emailExists"),
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
      // here it will save in firebase authentication
      User? user = await _auth.SignupWithEmailandPass(email, password);

      if (user != null) {
        // here it will save in database
        _createdata(
          Usermodel(
              username: _usernameController.text,
              email: _emailController.text,
              // section: dropdownvalue,
              age: int.parse(_ageController.text),
              tall: int.parse(_tallController.text),
              weight: int.parse(_weightController.text),
              ),
        );

        Navigator.pop(context); // This will go back to the previous screen
        Fluttertoast.showToast(
          msg: languageManager.translate("accountCreated"),
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 3,
          fontSize: 16,
        );
      } else {
        print("حدث خطأ");
      }
    } catch (e) {
      // Handle signup error
      Fluttertoast.showToast(
        msg: languageManager.translate("tryAgain"),
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.TOP,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 3,
        fontSize: 16,
      );
    }
  }

  void _createdata(Usermodel usermodel) {
    final usercollection = FirebaseFirestore.instance.collection("users");

    // generate id in firebase
    String id = usercollection.doc().id;

    final newuser = Usermodel(
      username: usermodel.username,
      email: usermodel.email,
      age: usermodel.age,
      tall: usermodel.tall,
      weight: usermodel.weight,
      id: id,
    ).toJson();
    usercollection.doc(id).set(newuser);
  }
}

// store user data
class Usermodel {
  final String? username;
  final String? email;
  final int? age;
  final int? tall;
  final int? weight;
  final String? id;
  

  Usermodel(
      {this.id,
      this.username,
      this.email,
      this.age,
      this.tall,
      this.weight,});

  static Usermodel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Usermodel(
      username: snapshot["username"],
      email: snapshot["email"],
      age: snapshot["age"],
      tall: snapshot["tall"],
      weight: snapshot["weight"],
      id: snapshot["id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "age": age,
      "tall": tall,
      "weight": weight,
      "id": id,
    };
  }
}
