import 'package:flutter/material.dart';

class RoundedInput extends StatelessWidget {

  final TextEditingController controller;

  final String hint;

  final TextInputType inputType;

  final ValueChanged<String> onChanged;

  const RoundedInput({Key key, this.controller, this.hint, this.inputType, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // TODO: implement build1
    return TextField(
      keyboardType: inputType,
      controller: controller,
      autofocus: false,
      obscureText: inputType == TextInputType.visiblePassword,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onChanged: onChanged ,
    );;
  }
}