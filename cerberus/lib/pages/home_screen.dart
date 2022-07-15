import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                    onTap: () {},
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
                  button(context, "Encrypt"),
                  button(context, "Decrypt"),
                ],
              ),
            ],
          ),
        ],
      ),
    ));
  }

// make a widget that contains a button with text that is taken in as a parameter
  Widget button(BuildContext context, String text) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .2,
        width: MediaQuery.of(context).size.width * .29,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(144, 7, 205, 255),
            onPrimary: Colors.white,
            side: BorderSide(
              width: 2,
            ), //border width and color
            elevation: 10, //elevation of button
            shape: RoundedRectangleBorder(
                //to set border radius to button
                borderRadius: BorderRadius.circular(100)),
            padding: EdgeInsets.all(20),
          ),
          child: Text(
            text,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 20,
                fontFamily: "Poppins",
                color: Color.fromARGB(190, 253, 253, 253)),
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
