import 'package:flutter/material.dart';
import 'package:madal_art/screens/mandalart/components/item.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({
    required this.index,
  });
  final int index;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: 'mandal-item-${widget.index}',
        child: Item(),
      ),
    );
  }
}
