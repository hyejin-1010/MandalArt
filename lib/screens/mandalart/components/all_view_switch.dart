import 'package:flutter/material.dart';
import 'package:madal_art/screens/mandalart/mandalart.dart';

class AllViewSwitchButton extends StatelessWidget {
  const AllViewSwitchButton({
    Key? key,
    required this.viewType,
    required this.onChange,
  }) : super(key: key);

  final ViewType viewType;
  final Function(bool?) onChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          'All View',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Switch(
          value: viewType == ViewType.ALL,
          onChanged: onChange,
        ),
      ],
    );
  }
}
