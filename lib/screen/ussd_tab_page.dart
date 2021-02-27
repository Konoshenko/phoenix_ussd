import 'package:flutter/material.dart';
import 'package:phoenix_ussd/models/constants.dart';
import 'package:phoenix_ussd/screen/components/components.dart';
import 'package:url_launcher/url_launcher.dart';


class UssdTabPage extends StatelessWidget {
  const UssdTabPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        const SliverAppBar(
          backgroundColor: Colors.deepPurpleAccent,
          floating: true,
          pinned: true,
          // Display a placeholder widget to visualize the shrinking size.
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(
              'USSD запросы',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          // Make the initial height of the SliverAppBar larger than normal.
          expandedHeight: 200,
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),
        SliverTitle(text: 'Услуга «Отложенный платеж»:'),
        _buildSliverList(getMoney),
        SliverTitle(text: 'Баланс и звонки'),
        _buildSliverList(regularList),
        SliverTitle(text: 'Услуги «Вам звонили» и «Я на связи»:'),
        _buildSliverList(yuoHaveCall),
        SliverTitle(text: 'Вызовы экстренных служб:'),
        _buildSliverList(emergencyList),
      ],
    );
  }

  SliverList _buildSliverList(Map<String, String> list) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return ListTile(
            onTap: () => launch('tel:${list.keys.elementAt(index)}'),
            title: Text(
              list.keys.elementAt(index),
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(list.values.elementAt(index)),
          );
        },
        childCount: list.length,
      ),
    );
  }
}
