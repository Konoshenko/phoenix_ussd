import 'package:flutter/material.dart';
import 'package:phoenix_ussd/screen/home_page.dart';
import 'package:provider/provider.dart';

import 'mvvm/home_view_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.deepPurpleAccent,accentColor: Colors.deepOrangeAccent),
      home: ChangeNotifierProvider(
        create: (context) => HomeViewModel(),
        child: HomePage(),
      )
    );
  }
}
