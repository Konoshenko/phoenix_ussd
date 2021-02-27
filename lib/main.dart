import 'package:flutter/material.dart';
import 'package:phoenix_ussd/mvvm/home_view_model.dart';
import 'package:phoenix_ussd/screen/home_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.deepPurpleAccent,
            accentColor: Colors.deepPurpleAccent),
        home: ChangeNotifierProvider(
          create: (context) => HomeViewModel(),
          child: HomePage(),
        ));
  }
}
