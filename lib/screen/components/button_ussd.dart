import 'package:flutter/material.dart';

class ButtonUssd extends StatelessWidget {
  final String title;
  final Function onClick;
  final Color color;
  final isDisable;

  const ButtonUssd({
    Key key,
    @required this.title,
    this.onClick,
    this.color,
    this.isDisable = false,
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
        color: color??Colors.deepOrangeAccent,
        disabledColor: Colors.grey[200],
        textColor: Colors.white,
        onPressed: !isDisable?onClick:null,
        child: Text(title),
      ),
    );
  }
}
