import "dart:io";
import 'dart:typed_data';
import 'package:aes256gcm/aes256gcm.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import "package:encrypt/encrypt.dart" as encrypt;
import 'package:fast_rsa/fast_rsa.dart';
import 'package:cerberus/CloudflareWorkers/keys.dart';

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
                            labelText:
                                "Enter the email of the person you want to send the file to",
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text("Encrypt"),
                            onPressed: () async {
                              // Lets the user pick one file; files with any file extension can be selected
                              FilePickerResult? result = await FilePicker
                                  .platform
                                  .pickFiles(type: FileType.any);
                              // The result will be null, if the user aborted the dialog
                              if (result != null) {
                                File file =
                                    File((result.files.first.path).toString());
                                var dbConnect =
                                    Keys.emailOnly(_emailController.text);
                                String pubKey = await dbConnect.getKeys(0);
                                Uint8List imgbytes1 = file.readAsBytesSync();
                                final AESkey = encrypt.Key.fromSecureRandom(32);
                                final AESiv = encrypt.IV.fromSecureRandom(16);
                                final encryptor = encrypt.Encrypter(encrypt
                                    .AES(AESkey, mode: encrypt.AESMode.gcm));
                                final encrypted = encryptor
                                    .encryptBytes(imgbytes1, iv: AESiv);
                                // get the directory of file
                                var outputFile = File(p.join(
                                    p.dirname(file.path),
                                    p.basename(file.path) + ".cerb"));
                                // encrypt AESkey with pubkey
                                final encryptedAESKey = await RSA.encryptOAEP(
                                    AESkey.base64, "Key", Hash.SHA512, pubKey);
                                final encryptedAESIV = await RSA.encryptOAEP(
                                    AESiv.base64, "IV", Hash.SHA512, pubKey);
                                // write encryptedAESKey and encryptedAESIV to outputFile
                                outputFile.writeAsStringSync(
                                  "$encryptedAESKey\n",
                                );
                                outputFile.writeAsStringSync(
                                  "$encryptedAESIV\n",
                                  mode: FileMode.append,
                                );
                                // write encrypted to outputFile
                                outputFile.writeAsBytesSync(encrypted.bytes,
                                    mode: FileMode.append);
                                // show a snackbar that says the file was encrypted
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content:
                                      const Text("Encryption was Succesful!"),
                                ));
                              }
                              Navigator.pop(context);
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
                                FilePickerResult? result = await FilePicker
                                    .platform
                                    .pickFiles(type: FileType.any);
                                // The result will be null, if the user aborted the dialog
                                if (result != null) {
                                  File file = File(
                                      (result.files.first.path).toString());
                                  var dbConnect =
                                      Keys.emailOnly(Button.getEmail());
                                  String privKey = await dbConnect.getKeys(1);
                                  // generate the same AES key as the one used to encrypt the file using _password and decrypting the private key
                                  privKey = await Aes256Gcm.decrypt(
                                      privKey, Button.getPassword());
                                  // get the directory of file
                                  var outputFile = File(p.join(
                                      p.dirname(file.path),
                                      p.basenameWithoutExtension(file.path)));
                                  // read the encryptedAESKey and encryptedAESIV from file
                                  final List<String> fileContents =
                                      file.readAsLinesSync();
                                  final encryptedAESKey =
                                      fileContents.elementAt(0);
                                  final encryptedAESIV =
                                      fileContents.elementAt(1);
                                  final encryptedContents =
                                      fileContents.elementAt(2);

                                  // decrypt encryptedAESKey and encryptedAESIV with privkey
                                  final decryptedAESKey = await RSA.decryptOAEP(
                                      encryptedAESKey,
                                      "Key",
                                      Hash.SHA512,
                                      privKey);
                                  final decryptedAESIV = await RSA.decryptOAEP(
                                      encryptedAESIV,
                                      "IV",
                                      Hash.SHA512,
                                      privKey);

                                  final key =
                                      encrypt.Key.fromBase64(decryptedAESKey);
                                  final iv =
                                      encrypt.IV.fromBase64(decryptedAESIV);
                                  final decryptor = encrypt.Encrypter(encrypt
                                      .AES(key, mode: encrypt.AESMode.gcm));
                                  final decrypted = decryptor
                                      .decrypt64(encryptedContents, iv: iv);
                                  // write decrypted to outputFile
                                  outputFile.writeAsStringSync(decrypted);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content:
                                        const Text("Decryption was Succesful!"),
                                  ));
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
}
