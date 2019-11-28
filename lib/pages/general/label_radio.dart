import 'package:flutter/material.dart';

class LabeledRadio<T> extends StatelessWidget {

  const LabeledRadio({
    this.label,
    this.padding,
    this.groupValue,
    this.value,
    this.onChanged,
  });

  final Widget label;
  final EdgeInsets padding;
  final T groupValue;
  final T value;
  final Function(T) onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue)
          onChanged(value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Radio<T>(
              groupValue: groupValue,
              value: value,
              onChanged: (T newValue) {
                onChanged(newValue);
              },
            ),
            label,
          ],
        ),
      ),
    );
  }
}