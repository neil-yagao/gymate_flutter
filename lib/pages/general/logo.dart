import 'package:flutter/material.dart';

class Logo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}