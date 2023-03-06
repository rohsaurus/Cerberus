import 'package:flutter/material.dart';
import "../button functions/home_screen_buttons.dart";
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  String _email = "";
  String _password = "";
  HomeScreen({Key? key, required email, required password}) : super(key: key) {
    // TODO: implement
    _email = email;
    _password = password;
  }
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
// init state to send the email and password to the button functions
  @override
  void initState() {
    Button.setEmailAndPassword(widget._email, widget._password);
    super.initState();
  }

  Button encryption = Button("Encrypt", 0);
  Button decryption = Button("Decrypt", 1);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Color.fromARGB(232, 3, 25, 42),
      // three buttons in the middle that say encrypt, decrypt, and settings
      child: Column(
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    child: Icon(
                      Icons.settings_applications,
                      size: MediaQuery.of(context).size.height * .08,
                      color: Color.fromARGB(103, 255, 255, 255),
                    ),
                    onTap: () {
                      // navigate to settings page
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SettingsScreen()));
                    },
                  ),
                )
              ]),
          SizedBox(
            height: MediaQuery.of(context).size.height * .28,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  encryption,
                  decryption,
                ],
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
