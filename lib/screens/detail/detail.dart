import 'package:flutter/material.dart';
import 'package:madal_art/common/fuctions.dart';
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
  late Size size;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) {
    final double mandalSize = Functions.getMandalSize(size);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: mandalSize,
                  height: mandalSize,
                  child: Hero(
                    tag: 'mandal-item-${widget.index}',
                    child: Item(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
