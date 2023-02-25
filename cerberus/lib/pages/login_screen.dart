import "dart:io";
import "dart:convert";
import "dart:async";
import '../CloudflareWorkers/sign_up.dart';
import "package:dargon2_flutter/dargon2_flutter.dart";
import "package:flutter/foundation.dart" show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "home_screen.dart";
import "sign_up_screen.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
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
                        Text("Cerberus",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 36.0,
                                fontWeight: FontWeight.w600)),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Text(
                          "The Passwordless File Encryption Transfer Utility",
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
              /*
              child: !kIsWeb && Platform.isWindows
                  ? credentialsWindows(context)
                  : credentialsLinux(context)
                  */
              child: credentialsLinux(context)),
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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

            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(16.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () {},
                        child: Text("Login"))),
              ],
            ),
          ],
        ));
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
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

            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () => signIn(),
                      child: Text("Login")),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.115),
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(16.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SignUpScreen()));
                      },
                      child: Text("Create an account")),
                ),
              ],
            )
          ],
        ));
  }

  Future<bool> _loginData() async {
    //hashing password using argon2i
    DArgon2Flutter.init();

    // need to get password from the database
    var loginObj = SignUp(_emailController.text, _passwordController.text);
    var JSONResponse = await loginObj.getUser();
    // if user doesn't exist
    if (JSONResponse.containsValue("null")) {
      return false;
    }
    // need to grab password hash from the map
    var passwordHash = JSONResponse["password"];
    // verifying if hashes match up
    var wasVerified = _hashVerification(_passwordController.text, passwordHash);

    return await wasVerified;
  }

  Future<bool> _hashVerification(String password, String stringEncoded) async {
    bool verified = false;
    try {
      verified = await argon2.verifyHashString(password, stringEncoded);
    } on DArgon2Exception catch (e) {
      print(e.toString());
      verified = false;
    }
    print("Was verified? $verified");
    return verified;
  }

  Future signIn() async {
    // loading circle
    showDialog(
        context: context,
        builder: ((context) {
          return Center(child: CircularProgressIndicator.adaptive());
        }));
    // check if email controller and password controller are filled out, and if so run the login function
    // otherwise show error to the user and prompt them to fill out all the fields
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      bool _loginGood = await _loginData();
      if (_loginGood) {
        // popping loading circle to allow user to navigate to home screen
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                    email: _emailController.text,
                    password: _passwordController.text)));
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text("Invalid email or password"),
                actions: [
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        // clearing the password text field and popping the loading circle
                        _passwordController.clear();
                        Navigator.pop(context);
                      });
                    },
                  )
                ],
              );
            });
        // popping loading circle to allow user
      }
    } else {
      // show error and promptuser to fill out all the fields
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Please fill out all fields"),
              actions: [
                TextButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      // clearing the password text field and popping the loading circle
                      _passwordController.clear();
                      Navigator.pop(context);
                    });
                  },
                )
              ],
            );
          });
    }
  }
}
