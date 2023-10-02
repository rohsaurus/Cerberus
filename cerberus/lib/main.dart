import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './pages/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Cerberus",
        theme: ThemeData(fontFamily: GoogleFonts.poppins().fontFamily),
        home: LoginScreen());
  }
}
