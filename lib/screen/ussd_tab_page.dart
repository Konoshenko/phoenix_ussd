import 'package:flutter/material.dart';
import 'package:phoenix_ussd/models/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class UssdTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(

          backgroundColor: Colors.deepPurpleAccent,
          floating: true,
          pinned: true,
          snap: false,
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
        SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),
        _buildSliverTitle('Услуга «Отложенный платеж»:'),
        _buildSliverList(getMoney),
        _buildSliverTitle('Баланс и звонки'),
        _buildSliverList(regularList),
        _buildSliverTitle('Услуги «Вам звонили» и «Я на связи»:'),
        _buildSliverList(yuoHaveCall),
        _buildSliverTitle('Вызовы экстренных служб:'),
        _buildSliverList(emergencyList),
      ],
    );
  }

  SliverToBoxAdapter _buildSliverTitle(String s) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          s,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700]),
        ),
      ),
    );
  }

  SliverList _buildSliverList(Map<String, String> list) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return ListTile(
            onTap: () => launch("tel:${list.keys.elementAt(index)}"),
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
