import 'package:flutter/material.dart';
import 'package:madal_art/screens/detail/detail.dart';
import 'package:madal_art/screens/mandalart/components/item.dart';

class MandalArtScreen extends StatefulWidget {
  @override
  _MandalArtScreenState createState() => _MandalArtScreenState();
}

class _MandalArtScreenState extends State<MandalArtScreen> {
  late Size size;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) {
    double minSize = size.width;
    if (size.height < size.width) {
      minSize = size.height;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: minSize,
        height: minSize,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
          ),
          itemCount: 9,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DetailScreen(index: index)));
              },
              child: Hero(
                tag: 'mandal-item-$index',
                child: Item(),
              ),
            );
          },
        ),
      ),
    );
  }
}
