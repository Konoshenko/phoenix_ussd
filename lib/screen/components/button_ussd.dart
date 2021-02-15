import 'package:flutter/material.dart';

class ButtonUssd extends StatelessWidget {
  final String title;
  final Function onClick;

  const ButtonUssd({
    Key key,
    @required this.title,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0,
        color: Colors.deepOrangeAccent,
        textColor: Colors.white,
        onPressed: onClick,
        child: Text(title),
      ),
    );
  }
}
