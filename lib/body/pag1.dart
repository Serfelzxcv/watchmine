import 'package:flutter/material.dart';

class Pag1 extends StatelessWidget {
  const Pag1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home page',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
