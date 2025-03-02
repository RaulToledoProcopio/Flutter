import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'MainScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación',
      initialRoute: '/login',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (context) => LoginScreen());
          case '/mainScreen':
            return MaterialPageRoute(builder: (context) => MainScreen());
          default:
            return MaterialPageRoute(builder: (context) => LoginScreen());
        }
      },
    );
  }
}
