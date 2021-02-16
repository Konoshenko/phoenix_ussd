import 'package:flutter/material.dart';
import 'package:phoenix_ussd/models/info.dart';

class ListTileBalanceInfo extends StatelessWidget {
  const ListTileBalanceInfo({
    Key key,
    @required this.ba,
  }) : super(key: key);

  final BalanceInfo ba;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //leading: Text(ba?.updateTime?.toUtc()?.toString() ?? 'Неизвесно'),
      title: Text(ba.response),
      subtitle: Text(ba.code,
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold)),
    );
  }
}
