import 'package:flutter/material.dart';

class SliverTitle extends StatelessWidget {

  SliverTitle({
    @required this.text,
    Key key,
  })  : assert(text != null, text.isNotEmpty),
        super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700]),
        ),
      ),
    );
  }
}
