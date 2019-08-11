import 'package:flutter/material.dart';

class RoundedInput extends StatelessWidget {

  final TextEditingController controller;

  final String hint;

  final TextInputType inputType;

  const RoundedInput({Key key, this.controller, this.hint, this.inputType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.addListener(() {
      final text = controller.text.toLowerCase();
      controller.value = controller.value.copyWith(
        text: text,
        selection: TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    // TODO: implement build1
    return TextFormField(
      keyboardType: inputType,
      controller: controller,
      autofocus: false,
      obscureText: inputType == TextInputType.url,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );;
  }
}