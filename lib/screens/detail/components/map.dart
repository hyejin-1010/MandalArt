import 'package:flutter/material.dart';

class MandalArtMap extends StatelessWidget {
  int index;
  double size;

  MandalArtMap({
    required this.index,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: GridView.builder(
        itemCount: 9,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (BuildContext context, int i) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              color: index == i ? Colors.amber : Colors.white,
            ),
          );
        },
      ),
    );
  }
}
