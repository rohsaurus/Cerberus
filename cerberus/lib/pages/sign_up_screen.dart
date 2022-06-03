import "dart:io";
import "dart:convert";
import "package:dargon2_flutter/dargon2_flutter.dart";
import "package:auth0/auth0.dart";
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:flutter_mongo_stitch_platform_interface/flutter_mongo_stitch_platform_interface.dart';
import "./login_screen.dart";
import "../CloudflareWorkers/sign_up.dart";

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
// Need to add Data Validation to windows and linux and also the button to switch back to login screen on the credentials linux method

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController =
      new TextEditingController();
  String _base64Hash = "";
  String _hexHash = "";
  String _encodedString = "";
  late DArgon2Result result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Row(children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fwww.pixelstalk.net%2Fwp-content%2Fuploads%2F2016%2F06%2FLandscapes-mountains-snow-skies-stars-starry-night-nature.jpg&f=1&nofb=1"),
                          fit: BoxFit.cover)),
                ),
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Color.fromARGB(150, 33, 149, 243),
                    Color.fromARGB(97, 68, 137, 255)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lock,
                                  semanticLabel: "Secured",
                                  size: 20.0,
                                ),
                              ]),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.27,
                    ),
                    Column(
                      children: [
                        Text("Cerberus (Sign Up Test)",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 36.0,
                                fontWeight: FontWeight.w600)),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Text(
                          "The Passwordless File-Transfer Utility",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
              // if platform is windows, use acrylic effect otherwise both methods are the same
              child: !kIsWeb && Platform.isWindows
                  ? credentialsWindows(context)
                  : credentialsLinux(context)),
        ]));
  }

  Widget credentialsWindows(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      color: Color.fromARGB(52, 117, 117, 117),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // email
          TextField(
              controller: _emailController,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.mail_rounded,
                      size: 15.0, color: Color.fromARGB(190, 255, 255, 255)),
                  hintText: "Email",
                  hintStyle:
                      TextStyle(color: Color.fromARGB(141, 255, 255, 255)),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  fillColor: Color.fromARGB(30, 255, 255, 255))),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          // password
          TextField(
              controller: _passwordController,
              obscureText: true,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_sharp,
                      size: 15.0, color: Color.fromARGB(190, 255, 255, 255)),
                  hintText: "Password",
                  hintStyle:
                      TextStyle(color: Color.fromARGB(141, 255, 255, 255)),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20)),
                  fillColor: Color.fromARGB(30, 255, 255, 255))),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          // Confirming password to make sure that the user is not typing in the wrong password
          TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_sharp,
                      size: 15.0, color: Color.fromARGB(190, 255, 255, 255)),
                  hintText: "Confirm Password",
                  hintStyle:
                      TextStyle(color: Color.fromARGB(141, 255, 255, 255)),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20)),
                  fillColor: Color.fromARGB(30, 255, 255, 255))),

          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(16.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () {
                          // check if email controller and password controller are filled out, and if so run the login function
                          // otherwise show error to the user and prompt them to fill out all the fields
                          if (_confirmPasswordController.text !=
                              _passwordController.text) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Error"),
                                    content: Text(
                                        "Your passwords do not match. Please try again."),
                                    actions: [
                                      TextButton(
                                        child: Text("Close"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          } else if ((_emailController.text.isNotEmpty &&
                                  _passwordController.text.isNotEmpty) &&
                              EmailValidator.validate(_emailController.text)) {
                            _loginData();
                          } else {
                            // show error and promptuser to fill out all the fields
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Error"),
                                    content: Text(
                                        "Please fill out all fields and make sure your email is valid"),
                                    actions: [
                                      TextButton(
                                        child: Text("Close"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          }
                        },
                        child: Text("Sign Up"))),
              ],
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text("Have an account? Sign in now!"))
        ],
      ),
    );
  }

  Widget credentialsLinux(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        color: Color.fromARGB(46, 17, 136, 233),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // email
            TextField(
                controller: _emailController,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail_rounded,
                        size: 15.0, color: Color.fromARGB(190, 255, 255, 255)),
                    hintText: "Email",
                    hintStyle:
                        TextStyle(color: Color.fromARGB(141, 255, 255, 255)),
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    fillColor: Color.fromARGB(30, 255, 255, 255))),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            // password
            TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_sharp,
                        size: 15.0, color: Color.fromARGB(190, 255, 255, 255)),
                    hintText: "Password",
                    hintStyle:
                        TextStyle(color: Color.fromARGB(141, 255, 255, 255)),
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(20)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(20)),
                    fillColor: Color.fromARGB(30, 255, 255, 255))),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            // Confirming password to make sure that the user is not typing in the wrong password
            TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_sharp,
                        size: 15.0, color: Color.fromARGB(190, 255, 255, 255)),
                    hintText: "Confirm Password",
                    hintStyle:
                        TextStyle(color: Color.fromARGB(141, 255, 255, 255)),
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(20)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(20)),
                    fillColor: Color.fromARGB(30, 255, 255, 255))),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(16.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          onPressed: () {
                            // check if email controller and password controller are filled out, and if so run the login function
                            // otherwise show error to the user and prompt them to fill out all the fields
                            if (_confirmPasswordController.text !=
                                _passwordController.text) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Error"),
                                      content: Text(
                                          "Your passwords do not match. Please try again."),
                                      actions: [
                                        TextButton(
                                          child: Text("Close"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  });
                            } else if ((_emailController.text.isNotEmpty &&
                                    _passwordController.text.isNotEmpty) &&
                                EmailValidator.validate(
                                    _emailController.text)) {
                              _loginData();
                            } else {
                              // show error and promptuser to fill out all the fields
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Error"),
                                      content: Text(
                                          "Please fill out all fields and make sure your email is valid"),
                                      actions: [
                                        TextButton(
                                          child: Text("Close"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  });
                            }
                          },
                          child: Text("Sign Up"))),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),

            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text("Have an account? Sign in now!"))
          ],
        ));
  }

  void _loginData() async {
    //hashing password using argon2i
    DArgon2Flutter.init();
    var s = Salt.newSalt();
    var result =
        await argon2.hashPasswordString(_passwordController.text, salt: s);
    //Raw hash values available as int list, base 64 string, and hex string
    var bytesRaw = result.rawBytes;
    var base64Hash = result.base64String;
    var hexHash = result.hexString;

    //Encoded hash values available as int list and encoded string
    var bytesEncoded = result.encodedBytes;
    var stringEncoded = result.encodedString;
    print("String Encoded: $stringEncoded");
    var signUpObject = SignUp(_emailController.text, stringEncoded);
    signUpObject.signup();
  }
}
