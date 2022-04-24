import "dart:io";
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:google_fonts/google_fonts.dart';
import './pages/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if running on windows, add acrylic affect, otherwise no effect
  if (Platform.isWindows) {
    await Window.initialize();
    await Window.setEffect(
        effect: WindowEffect.aero, color: Color.fromARGB(0, 0, 0, 0));
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Cerberus",
        theme: ThemeData(fontFamily: GoogleFonts.poppins().fontFamily),
        home: LoginScreen());
  }
}
