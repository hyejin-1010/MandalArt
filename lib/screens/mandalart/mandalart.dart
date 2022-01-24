import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/common/functions.dart';
import 'package:madal_art/controllers/data_controller.dart';
import 'package:madal_art/controllers/setting_controller.dart';
import 'package:madal_art/screens/detail/detail.dart';
import 'package:madal_art/components/item.dart';
import 'package:madal_art/screens/mandalart/components/custom_drawer.dart';

class MandalArtScreen extends StatefulWidget {
  @override
  _MandalArtScreenState createState() => _MandalArtScreenState();
}

enum ViewType { ALL, TOP }

class _MandalArtScreenState extends State<MandalArtScreen> {
  final DataController _dataController = Get.find<DataController>();
  final SettingController _settingController = Get.find<SettingController>();
  late Size _size;
  ViewType _viewType = ViewType.TOP;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _size = MediaQuery.of(context).size;
  }

  Widget _buildTopView(int index) {
    return Material(
      color: Colors.transparent,
      child: Obx(() {
        double fontSize = _settingController.fontSize.value;
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            _dataController.mandalart[_dataController.mandalartId.value]?.items[4]?[index]?.content ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize + 3.0,
              fontWeight: index == 4 ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMandalArtItem(int index) {
    bool topView = _viewType == ViewType.TOP;

    return InkWell(
      onTap: () => _pushDetailView(index),
      child: Hero(
        tag: 'mandal-item-$index${topView ? '-4' : ''}',
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.secondaryContainer, width: 0.5),
            color: topView && index == 4 ? Theme.of(context).colorScheme.primary : Colors.transparent,
          ),
          alignment: Alignment.center,
          child: topView
            ? _buildTopView(index)
            : Item(group: index, allView: true),
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
          value: _viewType == ViewType.ALL,
          onChanged: _onChangeViewType,
        ),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: [IconButton(
        onPressed: _openEndDrawer,
        color: Colors.grey,
        icon: Icon(Icons.menu),
      )],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      endDrawer: CustomDrawer(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildViewTypeSwitchButton(),
            Obx(() {
              if (_dataController.currentMandalart == null) { return Container(); }
              return Center(child: _buildMandalArtAllView());
            }),
          ],
        ),
      ),
    );
  }

  void _pushDetailView(int index) {
    Get.to(() => DetailScreen(index: index), transition: Transition.fade, arguments: {
      'allView': _viewType == ViewType.ALL,
    });
  }

  void _openEndDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void _onChangeViewType(bool? value) {
    ViewType newValue = value == true ? ViewType.ALL : ViewType.TOP;
    if (value == null || _viewType == newValue) { return; }
    setState(() { _viewType = newValue; });
  }
}
