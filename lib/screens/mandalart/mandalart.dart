import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/common/fuctions.dart';
import 'package:madal_art/controllers/data_controller.dart';
import 'package:madal_art/screens/detail/detail.dart';
import 'package:madal_art/components/item.dart';

class MandalArtScreen extends StatefulWidget {
  @override
  _MandalArtScreenState createState() => _MandalArtScreenState();
}

enum ViewType {
  ALL,
  TOP,
}

class _MandalArtScreenState extends State<MandalArtScreen> {
  final DataController _dataController = Get.find<DataController>();
  late Size _size;
  ViewType _viewType = ViewType.ALL;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _size = MediaQuery.of(context).size;
  }

  Widget _buildTopView(int index) {
    return Material(
      color: Colors.transparent,
      child: Text(_dataController.data[4]?[index]?.content ?? ''),
    );
  }

  Widget _buildMandalArtItem(int index) {
    bool topView = _viewType == ViewType.TOP;
    return InkWell(
      onTap: () => _pushDetailView(index),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: topView && index == 4 ? Colors.amber : Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Hero(
          tag: 'mandal-item-$index',
          child: topView
            ? _buildTopView(index)
            : Item(group: index),
        ),
      ),
    );
  }

  Widget _buildMandalArtAllView() {
    final double mandalSize = Functions.getMandalSize(_size);

    return SizedBox(
      width: mandalSize,
      height: mandalSize,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
        ),
        physics: NeverScrollableScrollPhysics(),
        itemCount: 9,
        itemBuilder: (BuildContext context, int index) {
          return _buildMandalArtItem(index);
        },
      ),
    );
  }

  Widget _buildViewTypeSwitchButton() {
    return Switch(
      value: _viewType == ViewType.TOP,
      onChanged: (bool? value) {
        ViewType newValue = value == true ? ViewType.TOP : ViewType.ALL;
        if (value == null || _viewType == newValue) { return; }
        setState(() { _viewType = newValue; });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildViewTypeSwitchButton(),
            Center(child: _buildMandalArtAllView()),
          ],
        ),
      ),
    );
  }

  _pushDetailView(int index) {
    Get.to(DetailScreen(index: index), transition: Transition.fade);
  }
}
