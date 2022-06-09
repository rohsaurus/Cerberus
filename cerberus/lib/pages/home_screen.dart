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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: SizedBox(
                  height: 200,
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black26,
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
                      "Encrypt",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 20,
                          fontFamily: "Poppins",
                          color: Color.fromARGB(255, 3, 25, 42)),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: RaisedButton(
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: Text(
                    "Decrypt",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Poppins",
                        color: Color.fromARGB(255, 3, 25, 42)),
                  ),
                  onPressed: () {},
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*.02,
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*.1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: RaisedButton(
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: Text(
                    "Settings",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Poppins",
                        color: Color.fromARGB(255, 3, 25, 42)),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
