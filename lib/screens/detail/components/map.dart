import 'package:flutter/material.dart';

class MandalArtMap extends StatelessWidget {
  const MandalArtMap({
    required this.index,
    required this.size,
  });

  final int index;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        itemCount: 9,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (BuildContext context, int i) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5), width: 0.3),
              color: index == i ? Theme.of(context).colorScheme.primary : Theme.of(context).backgroundColor,
            ),
          );
        },
      ),
    );
  }
}
