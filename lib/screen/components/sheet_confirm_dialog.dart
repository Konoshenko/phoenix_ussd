import 'package:flutter/material.dart';

import 'components.dart';

class SheetConfirmDialog extends StatelessWidget {
  const SheetConfirmDialog({
    Key key,
    @required this.text,
    @required this.onConfirmClick,
  }) : super(key: key);

  final Function onConfirmClick;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical:16.0,horizontal: 32),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: ButtonUssd(
                      color: Colors.deepOrangeAccent,
                      onClick: () {
                        onConfirmClick();
                        Navigator.pop(context);
                      },
                      title: 'Продолжить'),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: ButtonUssd(
                      color: Colors.deepOrangeAccent,
                      onClick: () => Navigator.pop(context),
                      title: 'Отменить'),
                ),
                SizedBox(
                  width: 16,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
