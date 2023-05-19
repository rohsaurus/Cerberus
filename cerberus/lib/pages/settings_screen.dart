import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsList(
        sections: [
          SettingsSection(
            title:
                Text('About (THIS SETTINGS PAGE IS CURRENTLY NOT FUNCTIONAL)'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.language),
                title: Text('Language'),
                value: Text('English'),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {},
                initialValue: true,
                leading: Icon(Icons.format_paint),
                title: Text('Enable custom theme'),
              ),
              // button for about
              SettingsTile(
                leading: Icon(Icons.info),
                title: Text('About'),
                onPressed: (context) {
                  showAboutDialog(
                      context: context,
                      applicationName: "Cerberus",
                      applicationVersion: "0.8.0-alpha",
                      applicationLegalese: "©2023 Cerberus",
                      children: [
                        RichText(
                          text: TextSpan(children: [
                            const TextSpan(
                              text:
                                  ("Cerberus is a secure file encryption and decryption application that uses RSA and XChaCha20 encryption to encrypt and send your files securly over the internet, without the need to send a password along with it! Cerberus is open source and can be found on GitHub at "),
                              style: TextStyle(
                                  color: Colors.black,
                                  textBaseline: TextBaseline.alphabetic),
                            ),
                            TextSpan(
                                text: "https://github.com/rohsaurus/Cerberus",
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launchUrlString(
                                        "https://github.com/rohsaurus/Cerberus");
                                  }),
                          ]),
                        ),
                      ]);
                },
              ),
              // settings tile that opens a dialog box with the license from "https://github.com/rohsaurus/Cerberus/blob/Main/License"
              SettingsTile(
                title: Text("Cerberus BSD-3 License"),
                leading: Icon(Icons.article),
                onPressed: (context) {
                  // open the browser to the license
                  launchUrlString(
                      "https://github.com/rohsaurus/Cerberus/blob/Main/License");
                },
              ),
            ],
          ),
        ],
      ),
      // add a floating action button to the bottom right of the screen to go back to the home screen
      floatingActionButton: FloatingActionButton(
        tooltip: "Go back to the home screen",
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}
