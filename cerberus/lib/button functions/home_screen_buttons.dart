import 'dart:convert' show utf8;
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
                                "Enter the email of the person you want to encrypt the file for",
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
                                // @bug: some weird thing when I tested using a 6.5mb pdf file. When I did the encryption on the imgbytes1, the bytes balloned to 35mb...
                                // @bug: I need to fix the variable names on both encryption and decryption. For example, somehow encryptedAESKEy and encryptedFileContents are the same? It's interesting.... Need to spend time to figure out and change variable names! But I think using binary is good and will allow me to encrypt and decrypt virtually any file type

                                final encrypted = encryptor
                                    .encryptBytes(imgbytes1, iv: AESiv);
                                // get the directory of file
                                var outputFile = File(p.join(
                                    p.dirname(file.path),
                                    p.basename(file.path) + ".cerb"));
                                // encrypt AESkey with pubkey
                                final encryptedAESKey =
                                    await RSA.encryptOAEPBytes(AESkey.bytes,
                                        "Key", Hash.SHA512, pubKey);
                                final encryptedAESIV =
                                    await RSA.encryptOAEPBytes(
                                        AESiv.bytes, "IV", Hash.SHA512, pubKey);
                                // write encryptedAESKey and encryptedAESIV to outputFile
                                outputFile.writeAsBytesSync(encryptedAESKey);
                                outputFile.writeAsBytesSync(
                                  encryptedAESIV,
                                  mode: FileMode.append,
                                );
                                // write encrypted to outputFile
                                outputFile.writeAsBytesSync(encrypted.bytes,
                                    mode: FileMode.append);
                                // show a snackbar that says the file was encrypted
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      "Encryption was Succesful!\nFile located at: ${file.path}"),
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
                                  // read lines one and two of the file - one is the encrypted AES key and the other is the encrypted AES IV
                                  final fileContents = file.readAsBytesSync();
                                  final encryptedKeyAndIVSize =
                                      512; // SHA512 made it 512 bytes
                                  final encryptedAESKey = fileContents.sublist(
                                      0, encryptedKeyAndIVSize);
                                  final encryptedAESIV = fileContents.sublist(
                                      encryptedKeyAndIVSize,
                                      encryptedKeyAndIVSize * 2);
                                  final encryptedContents = fileContents
                                      .sublist(encryptedKeyAndIVSize * 2);
                                  // decrypt encryptedAESKey and encryptedAESIV with privkey
                                  final decryptedAESKeyBytes =
                                      await RSA.decryptOAEPBytes(
                                          encryptedAESKey,
                                          "Key",
                                          Hash.SHA512,
                                          privKey);
                                  final decryptedAESIVBytes =
                                      await RSA.decryptOAEPBytes(encryptedAESIV,
                                          "IV", Hash.SHA512, privKey);
                                  final key = encrypt.Key(decryptedAESKeyBytes);
                                  final iv = encrypt.IV(decryptedAESIVBytes);
                                  final decryptor = encrypt.Encrypter(encrypt
                                      .AES(key, mode: encrypt.AESMode.gcm));
                                  // decrypt the file contents
                                  final decrypted = decryptor.decrypt(
                                      encrypt.Encrypted(encryptedContents),
                                      iv: iv);
                                  // write decrypted to outputFile
                                  outputFile.writeAsStringSync(decrypted);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "Decryption was Succesful!\n File located at: ${file.path}"),
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
