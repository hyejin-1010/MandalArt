import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/common/fuctions.dart';
import 'package:madal_art/controllers/data_controller.dart';
import 'package:madal_art/components/item.dart';
import 'package:madal_art/dialogs/edit_dialog.dart';
import 'package:madal_art/models/mandalart.dart';
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
    'index': -3,
    'transition': Transition.upToDown,
  },
  'right': {
    'index': 1,
    'transition': Transition.rightToLeft,
  },
  'bottom': {
    'index': 3,
    'transition': Transition.downToUp,
  },
  'left': {
    'index': -1,
    'transition': Transition.leftToRight,
  },
};

class _DetailScreenState extends State<DetailScreen> {
  final DataController _dataController = Get.find<DataController>();
  late Size size;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
  }

  Widget _buildMandalArtView() {
    return Hero(
      tag: 'mandal-item-${widget.index}',
      child: Item(
        group: widget.index,
        onClick: (int index) {
          MandalArtModel item = _dataController.data[widget.index]![index]!;
          Get.dialog(EditDialog(
            content: item.content,
            done: (String content) {
              _dataController.updateItem(widget.index, index, content);
              Get.back();
            },
          ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double mandalSize = Functions.getMandalSize(size) - 100;
    final EdgeInsets padding = MediaQuery.of(context).padding;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: padding.top,
            right: 20,
            child: MandalArtMap(index: widget.index, size: 100.0),
          ),
          Positioned(
            top: padding.top,
            left: 20,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.black,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: (padding.top + 100.0), bottom: padding.bottom),
            child: Column(
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
                        child: _buildMandalArtView(),
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
    dynamic arrowData = ARROW_DATA[arrow] ?? {};
    int arrowNum = arrowData['index'] ?? 0;
    Get.off(
      () => DetailScreen(index: widget.index + arrowNum),
      preventDuplicates: false,
      transition: arrowData['transition'],
    );
  }
}
