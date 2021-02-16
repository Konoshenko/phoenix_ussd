import 'package:flutter/material.dart';

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
            Text(text),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: ElevatedButton(
                      child: const Text('Продолжить'),
                      onPressed: () {
                        onConfirmClick();
                        Navigator.pop(context);
                      }),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: ElevatedButton(
                    child: const Text('Отменить'),
                    onPressed: () => Navigator.pop(context),
                  ),
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