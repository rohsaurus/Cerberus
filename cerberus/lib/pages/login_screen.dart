import "dart:io";

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Row(
          children: [
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
                        gradient: LinearGradient(
                            colors: [
                          Color.fromARGB(150, 33, 149, 243),
                          Color.fromARGB(97, 68, 137, 255)
                        ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
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
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
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
                child: Platform.isWindows? credentialsWindows(context) : credentialsLinux(context)
              ),
          ]));
  }


Widget credentialsWindows(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      color: Color.fromARGB(52, 117, 117, 117),
      child: Column( mainAxisAlignment: MainAxisAlignment.center,
        children: [
        // email
        TextField(style: TextStyle(color: Colors.white,), decoration: InputDecoration(prefixIcon: Icon(Icons.mail_rounded, size: 15.0, color: Color.fromARGB(190, 255, 255, 255)), hintText: "Email", hintStyle: TextStyle(color: Color.fromARGB(141, 255, 255, 255)), filled: true,contentPadding: EdgeInsets.symmetric(horizontal: 16.0), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), fillColor: Color.fromARGB(30, 255, 255, 255))),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        // password
         TextField(obscureText: true, style: TextStyle(color: Colors.white,), decoration: InputDecoration(prefixIcon: Icon(Icons.lock_sharp, size: 15.0, color: Color.fromARGB(190, 255, 255, 255)), hintText: "Password", hintStyle: TextStyle(color: Color.fromARGB(141, 255, 255, 255)), filled: true,contentPadding: EdgeInsets.symmetric(horizontal: 16.0), border: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(20)), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(20)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(20)), fillColor: Color.fromARGB(30, 255, 255, 255))),

         SizedBox(height: MediaQuery.of(context).size.height * 0.07),
         Row(
           children: [
             Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(padding: EdgeInsets.all(16.0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), onPressed: () {}, child: Text("Login"))),
           ],
         ),
      ],)
    );
}

Widget credentialsLinux(BuildContext context) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      color: Color.fromARGB(46, 17, 136, 233),
      child: Column( mainAxisAlignment: MainAxisAlignment.center,
        children: [
        // email
        TextField(style: TextStyle(color: Colors.white,), decoration: InputDecoration(prefixIcon: Icon(Icons.mail_rounded, size: 15.0, color: Color.fromARGB(190, 255, 255, 255)), hintText: "Email", hintStyle: TextStyle(color: Color.fromARGB(141, 255, 255, 255)), filled: true,contentPadding: EdgeInsets.symmetric(horizontal: 16.0), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), fillColor: Color.fromARGB(30, 255, 255, 255))),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        // password
         TextField(obscureText: true, style: TextStyle(color: Colors.white,), decoration: InputDecoration(prefixIcon: Icon(Icons.lock_sharp, size: 15.0, color: Color.fromARGB(190, 255, 255, 255)), hintText: "Password", hintStyle: TextStyle(color: Color.fromARGB(141, 255, 255, 255)), filled: true,contentPadding: EdgeInsets.symmetric(horizontal: 16.0), border: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(20)), enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(20)), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(20)), fillColor: Color.fromARGB(30, 255, 255, 255))),

         SizedBox(height: MediaQuery.of(context).size.height * 0.07),
         Row(
           children: [
             Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(padding: EdgeInsets.all(16.0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), onPressed: () {}, child: Text("Login"))),
           ],
         ),
      ],)
    );
}

}
