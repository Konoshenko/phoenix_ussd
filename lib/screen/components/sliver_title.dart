import 'package:flutter/material.dart';

class SliverTitle extends StatelessWidget {
  final String text;

  SliverTitle({
    Key key,
    @required this.text,
  })  : assert(text != null, text.isNotEmpty),
        super(key: key);

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
