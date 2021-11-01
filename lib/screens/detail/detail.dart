import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/common/fuctions.dart';
import 'package:madal_art/screens/mandalart/components/item.dart';
import 'package:madal_art/screens/detail/components/map.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({
    required this.index,
  });
  final int index;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

const Map<String, dynamic> ARROW_DATA = {
  'top': {
    'begin': Offset(0.0, -1.0),
    'index': -3,
  },
  'right': {
    'begin': Offset(1.0, 0.0),
    'index': 1,
  },
  'bottom': {
    'begin': Offset(0.0, 1.0),
    'index': 3,
  },
  'left': {
    'begin': Offset(-1.0, 0.0),
    'index': -1,
  },
};

class _DetailScreenState extends State<DetailScreen> {
  late Size size;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) {
    final double mandalSize = Functions.getMandalSize(size) - 100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 20,
            child: MandalArtMap(index: widget.index, size: 100.0),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (widget.index > 2)
                _buildArrowIconButton('top'),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.index % 3 != 0
                        ? _buildArrowIconButton('left')
                        : SizedBox(width: 40.0),
                    SizedBox(
                      width: mandalSize,
                      height: mandalSize,
                      child: Hero(
                        tag: 'mandal-item-${widget.index}',
                        child: Item(
                          group: widget.index,
                        ),
                      ),
                    ),
                    widget.index % 3 != 2
                        ? _buildArrowIconButton('right')
                        : SizedBox(width: 40.0),
                  ],
                ),
              ),
              if (widget.index < 6)
                _buildArrowIconButton('bottom'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArrowIconButton(String arrow) {
    IconData iconData = Icons.arrow_forward;
    switch (arrow) {
      case 'top':
        iconData = Icons.arrow_upward;
        break;
      case 'left':
        iconData = Icons.arrow_back;
        break;
      case 'bottom':
        iconData = Icons.arrow_downward;
        break;
    }

    return IconButton(
      onPressed: () => _clickArrow(arrow),
      icon: Icon(iconData),
    );
  }

  void _clickArrow (String arrow) {
    int arrowNum = ARROW_DATA[arrow]['index'] ?? 0;
    int index = widget.index + arrowNum;
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, __, ___) => DetailScreen(index: index),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const Offset end = Offset.zero;
        Offset begin = ARROW_DATA[arrow]?['begin'] ?? Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ));
  }
}
