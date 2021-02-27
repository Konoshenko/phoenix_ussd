import 'package:flutter/material.dart';
import 'package:phoenix_ussd/screen/components/components.dart';

class SheetConfirmDialog extends StatelessWidget {
  const SheetConfirmDialog({
    @required this.text,
    @required this.onConfirmClick,
    Key key,
  }) : super(key: key);

  final Function onConfirmClick;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const SizedBox(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, color: Colors.black54),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  height: 70,
                  child: ButtonUssd(
                      color: Colors.deepOrangeAccent,
                      onClick: () {
                        onConfirmClick();
                        Navigator.pop(context);
                      },
                      title: 'Продолжить'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 70,
                  child: ButtonUssd(
                      color: Colors.deepOrangeAccent,
                      onClick: () => Navigator.pop(context),
                      title: 'Отменить'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
