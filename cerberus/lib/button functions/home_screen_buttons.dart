import "dart:io";
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import "package:path/path.dart";
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'decryptFiles.dart';
import 'encryptFiles.dart';

class Button extends StatefulWidget {
  final String _text;
  final int _choice;
  static String _email = "";
  static String _password = "";

  // make constructor
  Button(this._text, this._choice);

  // make a method that will set email and password
  static void setEmailAndPassword(String email, String password) {
    _email = email;
    _password = password;
  }

  // make a getter for _email
  static String getEmail() {
    return _email;
  }

  // make a getter for _password
  static String getPassword() {
    return _password;
  }

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  TextEditingController _emailController = TextEditingController();

  // make a widget that contains a button with text that is taken in as a parameter
  @override
  Widget build(BuildContext context) {
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
              ),
              //border width and color
              elevation: 10,
              //elevation of button
              shape: RoundedRectangleBorder(
                  //to set border radius to button
                  borderRadius: BorderRadius.circular(100)),
              padding: EdgeInsets.all(20),
            ),
            child: Text(
              widget._text,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 20,
                  fontFamily: "Poppins",
                  color: Color.fromARGB(190, 253, 253, 253)),
            ),
            onPressed: () {
              if (widget._choice == 0) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Encrypt"),
                        content: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              labelText: "Enter Recipient's Email"),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(actions: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.017,
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.015,
                                        ),
                                        child: Text(
                                          "Enter the email of the recipient of the file. Note that this email must be the same that the recipient used to sign up for Cerberus. Also note, Cerberus does not email the file! The encrypted file will be avaliable at the same path as the original file, which will also show up in the bottom of the screen after encryption is complete.",
                                          style: TextStyle(fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      TextButton(
                                        child: Text("Close"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ]);
                                  },
                                );
                              },
                              child: Text("More Information")),
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text("Encrypt"),
                            onPressed: () async {
                              // create percent indicateer to let the user know that the file is being encrypted
                              if (_emailController.text.isNotEmpty) {
                                // Lets the user pick one file; files with any file extension can be selected
                                FilePickerResult? result = await FilePicker
                                    .platform
                                    .pickFiles(type: FileType.any);
                                // The result will be null, if the user aborted the dialog
                                if (result != null) {
                                  await encryptRunnerMethod(result, context);
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Please enter an email"),
                                ));
                              }
                            },
                          ),
                        ],
                      );
                    });
              } else if (widget._choice == 1) {
                showDialog(
                    context: context,
                    builder: (context) {
                      // alert dialog that asks for the user to choose the file to decrypt
                      return AlertDialog(
                        title: Text("Select File to Decrypt"),
                        actions: [
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                              child: Text("Decrypt"),
                              onPressed: () async {
                                // Lets the user pick one file; files with any file extension can be selected
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: ["cerb"]);
                                // The result will be null, if the user aborted the dialog
                                if (result != null) {
                                  await decryptRunnerMethod(result, context);
                                }
                                Navigator.pop(context);
                              }),
                        ],
                      );
                    });
              }
            }),
      ),
    );
  }

  Future<void> decryptRunnerMethod(
      FilePickerResult result, BuildContext context) async {
    // create percent indicateer to let the user know that the file is being encrypted
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Decrypting File"),
            content: SimpleCircularProgressBar(
              mergeMode: true,
              onGetText: (double value) {
                return Text('${value.toInt()}%');
              },
              progressColors: [
                Color.fromARGB(214, 252, 203, 6),
              ],
            ),
          );
        });
    File file =
        await decryptFiles(result, Button.getEmail(), Button.getPassword());
        // removing the percent indicater when decryption is complete
    setState(() {
      Navigator.of(context).pop();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          Text("Decryption was Succesful!\n File located at: ${file.path}"),
    ));
  }

  Future<void> encryptRunnerMethod(
      FilePickerResult result, BuildContext context) async {
    // create percent indicateer to let the user know that the file is being encrypted
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Encrypting File"),
            content: SimpleCircularProgressBar(
              mergeMode: true,
              onGetText: (double value) {
                return Text('${value.toInt()}%');
              },
              progressColors: [
                Color.fromARGB(214, 252, 203, 6),
              ],
            ),
          );
        });
    File file = await encryptFile(result, _emailController.text);
    setState(() {
      Navigator.of(context).pop();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Encryption was Succesful!\nFile located at: ${file.path}"),
    ));
    Navigator.pop(context);
  }
}
