import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'login_page.dart';
import 'missed_load_form.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure shared preferences are initialized
  final prefs = await SharedPreferences.getInstance();
  final authToken = prefs.getString('authToken');

  Widget homeWidget;

  if (authToken != null && !JwtDecoder.isExpired(authToken)) {
    // Decode token to extract company ID
    final decodedToken = JwtDecoder.decode(authToken);
    final int companyId = int.parse(decodedToken['Company']);
    homeWidget = MissedLoadForm(companyId: companyId);
  } else {
    homeWidget = const LoginPage();
  }
  
  runApp(MyApp(homeWidget: homeWidget));
}

class MyApp extends StatelessWidget {
  final Widget homeWidget;

  const MyApp({super.key, required this.homeWidget});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homeWidget,
    );
  }
}